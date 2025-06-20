from typing import Dict, Any

# In-memory store for jobs. In a real application, use Redis or a database.
JOBS: Dict[str, Dict[str, Any]] = {}

def create_job(job_id: str) -> None:
    JOBS[job_id] = {"status": "pending", "progress": 0, "details": "Job created."}

def get_job_status(job_id: str) -> Dict[str, Any]:
    return JOBS.get(job_id, {"status": "not_found"})

def update_job_status(job_id: str, status: str, progress: int, details: str) -> None:
    if job_id in JOBS:
        JOBS[job_id]["status"] = status
        JOBS[job_id]["progress"] = progress
        JOBS[job_id]["details"] = details

def complete_job(job_id: str, result: Dict[str, str]) -> None:
    if job_id in JOBS:
        JOBS[job_id]["status"] = "completed"
        JOBS[job_id]["progress"] = 100
        JOBS[job_id]["details"] = "Job completed successfully."
        JOBS[job_id]["result"] = result 