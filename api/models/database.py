from sqlalchemy import create_engine, Column, Integer, String, Float, DateTime, Boolean, ForeignKey, Text
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from ..core.database import Base
import uuid # For UUIDs

class Organization(Base):
    __tablename__ = "organizations"
    id = Column(Integer, primary_key=True, index=True) # Keep as int for existing relations, or change if needed
    name = Column(String, unique=True, index=True, nullable=False)
    description = Column(Text, nullable=True)
    is_public = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    members = relationship("OrganizationMembership", back_populates="organization")
    exclusive_assets = relationship("Asset", back_populates="exclusive_to_organization")

class OrganizationMembership(Base):
    __tablename__ = "organization_memberships"
    id = Column(Integer, primary_key=True, index=True)
    organization_id = Column(Integer, ForeignKey("organizations.id"))
    user_id = Column(String, ForeignKey("users.id")) # Changed to String for Supabase UUID
    role = Column(String, default="member")  # member, admin, owner
    joined_at = Column(DateTime(timezone=True), server_default=func.now())
    
    organization = relationship("Organization", back_populates="members")
    user = relationship("User", back_populates="organization_memberships") # Added relationship to User

class User(Base): # This table will now primarily store Supabase User IDs and any app-specific data not in Supabase 'profiles'
    __tablename__ = "users"
    # id is now the Supabase User ID (UUID as string)
    id = Column(String, primary_key=True, index=True, default=lambda: str(uuid.uuid4()))
    username = Column(String, unique=True, index=True, nullable=False) # Can be synced from Supabase profile
    email = Column(String, unique=True, index=True, nullable=False) # Can be synced from Supabase profile
    # password_hash = Column(String, nullable=False)  # Removed, Supabase handles this
    is_active = Column(Boolean, default=True) # App-specific active status
    is_verified = Column(Boolean, default=False) # Can be synced from Supabase
    role = Column(String, default="user")  # App-specific role
    created_at = Column(DateTime(timezone=True), server_default=func.now()) # App-specific creation timestamp
    last_login = Column(DateTime(timezone=True), nullable=True) # Can be updated by our app
    
    assets = relationship("Asset", back_populates="owner")
    owned_assets = relationship("AssetOwnership", back_populates="buyer")
    organization_memberships = relationship("OrganizationMembership", back_populates="user") # Corrected back_populates
    ratings = relationship("Rating", back_populates="user") # Added relationship
    license_purchases = relationship("LicensePurchase", back_populates="buyer") # Added relationship


class LicenseType(Base):
    __tablename__ = "license_types"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True, index=True, nullable=False)  # e.g., "personal", "commercial", "enterprise"
    description = Column(Text, nullable=True)
    allows_commercial_use = Column(Boolean, default=False)
    allows_modification = Column(Boolean, default=False)
    allows_redistribution = Column(Boolean, default=False)
    requires_attribution = Column(Boolean, default=True)
    max_users = Column(Integer, nullable=True)  # None = unlimited
    max_revenue = Column(Float, nullable=True)  # None = unlimited
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class AssetLicense(Base):
    __tablename__ = "asset_licenses"
    id = Column(Integer, primary_key=True, index=True)
    asset_id = Column(Integer, ForeignKey("assets.id"))
    license_type_id = Column(Integer, ForeignKey("license_types.id"))
    price = Column(Float, nullable=False)
    is_available = Column(Boolean, default=True)
    
    asset = relationship("Asset", back_populates="licenses")
    license_type = relationship("LicenseType")

class LicensePurchase(Base):
    __tablename__ = "license_purchases"
    id = Column(Integer, primary_key=True, index=True)
    asset_license_id = Column(Integer, ForeignKey("asset_licenses.id"))
    buyer_id = Column(String, ForeignKey("users.id")) # Changed to String
    purchase_price = Column(Float, nullable=False)
    purchased_at = Column(DateTime(timezone=True), server_default=func.now())
    expires_at = Column(DateTime(timezone=True), nullable=True)  # None = perpetual
    usage_count = Column(Integer, default=0)  # Track usage for metered licenses
    
    asset_license = relationship("AssetLicense")
    buyer = relationship("User", back_populates="license_purchases") # Corrected back_populates

class Asset(Base):
    __tablename__ = "assets"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True, default="Untitled Asset")
    description = Column(String, nullable=True)
    is_public = Column(Boolean, default=False)
    
    # Generation details
    prompt = Column(String, nullable=True)
    style = Column(String, nullable=True)
    
    # File details
    model_url = Column(String, nullable=False)
    thumbnail_url = Column(String, nullable=True)
    
    # Marketplace details
    price = Column(Float, default=0.0)  # Price in credits/currency
    is_for_sale = Column(Boolean, default=False)
    
    # Limitation details
    max_quantity = Column(Integer, nullable=True)  # None = unlimited
    current_quantity_sold = Column(Integer, default=0)
    available_until = Column(DateTime(timezone=True), nullable=True)  # None = always available
    exclusive_to_organization_id = Column(Integer, ForeignKey("organizations.id"), nullable=True)
    exclusivity_level = Column(String, default="public")  # public, organization, exclusive
    
    # Relationships
    owner_id = Column(String, ForeignKey("users.id")) # Changed to String
    owner = relationship("User", back_populates="assets")
    exclusive_to_organization = relationship("Organization", back_populates="exclusive_assets")
    
    # Remix details
    remix_of_asset_id = Column(Integer, ForeignKey("assets.id"), nullable=True)
    remixes = relationship("Asset", back_populates="remix_parent")
    remix_parent = relationship("Asset", remote_side=[id], back_populates="remixes")

    # Timestamps
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Community features
    ratings = relationship("Rating", back_populates="asset")
    tags = relationship("Tag", secondary="asset_tags", back_populates="assets")
    ownerships = relationship("AssetOwnership", back_populates="asset")
    licenses = relationship("AssetLicense", back_populates="asset")

class AssetOwnership(Base):
    __tablename__ = "asset_ownerships"
    id = Column(Integer, primary_key=True, index=True)
    asset_id = Column(Integer, ForeignKey("assets.id"))
    buyer_id = Column(String, ForeignKey("users.id")) # Changed to String
    purchase_price = Column(Float, nullable=False)
    purchased_at = Column(DateTime(timezone=True), server_default=func.now())
    
    asset = relationship("Asset", back_populates="ownerships")
    buyer = relationship("User", back_populates="owned_assets")

class Rating(Base):
    __tablename__ = "ratings"
    id = Column(Integer, primary_key=True, index=True)
    asset_id = Column(Integer, ForeignKey("assets.id"))
    user_id = Column(String, ForeignKey("users.id")) # Changed to String
    score = Column(Integer, nullable=False) # e.g., 1-5
    
    asset = relationship("Asset", back_populates="ratings")
    user = relationship("User", back_populates="ratings") # Added relationship

class Tag(Base):
    __tablename__ = "tags"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True, index=True, nullable=False)
    
    assets = relationship("Asset", secondary="asset_tags", back_populates="tags")

class AssetTag(Base):
    __tablename__ = "asset_tags"
    asset_id = Column(Integer, ForeignKey("assets.id"), primary_key=True)
    tag_id = Column(Integer, ForeignKey("tags.id"), primary_key=True) 