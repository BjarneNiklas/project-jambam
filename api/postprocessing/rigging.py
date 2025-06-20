import time

def run(job_id: str, model_path: str) -> str:
    """Mock rigging service."""
    print(f"[{job_id}] Rigging model at: {model_path}")
    time.sleep(5) # Simulate work
    print(f"[{job_id}] Rigging complete.")
    return model_path # In reality, this might return a new path 