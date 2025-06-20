import time
import os

def generate(job_id: str, prompt: str) -> str:
    """Mock BrickGPT generator."""
    print(f"[{job_id}] Generating voxel model for: '{prompt}'")
    time.sleep(5) # Simulate work
    
    output_dir = "static/generated"
    os.makedirs(output_dir, exist_ok=True)
    
    file_name = f"{job_id}_voxel.glb"
    output_path = os.path.join(output_dir, file_name)
    
    with open(output_path, "w") as f:
        f.write(f"Mock Voxel Model for '{prompt}'")
        
    print(f"[{job_id}] Voxel model saved to {output_path}")
    return output_path 