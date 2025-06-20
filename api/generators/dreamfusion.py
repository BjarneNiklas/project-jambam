import time
import os

def generate(job_id: str, prompt: str, style: str) -> str:
    """Mock DreamFusion/Stable Diffusion 3D generator."""
    print(f"[{job_id}] Generating '{style}' mesh for: '{prompt}'")
    time.sleep(10) # Simulate work
    
    output_dir = "static/generated"
    os.makedirs(output_dir, exist_ok=True)
    
    file_name = f"{job_id}_{style}.glb"
    output_path = os.path.join(output_dir, file_name)
    
    with open(output_path, "w") as f:
        f.write(f"Mock Mesh Model for '{prompt}' with style '{style}'")
        
    print(f"[{job_id}] Mesh model saved to {output_path}")
    return output_path 