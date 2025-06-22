from fastapi import FastAPI, BackgroundTasks, HTTPException, File, UploadFile, Form, Depends
from fastapi.staticfiles import StaticFiles
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session, joinedload
from uuid import uuid4
import shutil
import os
from typing import List, Optional
from datetime import datetime, timedelta
import jwt
import bcrypt
from pydantic import BaseModel

from .models import assets as asset_models, database as db_models
from .core.database import engine, get_db, SessionLocal
from .core.jobs import create_job, get_job_status
from .core.pipeline import asset_pipeline
from .generators import stable_diffusion_3d

# --- Security Configuration ---
SECRET_KEY = "your-secret-key-here"  # In production, use environment variable
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

security = HTTPBearer()

# --- Pydantic Models for Auth ---
class UserLogin(BaseModel):
    email: str
    password: str

class UserRegister(BaseModel):
    username: str
    email: str
    password: str

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    email: Optional[str] = None

# --- Authentication Functions ---
def hash_password(password: str) -> str:
    """Hash a password using bcrypt."""
    salt = bcrypt.gensalt()
    return bcrypt.hashpw(password.encode('utf-8'), salt).decode('utf-8')

def verify_password(plain_password: str, hashed_password: str) -> bool:
    """Verify a password against its hash."""
    return bcrypt.checkpw(plain_password.encode('utf-8'), hashed_password.encode('utf-8'))

def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    """Create a JWT access token."""
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security), db: Session = Depends(get_db)):
    """Get the current authenticated user from JWT token."""
    try:
        payload = jwt.decode(credentials.credentials, SECRET_KEY, algorithms=[ALGORITHM])
        email: str = payload.get("sub")
        if email is None:
            raise HTTPException(status_code=401, detail="Invalid token")
        token_data = TokenData(email=email)
    except jwt.PyJWTError:
        raise HTTPException(status_code=401, detail="Invalid token")
    
    user = db.query(db_models.User).filter(db_models.User.email == token_data.email).first()
    if user is None:
        raise HTTPException(status_code=401, detail="User not found")
    return user

# --- Database Setup ---
db_models.Base.metadata.create_all(bind=engine)

def initialize_default_license_types():
    """Initialize default license types if they don't exist."""
    db = SessionLocal()
    try:
        # Check if license types already exist
        existing_count = db.query(db_models.LicenseType).count()
        if existing_count > 0:
            return  # Already initialized
        
        # Create default license types
        default_licenses = [
            {
                "name": "personal",
                "description": "Personal use only. No commercial usage allowed.",
                "allows_commercial_use": False,
                "allows_modification": False,
                "allows_redistribution": False,
                "requires_attribution": True,
                "max_users": 1,
                "max_revenue": None
            },
            {
                "name": "commercial",
                "description": "Commercial use allowed. No redistribution.",
                "allows_commercial_use": True,
                "allows_modification": False,
                "allows_redistribution": False,
                "requires_attribution": True,
                "max_users": 5,
                "max_revenue": 10000.0
            },
            {
                "name": "enterprise",
                "description": "Full commercial rights with modification and redistribution.",
                "allows_commercial_use": True,
                "allows_modification": True,
                "allows_redistribution": True,
                "requires_attribution": False,
                "max_users": None,
                "max_revenue": None
            }
        ]
        
        for license_data in default_licenses:
            license_type = db_models.LicenseType(**license_data)
            db.add(license_type)
        
        db.commit()
        print("Default license types initialized successfully.")
        
    except Exception as e:
        print(f"Error initializing license types: {e}")
        db.rollback()
    finally:
        db.close()

# Initialize default license types
initialize_default_license_types()

# --- App Setup ---
app = FastAPI(
    title="JambaM Avatar Factory API",
    description="API for generating, uploading, and processing 3D assets with community features.",
    version="0.2.0"
)

# --- Authentication Endpoints ---
@app.post("/api/v1/auth/register", response_model=Token)
async def register(user_data: UserRegister, db: Session = Depends(get_db)):
    """Register a new user."""
    # Check if user already exists
    existing_user = db.query(db_models.User).filter(
        (db_models.User.email == user_data.email) | 
        (db_models.User.username == user_data.username)
    ).first()
    
    if existing_user:
        raise HTTPException(status_code=400, detail="User already exists")
    
    # Hash password and create user
    hashed_password = hash_password(user_data.password)
    db_user = db_models.User(
        username=user_data.username,
        email=user_data.email,
        password_hash=hashed_password
    )
    
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    
    # Create access token
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": db_user.email}, expires_delta=access_token_expires
    )
    
    return {"access_token": access_token, "token_type": "bearer"}

@app.post("/api/v1/auth/login", response_model=Token)
async def login(user_credentials: UserLogin, db: Session = Depends(get_db)):
    """Login user and return JWT token."""
    # Find user by email
    user = db.query(db_models.User).filter(db_models.User.email == user_credentials.email).first()
    
    if not user or not verify_password(user_credentials.password, user.password_hash):
        raise HTTPException(status_code=401, detail="Incorrect email or password")
    
    if not user.is_active:
        raise HTTPException(status_code=401, detail="User account is disabled")
    
    # Update last login
    user.last_login = datetime.utcnow()
    db.commit()
    
    # Create access token
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.email}, expires_delta=access_token_expires
    )
    
    return {"access_token": access_token, "token_type": "bearer"}

@app.get("/api/v1/auth/me")
async def get_current_user_info(current_user: db_models.User = Depends(get_current_user)):
    """Get current user information."""
    return {
        "id": current_user.id,
        "username": current_user.username,
        "email": current_user.email,
        "role": current_user.role,
        "is_verified": current_user.is_verified,
        "created_at": current_user.created_at
    }

# --- Static File Serving ---
os.makedirs("static/generated", exist_ok=True)
app.mount("/static", StaticFiles(directory="static"), name="static")


# --- API Endpoints ---
@app.post("/api/v1/assets/generate", response_model=asset_models.GenerateInitialResponse)
async def generate_asset(req: asset_models.GenerateRequest, background_tasks: BackgroundTasks, db: Session = Depends(get_db)):
    """
    Starts a new asset generation job from a text prompt.
    """
    job_id = str(uuid4())
    create_job(job_id)
    background_tasks.add_task(asset_pipeline, job_id=job_id, db=db, request_data=req)
    return {
        "jobId": job_id,
        "status": "pending",
        "statusUrl": f"/api/v1/assets/jobs/{job_id}"
    }

@app.post("/api/v1/assets/upload", response_model=asset_models.GenerateInitialResponse)
async def upload_asset(
    background_tasks: BackgroundTasks,
    file: UploadFile = File(...), 
    animation: str = Form("[]"), # JSON string for list
    convert_to: str = Form("glb")
):
    """
    Starts a new asset processing job from an uploaded file.
    """
    job_id = str(uuid4())
    create_job(job_id)

    upload_dir = "uploads"
    os.makedirs(upload_dir, exist_ok=True)
    file_path = os.path.join(upload_dir, f"{job_id}_{file.filename}")
    
    with open(file_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)
        
    import json
    animation_list = json.loads(animation)

    background_tasks.add_task(asset_pipeline, job_id, uploaded_file_path=file_path, animation=animation_list, convert_to=convert_to)
    
    return {
        "jobId": job_id,
        "status": "pending",
        "statusUrl": f"/api/v1/assets/jobs/{job_id}"
    }

@app.get("/api/v1/assets/jobs/{job_id}", response_model=asset_models.JobStatusResponse)
async def get_job(job_id: str):
    """
    Retrieves the status and result of a specific job.
    """
    status = get_job_status(job_id)
    if status.get("status") == "not_found":
        raise HTTPException(status_code=404, detail="Job not found")
    return status

# --- Community Endpoints ---
@app.get("/api/v1/assets", response_model=List[asset_models.AssetResponse])
def get_public_assets(skip: int = 0, limit: int = 20, db: Session = Depends(get_db)):
    """
    Get a list of public assets for the community hub.
    """
    assets = db.query(db_models.Asset).filter(db_models.Asset.is_public == True).offset(skip).limit(limit).all()
    return assets

@app.get("/api/v1/assets/{asset_id}", response_model=asset_models.AssetResponse)
def get_asset_details(asset_id: int, db: Session = Depends(get_db)):
    """
    Get detailed information for a single asset.
    """
    asset = db.query(db_models.Asset).filter(db_models.Asset.id == asset_id).first()
    if not asset:
        raise HTTPException(status_code=404, detail="Asset not found")
    return asset

@app.put("/api/v1/assets/{asset_id}", response_model=asset_models.AssetResponse)
def update_asset_details(
    asset_id: int, 
    name: str, 
    description: str, 
    is_public: bool, 
    price: float = 0.0,
    is_for_sale: bool = False,
    db: Session = Depends(get_db)
):
    """
    Update details of an asset including marketplace settings.
    """
    asset = db.query(db_models.Asset).filter(db_models.Asset.id == asset_id).first()
    if not asset:
        raise HTTPException(status_code=404, detail="Asset not found")
    asset.name = name
    asset.description = description
    asset.is_public = is_public
    asset.price = price
    asset.is_for_sale = is_for_sale
    db.commit()
    db.refresh(asset)
    return asset

@app.post("/api/v1/assets/{asset_id}/remix", response_model=asset_models.GenerateInitialResponse)
async def remix_asset(asset_id: int, req: asset_models.GenerateRequest, background_tasks: BackgroundTasks, db: Session = Depends(get_db)):
    """
    Create a new asset based on an existing one (remix).
    """
    original_asset = db.query(db_models.Asset).filter(db_models.Asset.id == asset_id).first()
    if not original_asset:
        raise HTTPException(status_code=404, detail="Asset to remix not found")
    
    job_id = str(uuid4())
    create_job(job_id)
    background_tasks.add_task(asset_pipeline, job_id=job_id, db=db, request_data=req, remix_of_id=asset_id)
    return {"jobId": job_id, "status": "pending", "statusUrl": f"/api/v1/assets/jobs/{job_id}"}

# --- New Endpoints for Rating and Tagging ---

@app.post("/api/v1/assets/{asset_id}/rate")
def rate_asset(asset_id: int, req: asset_models.RateRequest, db: Session = Depends(get_db)):
    """
    Rate an asset. A user can only rate an asset once.
    """
    asset = db.query(db_models.Asset).filter(db_models.Asset.id == asset_id).first()
    if not asset:
        raise HTTPException(status_code=404, detail="Asset not found")
    
    # Check if user already rated this asset
    existing_rating = db.query(db_models.Rating).filter(
        db_models.Rating.asset_id == asset_id,
        db_models.Rating.user_id == req.user_id
    ).first()

    if existing_rating:
        existing_rating.score = req.score
        db.commit()
        return {"message": "Rating updated successfully."}

    new_rating = db_models.Rating(
        asset_id=asset_id,
        user_id=req.user_id,
        score=req.score
    )
    db.add(new_rating)
    db.commit()
    return {"message": "Asset rated successfully."}

@app.post("/api/v1/assets/{asset_id}/tags")
def add_tags_to_asset(asset_id: int, req: asset_models.TagRequest, db: Session = Depends(get_db)):
    """
    Add one or more tags to an asset.
    """
    asset = db.query(db_models.Asset).options(joinedload(db_models.Asset.tags)).filter(db_models.Asset.id == asset_id).first()
    if not asset:
        raise HTTPException(status_code=404, detail="Asset not found")

    current_tag_names = {tag.name for tag in asset.tags}
    
    for tag_name in req.tags:
        if tag_name in current_tag_names:
            continue

        tag = db.query(db_models.Tag).filter(db_models.Tag.name == tag_name).first()
        if not tag:
            tag = db_models.Tag(name=tag_name)
            db.add(tag)
        asset.tags.append(tag)
        current_tag_names.add(tag_name)

    db.commit()
    return {"message": f"Tags updated for asset {asset_id}."}

# --- Marketplace Endpoints ---

@app.get("/api/v1/marketplace", response_model=List[asset_models.MarketplaceAssetResponse])
def get_marketplace_listings(skip: int = 0, limit: int = 20, db: Session = Depends(get_db)):
    """
    Get a list of assets available for purchase in the marketplace.
    Filters out expired or sold-out limited assets.
    """
    now = datetime.utcnow()
    assets = db.query(db_models.Asset).filter(
        db_models.Asset.is_for_sale == True,
        db_models.Asset.price > 0,
        # Check if asset is still available (not expired)
        (db_models.Asset.available_until.is_(None) | (db_models.Asset.available_until > now)),
        # Check if asset is not sold out
        (db_models.Asset.max_quantity.is_(None) | (db_models.Asset.current_quantity_sold < db_models.Asset.max_quantity))
    ).offset(skip).limit(limit).all()
    return assets

@app.post("/api/v1/assets/{asset_id}/buy")
def buy_asset(asset_id: int, req: asset_models.BuyRequest, db: Session = Depends(get_db)):
    """
    Purchase an asset with limitation checks.
    """
    asset = db.query(db_models.Asset).filter(db_models.Asset.id == asset_id).first()
    if not asset:
        raise HTTPException(status_code=404, detail="Asset not found")
    
    if not asset.is_for_sale:
        raise HTTPException(status_code=400, detail="This asset is not for sale")
    
    if asset.price <= 0:
        raise HTTPException(status_code=400, detail="Invalid price for this asset")
    
    # Check if asset is expired
    if asset.available_until and asset.available_until < datetime.utcnow():
        raise HTTPException(status_code=400, detail="This asset is no longer available for purchase")
    
    # Check if asset is sold out
    if asset.max_quantity and asset.current_quantity_sold >= asset.max_quantity:
        raise HTTPException(status_code=400, detail="This asset is sold out")
    
    # Check organization exclusivity
    if asset.exclusive_to_organization_id:
        user_membership = db.query(db_models.OrganizationMembership).filter(
            db_models.OrganizationMembership.organization_id == asset.exclusive_to_organization_id,
            db_models.OrganizationMembership.user_id == req.buyer_id
        ).first()
        if not user_membership:
            raise HTTPException(status_code=403, detail="This asset is exclusive to organization members only")
    
    # Check if user already owns this asset
    existing_ownership = db.query(db_models.AssetOwnership).filter(
        db_models.AssetOwnership.asset_id == asset_id,
        db_models.AssetOwnership.buyer_id == req.buyer_id
    ).first()
    
    if existing_ownership:
        raise HTTPException(status_code=400, detail="You already own this asset")
    
    # In a real app, we'd validate the buyer has enough credits/currency
    # and transfer the credits from buyer to seller
    
    # Create ownership record
    ownership = db_models.AssetOwnership(
        asset_id=asset_id,
        buyer_id=req.buyer_id,
        purchase_price=asset.price
    )
    db.add(ownership)
    
    # Update quantity sold
    asset.current_quantity_sold += 1
    
    db.commit()
    
    return {
        "message": "Asset purchased successfully",
        "asset_id": asset_id,
        "purchase_price": asset.price,
        "remaining_quantity": asset.max_quantity - asset.current_quantity_sold if asset.max_quantity else None
    }

@app.get("/api/v1/users/{user_id}/purchases")
def get_user_purchases(user_id: int, db: Session = Depends(get_db)):
    """
    Get all assets purchased by a specific user.
    """
    purchases = db.query(db_models.AssetOwnership).filter(
        db_models.AssetOwnership.buyer_id == user_id
    ).all()
    return purchases

@app.get("/api/v1/users/{user_id}/sales")
def get_user_sales(user_id: int, db: Session = Depends(get_db)):
    """
    Get all assets sold by a specific user (creator earnings).
    """
    sales = db.query(db_models.AssetOwnership).join(db_models.Asset).filter(
        db_models.Asset.owner_id == user_id
    ).all()
    return sales

# --- Organization Endpoints ---

@app.post("/api/v1/organizations", response_model=asset_models.OrganizationResponse)
def create_organization(req: asset_models.OrganizationRequest, db: Session = Depends(get_db)):
    """
    Create a new organization.
    """
    org = db_models.Organization(
        name=req.name,
        description=req.description,
        is_public=req.is_public
    )
    db.add(org)
    db.commit()
    db.refresh(org)
    return org

@app.get("/api/v1/organizations", response_model=List[asset_models.OrganizationResponse])
def get_organizations(db: Session = Depends(get_db)):
    """
    Get all public organizations.
    """
    orgs = db.query(db_models.Organization).filter(db_models.Organization.is_public == True).all()
    return orgs

@app.post("/api/v1/organizations/{org_id}/join")
def join_organization(org_id: int, user_id: int, db: Session = Depends(get_db)):
    """
    Join an organization.
    """
    org = db.query(db_models.Organization).filter(db_models.Organization.id == org_id).first()
    if not org:
        raise HTTPException(status_code=404, detail="Organization not found")
    
    existing_membership = db.query(db_models.OrganizationMembership).filter(
        db_models.OrganizationMembership.organization_id == org_id,
        db_models.OrganizationMembership.user_id == user_id
    ).first()
    
    if existing_membership:
        raise HTTPException(status_code=400, detail="Already a member of this organization")
    
    membership = db_models.OrganizationMembership(
        organization_id=org_id,
        user_id=user_id,
        role="member"
    )
    db.add(membership)
    db.commit()
    return {"message": "Successfully joined organization"}

# --- Limited Asset Management ---

@app.put("/api/v1/assets/{asset_id}/limitations")
def update_asset_limitations(
    asset_id: int,
    max_quantity: Optional[int] = None,
    available_until: Optional[datetime] = None,
    exclusive_to_organization_id: Optional[int] = None,
    exclusivity_level: str = "public",
    db: Session = Depends(get_db)
):
    """
    Update limitation settings for an asset.
    """
    asset = db.query(db_models.Asset).filter(db_models.Asset.id == asset_id).first()
    if not asset:
        raise HTTPException(status_code=404, detail="Asset not found")
    
    if max_quantity is not None:
        if max_quantity < asset.current_quantity_sold:
            raise HTTPException(status_code=400, detail="Cannot set max_quantity below current sales")
        asset.max_quantity = max_quantity
    
    if available_until is not None:
        asset.available_until = available_until
    
    if exclusive_to_organization_id is not None:
        # Verify organization exists
        org = db.query(db_models.Organization).filter(db_models.Organization.id == exclusive_to_organization_id).first()
        if not org:
            raise HTTPException(status_code=404, detail="Organization not found")
        asset.exclusive_to_organization_id = exclusive_to_organization_id
    
    asset.exclusivity_level = exclusivity_level
    
    db.commit()
    db.refresh(asset)
    return {"message": "Asset limitations updated successfully"}

# --- Health Check ---
@app.get("/health")
def health_check():
    return {"status": "ok"}

# --- License System Endpoints ---

@app.post("/api/v1/license-types", response_model=asset_models.LicenseTypeResponse)
def create_license_type(req: asset_models.LicenseTypeRequest, db: Session = Depends(get_db)):
    """
    Create a new license type (admin function).
    """
    license_type = db_models.LicenseType(
        name=req.name,
        description=req.description,
        allows_commercial_use=req.allows_commercial_use,
        allows_modification=req.allows_modification,
        allows_redistribution=req.allows_redistribution,
        requires_attribution=req.requires_attribution,
        max_users=req.max_users,
        max_revenue=req.max_revenue
    )
    db.add(license_type)
    db.commit()
    db.refresh(license_type)
    return license_type

@app.get("/api/v1/license-types", response_model=List[asset_models.LicenseTypeResponse])
def get_license_types(db: Session = Depends(get_db)):
    """
    Get all available license types.
    """
    license_types = db.query(db_models.LicenseType).all()
    return license_types

@app.post("/api/v1/assets/{asset_id}/licenses", response_model=asset_models.AssetLicenseResponse)
def add_license_to_asset(asset_id: int, req: asset_models.AssetLicenseRequest, db: Session = Depends(get_db)):
    """
    Add a license option to an asset.
    """
    asset = db.query(db_models.Asset).filter(db_models.Asset.id == asset_id).first()
    if not asset:
        raise HTTPException(status_code=404, detail="Asset not found")
    
    license_type = db.query(db_models.LicenseType).filter(db_models.LicenseType.id == req.license_type_id).first()
    if not license_type:
        raise HTTPException(status_code=404, detail="License type not found")
    
    # Check if this license type is already added to this asset
    existing_license = db.query(db_models.AssetLicense).filter(
        db_models.AssetLicense.asset_id == asset_id,
        db_models.AssetLicense.license_type_id == req.license_type_id
    ).first()
    
    if existing_license:
        raise HTTPException(status_code=400, detail="This license type is already available for this asset")
    
    asset_license = db_models.AssetLicense(
        asset_id=asset_id,
        license_type_id=req.license_type_id,
        price=req.price,
        is_available=True
    )
    db.add(asset_license)
    db.commit()
    db.refresh(asset_license)
    return asset_license

@app.get("/api/v1/assets/{asset_id}/licenses", response_model=List[asset_models.AssetLicenseResponse])
def get_asset_licenses(asset_id: int, db: Session = Depends(get_db)):
    """
    Get all available licenses for an asset.
    """
    licenses = db.query(db_models.AssetLicense).filter(
        db_models.AssetLicense.asset_id == asset_id,
        db_models.AssetLicense.is_available == True
    ).all()
    return licenses

@app.post("/api/v1/licenses/{license_id}/purchase")
def purchase_license(license_id: int, req: asset_models.LicensePurchaseRequest, db: Session = Depends(get_db)):
    """
    Purchase a license for an asset.
    """
    asset_license = db.query(db_models.AssetLicense).filter(db_models.AssetLicense.id == license_id).first()
    if not asset_license:
        raise HTTPException(status_code=404, detail="License not found")
    
    if not asset_license.is_available:
        raise HTTPException(status_code=400, detail="This license is not available for purchase")
    
    # Check if user already has this license
    existing_purchase = db.query(db_models.LicensePurchase).filter(
        db_models.LicensePurchase.asset_license_id == license_id,
        db_models.LicensePurchase.buyer_id == req.buyer_id
    ).first()
    
    if existing_purchase:
        raise HTTPException(status_code=400, detail="You already own this license")
    
    # In a real app, we'd validate the buyer has enough credits/currency
    # and transfer the credits from buyer to seller
    
    # Create license purchase record
    license_purchase = db_models.LicensePurchase(
        asset_license_id=license_id,
        buyer_id=req.buyer_id,
        purchase_price=asset_license.price,
        expires_at=None  # Perpetual license for now
    )
    db.add(license_purchase)
    db.commit()
    
    return {
        "message": "License purchased successfully",
        "license_id": license_id,
        "purchase_price": asset_license.price,
        "license_type": asset_license.license_type.name
    }

@app.get("/api/v1/users/{user_id}/licenses", response_model=List[asset_models.LicensePurchaseResponse])
def get_user_licenses(user_id: int, db: Session = Depends(get_db)):
    """
    Get all licenses owned by a user.
    """
    licenses = db.query(db_models.LicensePurchase).filter(
        db_models.LicensePurchase.buyer_id == user_id
    ).all()
    return licenses

@app.post("/api/v1/licenses/validate")
def validate_license_usage(asset_id: int, user_id: int, usage_type: str, db: Session = Depends(get_db)):
    """
    Validate if a user can use an asset for a specific purpose.
    """
    # Find user's license for this asset
    user_license = db.query(db_models.LicensePurchase).join(db_models.AssetLicense).filter(
        db_models.AssetLicense.asset_id == asset_id,
        db_models.LicensePurchase.buyer_id == user_id
    ).first()
    
    if not user_license:
        return {"valid": False, "reason": "No license found for this asset"}
    
    license_type = user_license.asset_license.license_type
    
    # Check if license is expired
    if user_license.expires_at and user_license.expires_at < datetime.utcnow():
        return {"valid": False, "reason": "License has expired"}
    
    # Validate usage based on license type
    if usage_type == "commercial" and not license_type.allows_commercial_use:
        return {"valid": False, "reason": "License does not allow commercial use"}
    
    if usage_type == "modification" and not license_type.allows_modification:
        return {"valid": False, "reason": "License does not allow modification"}
    
    if usage_type == "redistribution" and not license_type.allows_redistribution:
        return {"valid": False, "reason": "License does not allow redistribution"}
    
    return {
        "valid": True,
        "license_type": license_type.name,
        "requires_attribution": license_type.requires_attribution
    }

@app.get("/api/v1/assets/{asset_id}/preview/{platform}")
def get_asset_preview(asset_id: int, platform: str, db: Session = Depends(get_db)):
    """
    Get Gaussian Splat preview for an asset on a specific platform.
    Platforms: web, desktop, android
    """
    asset = db.query(db_models.Asset).filter(db_models.Asset.id == asset_id).first()
    if not asset:
        raise HTTPException(status_code=404, detail="Asset not found")
    
    if platform not in ["web", "desktop", "android"]:
        raise HTTPException(status_code=400, detail="Invalid platform. Use: web, desktop, android")
    
    # Extract job_id from model_url (assuming format: /static/generated/{job_id}/...)
    model_url = asset.model_url
    if not model_url or "/static/generated/" not in model_url:
        raise HTTPException(status_code=404, detail="Asset preview not available")
    
    job_id = model_url.split("/static/generated/")[1].split("/")[0]
    preview_path = f"static/generated/{job_id}/splats/splats_{platform}.json"
    
    if platform == "desktop":
        preview_path = f"static/generated/{job_id}/splats/splats_{platform}.bin"
    
    if not os.path.exists(preview_path):
        raise HTTPException(status_code=404, detail="Preview not generated for this platform")
    
    # Return the file directly
    from fastapi.responses import FileResponse
    return FileResponse(preview_path, media_type="application/octet-stream")

@app.get("/api/v1/generation/styles")
def get_available_styles():
    """
    Get all available generation styles with their descriptions.
    """
    styles = stable_diffusion_3d.sd3d_generator.get_available_styles()
    style_info = {}
    
    for style in styles:
        style_info[style] = stable_diffusion_3d.sd3d_generator.get_style_info(style)
    
    return {
        "available_styles": styles,
        "style_info": style_info
    }

@app.get("/api/v1/generation/styles/{style}")
def get_style_info(style: str):
    """
    Get detailed information about a specific generation style.
    """
    if style not in stable_diffusion_3d.sd3d_generator.get_available_styles():
        raise HTTPException(status_code=404, detail="Style not found")
    
    return stable_diffusion_3d.sd3d_generator.get_style_info(style)

# --- NEW ENHANCED ENDPOINTS ---

@app.post("/api/v1/users", response_model=asset_models.UserResponse)
def create_user(req: asset_models.UserRequest, db: Session = Depends(get_db)):
    """
    Create a new user account.
    """
    # Check if user already exists
    existing_user = db.query(db_models.User).filter(db_models.User.email == req.email).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="User with this email already exists")
    
    user = db_models.User(
        username=req.username,
        email=req.email,
        avatar_url=req.avatar_url,
        bio=req.bio,
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    return user

@app.get("/api/v1/users/{user_id}", response_model=asset_models.UserResponse)
def get_user(user_id: int, db: Session = Depends(get_db)):
    """
    Get user details by ID.
    """
    user = db.query(db_models.User).filter(db_models.User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@app.put("/api/v1/users/{user_id}", response_model=asset_models.UserResponse)
def update_user(user_id: int, req: asset_models.UserUpdateRequest, db: Session = Depends(get_db)):
    """
    Update user profile.
    """
    user = db.query(db_models.User).filter(db_models.User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    if req.username:
        user.username = req.username
    if req.avatar_url is not None:
        user.avatar_url = req.avatar_url
    if req.bio is not None:
        user.bio = req.bio
    
    db.commit()
    db.refresh(user)
    return user

@app.get("/api/v1/users/{user_id}/assets", response_model=List[asset_models.AssetResponse])
def get_user_assets(user_id: int, skip: int = 0, limit: int = 20, db: Session = Depends(get_db)):
    """
    Get all assets created by a user.
    """
    assets = db.query(db_models.Asset).filter(
        db_models.Asset.owner_id == user_id
    ).offset(skip).limit(limit).all()
    return assets

@app.get("/api/v1/users/{user_id}/favorites", response_model=List[asset_models.AssetResponse])
def get_user_favorites(user_id: int, skip: int = 0, limit: int = 20, db: Session = Depends(get_db)):
    """
    Get user's favorite assets.
    """
    favorites = db.query(db_models.Asset).join(
        db_models.UserAsset, db_models.Asset.id == db_models.UserAsset.asset_id
    ).filter(
        db_models.UserAsset.user_id == user_id,
        db_models.UserAsset.relationship_type == "favorite"
    ).offset(skip).limit(limit).all()
    return favorites

@app.post("/api/v1/assets/{asset_id}/favorite")
def toggle_favorite(asset_id: int, user_id: int, db: Session = Depends(get_db)):
    """
    Toggle favorite status for an asset.
    """
    asset = db.query(db_models.Asset).filter(db_models.Asset.id == asset_id).first()
    if not asset:
        raise HTTPException(status_code=404, detail="Asset not found")
    
    existing_favorite = db.query(db_models.UserAsset).filter(
        db_models.UserAsset.user_id == user_id,
        db_models.UserAsset.asset_id == asset_id,
        db_models.UserAsset.relationship_type == "favorite"
    ).first()
    
    if existing_favorite:
        db.delete(existing_favorite)
        message = "Removed from favorites"
    else:
        favorite = db_models.UserAsset(
            user_id=user_id,
            asset_id=asset_id,
            relationship_type="favorite"
        )
        db.add(favorite)
        message = "Added to favorites"
    
    db.commit()
    return {"message": message}

# --- COMMUNITY FEATURES ---

@app.post("/api/v1/community/themes", response_model=asset_models.CommunityThemeResponse)
def create_community_theme(req: asset_models.CommunityThemeRequest, db: Session = Depends(get_db)):
    """
    Create a new community theme for asset generation.
    """
    theme = db_models.CommunityTheme(
        title=req.title,
        description=req.description,
        prompt=req.prompt,
        style=req.style,
        quality=req.quality,
        created_by=req.created_by,
    )
    db.add(theme)
    db.commit()
    db.refresh(theme)
    return theme

@app.get("/api/v1/community/themes", response_model=List[asset_models.CommunityThemeResponse])
def get_community_themes(skip: int = 0, limit: int = 20, db: Session = Depends(get_db)):
    """
    Get community themes sorted by votes.
    """
    themes = db.query(db_models.CommunityTheme).order_by(
        db_models.CommunityTheme.votes.desc(),
        db_models.CommunityTheme.created_at.desc()
    ).offset(skip).limit(limit).all()
    return themes

@app.post("/api/v1/community/themes/{theme_id}/vote")
def vote_theme(theme_id: int, user_id: int, db: Session = Depends(get_db)):
    """
    Vote for a community theme.
    """
    theme = db.query(db_models.CommunityTheme).filter(db_models.CommunityTheme.id == theme_id).first()
    if not theme:
        raise HTTPException(status_code=404, detail="Theme not found")
    
    # Check if user already voted
    existing_vote = db.query(db_models.ThemeVote).filter(
        db_models.ThemeVote.theme_id == theme_id,
        db_models.ThemeVote.user_id == user_id
    ).first()
    
    if existing_vote:
        # Remove vote
        db.delete(existing_vote)
        theme.votes -= 1
        message = "Vote removed"
    else:
        # Add vote
        vote = db_models.ThemeVote(
            theme_id=theme_id,
            user_id=user_id
        )
        db.add(vote)
        theme.votes += 1
        message = "Vote added"
    
    db.commit()
    return {"message": message, "votes": theme.votes}

# --- OFFLINE SYNC SUPPORT ---

@app.post("/api/v1/sync/batch")
def batch_sync(requests: List[asset_models.SyncRequest], db: Session = Depends(get_db)):
    """
    Process multiple sync requests in a single call for offline support.
    """
    results = []
    
    for sync_request in requests:
        try:
            if sync_request.operation == "create_asset":
                # Handle asset creation
                asset = db_models.Asset(
                    name=sync_request.data.get("name", "Synced Asset"),
                    description=sync_request.data.get("description"),
                    prompt=sync_request.data.get("prompt"),
                    style=sync_request.data.get("style"),
                    quality=sync_request.data.get("quality"),
                    owner_id=sync_request.data.get("user_id"),
                    is_public=sync_request.data.get("is_public", False),
                )
                db.add(asset)
                db.commit()
                db.refresh(asset)
                results.append({
                    "id": sync_request.id,
                    "status": "success",
                    "result": {"asset_id": asset.id}
                })
                
            elif sync_request.operation == "rate_asset":
                # Handle asset rating
                rating = db_models.AssetRating(
                    asset_id=sync_request.data.get("asset_id"),
                    user_id=sync_request.data.get("user_id"),
                    score=sync_request.data.get("score"),
                )
                db.add(rating)
                db.commit()
                results.append({
                    "id": sync_request.id,
                    "status": "success"
                })
                
            elif sync_request.operation == "purchase_license":
                # Handle license purchase
                purchase = db_models.LicensePurchase(
                    asset_license_id=sync_request.data.get("license_id"),
                    buyer_id=sync_request.data.get("buyer_id"),
                    purchase_price=sync_request.data.get("price", 0.0),
                )
                db.add(purchase)
                db.commit()
                results.append({
                    "id": sync_request.id,
                    "status": "success"
                })
                
        except Exception as e:
            results.append({
                "id": sync_request.id,
                "status": "error",
                "error": str(e)
            })
    
    return {"results": results}

@app.get("/api/v1/sync/status")
def get_sync_status():
    """
    Get current sync status and pending operations count.
    """
    # This would typically check the sync queue
    return {
        "status": "idle",
        "pending_operations": 0,
        "last_sync": datetime.now().isoformat(),
        "sync_enabled": True
    }

# --- ENHANCED ASSET FEATURES ---

@app.post("/api/v1/assets/{asset_id}/download")
def download_asset(asset_id: int, user_id: int, db: Session = Depends(get_db)):
    """
    Record asset download and return download URL.
    """
    asset = db.query(db_models.Asset).filter(db_models.Asset.id == asset_id).first()
    if not asset:
        raise HTTPException(status_code=404, detail="Asset not found")
    
    # Check if user has permission to download
    if not asset.is_public and asset.owner_id != user_id:
        # Check if user has purchased the asset
        purchase = db.query(db_models.AssetPurchase).filter(
            db_models.AssetPurchase.asset_id == asset_id,
            db_models.AssetPurchase.buyer_id == user_id
        ).first()
        
        if not purchase:
            raise HTTPException(status_code=403, detail="Access denied")
    
    # Record download
    download = db_models.AssetDownload(
        asset_id=asset_id,
        user_id=user_id,
        downloaded_at=datetime.now()
    )
    db.add(download)
    db.commit()
    
    return {
        "download_url": asset.model_url,
        "thumbnail_url": asset.thumbnail_url,
        "file_size": asset.file_size if hasattr(asset, 'file_size') else None
    }

@app.get("/api/v1/assets/{asset_id}/analytics")
def get_asset_analytics(asset_id: int, db: Session = Depends(get_db)):
    """
    Get analytics for an asset (downloads, views, ratings, etc.).
    """
    asset = db.query(db_models.Asset).filter(db_models.Asset.id == asset_id).first()
    if not asset:
        raise HTTPException(status_code=404, detail="Asset not found")
    
    # Get download count
    download_count = db.query(db_models.AssetDownload).filter(
        db_models.AssetDownload.asset_id == asset_id
    ).count()
    
    # Get rating statistics
    ratings = db.query(db_models.AssetRating).filter(
        db_models.AssetRating.asset_id == asset_id
    ).all()
    
    avg_rating = 0
    rating_count = len(ratings)
    if rating_count > 0:
        avg_rating = sum(r.score for r in ratings) / rating_count
    
    # Get favorite count
    favorite_count = db.query(db_models.UserAsset).filter(
        db_models.UserAsset.asset_id == asset_id,
        db_models.UserAsset.relationship_type == "favorite"
    ).count()
    
    return {
        "asset_id": asset_id,
        "downloads": download_count,
        "rating_count": rating_count,
        "average_rating": round(avg_rating, 2),
        "favorites": favorite_count,
        "views": 0,  # Would be implemented with view tracking
        "created_at": asset.created_at.isoformat() if asset.created_at else None
    }

# --- SEARCH AND FILTERING ---

@app.get("/api/v1/search/assets")
def search_assets(
    q: str = "",
    style: Optional[str] = None,
    quality: Optional[str] = None,
    min_rating: Optional[float] = None,
    max_price: Optional[float] = None,
    tags: Optional[str] = None,
    skip: int = 0,
    limit: int = 20,
    db: Session = Depends(get_db)
):
    """
    Search assets with various filters.
    """
    query = db.query(db_models.Asset).filter(db_models.Asset.is_public == True)
    
    if q:
        query = query.filter(
            db_models.Asset.name.contains(q) | 
            db_models.Asset.description.contains(q)
        )
    
    if style:
        query = query.filter(db_models.Asset.style == style)
    
    if quality:
        query = query.filter(db_models.Asset.quality == quality)
    
    if min_rating:
        # This would require a join with ratings table
        pass
    
    if max_price:
        query = query.filter(db_models.Asset.price <= max_price)
    
    if tags:
        tag_list = tags.split(",")
        # This would require a join with tags table
        pass
    
    assets = query.offset(skip).limit(limit).all()
    return assets

# --- RECOMMENDATIONS ---

@app.get("/api/v1/recommendations/{user_id}")
def get_recommendations(user_id: int, limit: int = 10, db: Session = Depends(get_db)):
    """
    Get personalized asset recommendations for a user.
    """
    # Get user's favorite styles
    user_assets = db.query(db_models.Asset).filter(
        db_models.Asset.owner_id == user_id
    ).all()
    
    # Get user's favorite assets
    favorite_assets = db.query(db_models.Asset).join(
        db_models.UserAsset, db_models.Asset.id == db_models.UserAsset.asset_id
    ).filter(
        db_models.UserAsset.user_id == user_id,
        db_models.UserAsset.relationship_type == "favorite"
    ).all()
    
    # Simple recommendation: assets with similar styles
    styles = set()
    for asset in user_assets + favorite_assets:
        if asset.style:
            styles.add(asset.style)
    
    if styles:
        recommendations = db.query(db_models.Asset).filter(
            db_models.Asset.style.in_(list(styles)),
            db_models.Asset.is_public == True,
            db_models.Asset.owner_id != user_id
        ).limit(limit).all()
    else:
        # Fallback to popular assets
        recommendations = db.query(db_models.Asset).filter(
            db_models.Asset.is_public == True
        ).order_by(db_models.Asset.rating.desc()).limit(limit).all()
    
    return recommendations 