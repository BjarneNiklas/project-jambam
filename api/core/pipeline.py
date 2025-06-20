import time
import os
from sqlalchemy.orm import Session
from .jobs import update_job_status, complete_job
from ..generators import dreamfusion, brickgpt, gaussian_splatting, stable_diffusion_3d
from ..postprocessing import rigging, animation, converter
from ..models import database as db_models

def asset_pipeline(job_id: str, db: Session, request_data=None, uploaded_file_path: str = None, remix_of_id: int = None):
    """
    The main pipeline for asset generation and processing.
    This function orchestrates the call to different services and saves the result to the DB.
    """
    try:
        # 1. Generate or receive initial model
        update_job_status(job_id, "processing", 10, "Initializing pipeline...")
        
        if request_data: # Text-to-3D
            prompt = request_data.prompt
            style = request_data.style
            quality = getattr(request_data, 'quality', 'standard')
            
            # Use Stable Diffusion 3D for most styles
            if style in stable_diffusion_3d.sd3d_generator.get_available_styles():
                model_path = stable_diffusion_3d.sd3d_generator.generate(
                    job_id, prompt, style, quality
                )
            # Fallback to legacy generators for specific cases
            elif style == "voxel":
                model_path = brickgpt.generate(job_id, prompt)
            else:
                model_path = dreamfusion.generate(job_id, prompt, style)
        elif uploaded_file_path:
            prompt = None
            style = "custom"
            model_path = uploaded_file_path
        else:
            raise ValueError("No generation request or file provided.")

        update_job_status(job_id, "processing", 30, "Model generated, starting post-processing.")

        # 2. Rigging
        rigged_path = rigging.run(job_id, model_path)
        update_job_status(job_id, "processing", 50, "Rigging complete.")
        
        # 3. Animation
        animated_path = animation.run(job_id, rigged_path, getattr(request_data, 'animation', []))
        update_job_status(job_id, "processing", 70, "Animation complete.")

        # 4. Format Conversion & Optimization
        final_assets = converter.run(job_id, animated_path, getattr(request_data, 'output_format', 'glb'))
        update_job_status(job_id, "processing", 70, "Generating cross-platform previews...")

        # 5. Generate Gaussian Splat previews for all platforms
        splat_output_dir = f"static/generated/{job_id}/splats"
        splat_result = gaussian_splatting.splat_converter.convert_model_to_splats(
            final_assets.get("modelUrl"), 
            splat_output_dir
        )
        
        if splat_result["status"] == "success":
            # Add splat preview URLs to final assets
            final_assets["splatPreviews"] = {
                "web": f"/static/generated/{job_id}/splats/splats_web.json",
                "desktop": f"/static/generated/{job_id}/splats/splats_desktop.bin", 
                "android": f"/static/generated/{job_id}/splats/splats_android.json"
            }
            final_assets["splatCount"] = splat_result["splat_count"]
        
        update_job_status(job_id, "processing", 90, "Finalizing assets.")

        # 6. Save asset to database
        # In a real app, user_id would come from an authentication system.
        new_asset = db_models.Asset(
            name=prompt or "Uploaded Asset",
            description=f"A {style} asset generated with Stable Diffusion 3D." if style in stable_diffusion_3d.sd3d_generator.get_available_styles() else f"A {style} asset.",
            prompt=prompt,
            style=style,
            model_url=final_assets.get("modelUrl"),
            thumbnail_url=final_assets.get("thumbnailUrl"),
            owner_id=1, # Dummy user for now
            remix_of_asset_id=remix_of_id,
            is_public=False, # Default to private
            price=0.0, # Default to free
            is_for_sale=False, # Default to not for sale
            # Default limitation settings
            max_quantity=None, # Unlimited
            current_quantity_sold=0,
            available_until=None, # Always available
            exclusive_to_organization_id=None, # Public
            exclusivity_level="public"
        )
        db.add(new_asset)
        db.commit()

        # 7. Complete Job
        complete_job(job_id, final_assets)

    except Exception as e:
        print(f"Pipeline failed for job {job_id}: {e}")
        update_job_status(job_id, "failed", 100, str(e))
        db.rollback() 