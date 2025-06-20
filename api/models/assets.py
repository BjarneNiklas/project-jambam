from pydantic import BaseModel, Field
from typing import List, Optional
from datetime import datetime

class GenerateRequest(BaseModel):
    prompt: str = Field(..., description="Text description of the 3D asset to generate")
    style: str = Field(
        default="realistic", 
        description="Visual style: realistic, stylized, cartoon, anime, voxel, low_poly, sci_fi, fantasy, cyberpunk, steampunk"
    )
    quality: str = Field(
        default="standard", 
        description="Generation quality: draft, standard, high"
    )
    output_format: Optional[str] = Field(default='glb', description="The desired output format for the final model.")
    animation: Optional[List[str]] = Field(default=[], description="A list of standard animations to apply.")
    high_quality: bool = Field(default=False, description="Legacy field for backward compatibility")

class JobResult(BaseModel):
    modelUrl: Optional[str] = None
    usdUrl: Optional[str] = None
    thumbnailUrl: Optional[str] = None

class JobStatusResponse(BaseModel):
    jobId: str
    status: str
    progress: int = 0
    details: Optional[str] = None
    result: Optional[JobResult] = None

class GenerateInitialResponse(BaseModel):
    jobId: str
    status: str
    statusUrl: str

# --- New Models for Community Features ---

class RateRequest(BaseModel):
    """Request model for rating an asset."""
    score: int = Field(..., ge=1, le=5, description="The rating score, from 1 to 5.")
    # In a real app, user_id would be inferred from the auth token
    user_id: int = Field(..., description="The ID of the user giving the rating.")

class TagRequest(BaseModel):
    """Request model for adding tags to an asset."""
    tags: List[str] = Field(..., min_items=1, description="A list of tags to add to the asset.")

class OrganizationRequest(BaseModel):
    """Request model for creating or updating an organization."""
    name: str = Field(..., description="Organization name")
    description: Optional[str] = Field(None, description="Organization description")
    is_public: bool = Field(default=True, description="Whether the organization is public")

class OrganizationResponse(BaseModel):
    """Response model for organization details."""
    id: int
    name: str
    description: Optional[str]
    is_public: bool
    created_at: datetime
    
    class Config:
        orm_mode = True

class AssetResponse(BaseModel):
    """Detailed response model for a single asset."""
    id: int
    name: str
    description: Optional[str]
    is_public: bool
    model_url: str
    thumbnail_url: Optional[str]
    owner_id: int
    remix_of_asset_id: Optional[int]
    # Marketplace fields
    price: float
    is_for_sale: bool
    # Limitation fields
    max_quantity: Optional[int]
    current_quantity_sold: int
    available_until: Optional[datetime]
    exclusive_to_organization_id: Optional[int]
    exclusivity_level: str
    
    class Config:
        orm_mode = True

class BuyRequest(BaseModel):
    """Request model for purchasing an asset."""
    buyer_id: int = Field(..., description="The ID of the user buying the asset.")
    # In a real app, we'd validate the user has enough credits/currency

class MarketplaceAssetResponse(BaseModel):
    """Response model for marketplace listings."""
    id: int
    name: str
    description: Optional[str]
    thumbnail_url: Optional[str]
    owner_id: int
    price: float
    is_for_sale: bool
    # Limitation info
    max_quantity: Optional[int]
    current_quantity_sold: int
    available_until: Optional[datetime]
    exclusivity_level: str
    # Add average rating later
    
    class Config:
        orm_mode = True

class LimitedAssetRequest(BaseModel):
    """Request model for creating limited/exclusive assets."""
    name: str
    description: Optional[str]
    price: float
    max_quantity: Optional[int] = Field(None, description="Maximum number of copies available")
    available_until: Optional[datetime] = Field(None, description="Until when the asset is available")
    exclusive_to_organization_id: Optional[int] = Field(None, description="Organization ID for exclusive assets")
    exclusivity_level: str = Field(default="public", description="public, organization, exclusive")

class LicenseTypeRequest(BaseModel):
    """Request model for creating license types."""
    name: str = Field(..., description="License type name (e.g., personal, commercial)")
    description: Optional[str] = Field(None, description="License description")
    allows_commercial_use: bool = Field(default=False, description="Allows commercial usage")
    allows_modification: bool = Field(default=False, description="Allows modification of the asset")
    allows_redistribution: bool = Field(default=False, description="Allows redistribution")
    requires_attribution: bool = Field(default=True, description="Requires attribution to creator")
    max_users: Optional[int] = Field(None, description="Maximum number of users (None = unlimited)")
    max_revenue: Optional[float] = Field(None, description="Maximum revenue allowed (None = unlimited)")

class LicenseTypeResponse(BaseModel):
    """Response model for license types."""
    id: int
    name: str
    description: Optional[str]
    allows_commercial_use: bool
    allows_modification: bool
    allows_redistribution: bool
    requires_attribution: bool
    max_users: Optional[int]
    max_revenue: Optional[float]
    
    class Config:
        orm_mode = True

class AssetLicenseRequest(BaseModel):
    """Request model for creating asset licenses."""
    license_type_id: int = Field(..., description="ID of the license type")
    price: float = Field(..., gt=0, description="Price for this license")

class AssetLicenseResponse(BaseModel):
    """Response model for asset licenses."""
    id: int
    asset_id: int
    license_type: LicenseTypeResponse
    price: float
    is_available: bool
    
    class Config:
        orm_mode = True

class LicensePurchaseRequest(BaseModel):
    """Request model for purchasing a license."""
    buyer_id: int = Field(..., description="ID of the user buying the license")
    # In a real app, we'd validate the user has enough credits/currency

class LicensePurchaseResponse(BaseModel):
    """Response model for license purchases."""
    id: int
    asset_license_id: int
    buyer_id: int
    purchase_price: float
    purchased_at: datetime
    expires_at: Optional[datetime]
    usage_count: int
    
    class Config:
        orm_mode = True

# --- USER MODELS ---

class UserRequest(BaseModel):
    """Request model for creating a user."""
    username: str = Field(..., description="Username")
    email: str = Field(..., description="Email address")
    avatar_url: Optional[str] = Field(None, description="Avatar URL")
    bio: Optional[str] = Field(None, description="User bio")

class UserUpdateRequest(BaseModel):
    """Request model for updating a user."""
    username: Optional[str] = Field(None, description="Username")
    avatar_url: Optional[str] = Field(None, description="Avatar URL")
    bio: Optional[str] = Field(None, description="User bio")

class UserResponse(BaseModel):
    """Response model for user details."""
    id: int
    username: str
    email: str
    avatar_url: Optional[str]
    bio: Optional[str]
    created_at: datetime
    updated_at: datetime
    
    class Config:
        orm_mode = True

# --- COMMUNITY THEME MODELS ---

class CommunityThemeRequest(BaseModel):
    """Request model for creating community themes."""
    title: str = Field(..., description="Theme title")
    description: Optional[str] = Field(None, description="Theme description")
    prompt: str = Field(..., description="Generation prompt")
    style: Optional[str] = Field(None, description="Visual style")
    quality: Optional[str] = Field(None, description="Generation quality")
    created_by: int = Field(..., description="User ID who created the theme")

class CommunityThemeResponse(BaseModel):
    """Response model for community themes."""
    id: int
    title: str
    description: Optional[str]
    prompt: str
    style: Optional[str]
    quality: Optional[str]
    votes: int
    created_by: int
    created_at: datetime
    updated_at: datetime
    
    class Config:
        orm_mode = True

# --- SYNC MODELS ---

class SyncRequest(BaseModel):
    """Model for offline sync requests."""
    id: str = Field(..., description="Unique sync request ID")
    operation: str = Field(..., description="Operation type")
    data: dict = Field(..., description="Request data")
    timestamp: datetime = Field(default_factory=datetime.now)

class SyncResponse(BaseModel):
    """Response model for sync operations."""
    id: str
    status: str  # success, error
    result: Optional[dict] = None
    error: Optional[str] = None

# --- ANALYTICS MODELS ---

class AssetAnalyticsResponse(BaseModel):
    """Response model for asset analytics."""
    asset_id: int
    downloads: int
    rating_count: int
    average_rating: float
    favorites: int
    views: int
    created_at: Optional[str]

# --- SEARCH MODELS ---

class SearchFilters(BaseModel):
    """Model for search filters."""
    q: Optional[str] = None
    style: Optional[str] = None
    quality: Optional[str] = None
    min_rating: Optional[float] = None
    max_price: Optional[float] = None
    tags: Optional[str] = None
    skip: int = 0
    limit: int = 20

# --- RECOMMENDATION MODELS ---

class RecommendationResponse(BaseModel):
    """Response model for recommendations."""
    assets: List[AssetResponse]
    reason: str  # Why these assets were recommended
    confidence: float  # Recommendation confidence score 