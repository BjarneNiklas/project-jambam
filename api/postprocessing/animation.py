import time
from typing import List

def run(job_id: str, model_path: str, animations: List[str]) -> str:
    """Mock animation service."""
    if not animations:
        print(f"[{job_id}] No animations requested. Skipping.")
        return model_path
        
    print(f"[{job_id}] Adding animations to model at: {model_path}")
    print(f"[{job_id}] Requested animations: {', '.join(animations)}")
    time.sleep(3) # Simulate work
    print(f"[{job_id}] Animations added.")
    return model_path # In reality, this might return a new path 