import torch
import numpy as np
import trimesh
from pathlib import Path
import json
import time
from typing import Dict, Any, Optional

class GaussianSplatConverter:
    """
    Converts 3D models to Gaussian Splat format for cross-platform preview
    """
    
    def __init__(self):
        self.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        print(f"Gaussian Splat Converter initialized on {self.device}")
    
    def convert_model_to_splats(self, model_path: str, output_dir: str) -> Dict[str, Any]:
        """
        Converts a 3D model to Gaussian Splat format for preview
        
        Args:
            model_path: Path to the 3D model (glTF, USD, OBJ, etc.)
            output_dir: Directory to save the splat files
            
        Returns:
            Dict with metadata about the generated splats
        """
        try:
            print(f"Converting {model_path} to Gaussian Splats...")
            
            # Load the 3D model
            mesh = trimesh.load(model_path)
            
            # Extract vertices and faces
            vertices = np.array(mesh.vertices)
            faces = np.array(mesh.faces)
            
            # Generate Gaussian Splats from mesh
            splat_data = self._generate_splats_from_mesh(vertices, faces)
            
            # Save in different formats for different platforms
            output_files = self._save_splat_formats(splat_data, output_dir)
            
            print(f"Successfully converted to Gaussian Splats")
            return {
                "status": "success",
                "output_files": output_files,
                "splat_count": len(splat_data["positions"]),
                "platforms": ["web", "desktop", "android"]
            }
            
        except Exception as e:
            print(f"Error converting to Gaussian Splats: {e}")
            return {
                "status": "error",
                "error": str(e)
            }
    
    def _generate_splats_from_mesh(self, vertices: np.ndarray, faces: np.ndarray) -> Dict[str, np.ndarray]:
        """
        Generates Gaussian Splats from mesh vertices and faces
        """
        # Calculate face centers and normals
        face_centers = vertices[faces].mean(axis=1)
        face_normals = self._calculate_face_normals(vertices, faces)
        
        # Generate splat positions (at face centers)
        positions = face_centers.astype(np.float32)
        
        # Generate splat scales (based on face area)
        face_areas = self._calculate_face_areas(vertices, faces)
        scales = np.sqrt(face_areas[:, None]) * 0.1  # Scale factor
        scales = np.clip(scales, 0.01, 1.0)  # Clamp scales
        
        # Generate splat rotations (from face normals)
        rotations = self._normals_to_rotations(face_normals)
        
        # Generate splat colors (random for now, could be from textures)
        colors = np.random.uniform(0.5, 1.0, (len(positions), 3)).astype(np.float32)
        
        return {
            "positions": positions,
            "scales": scales,
            "rotations": rotations,
            "colors": colors,
            "opacities": np.ones(len(positions), dtype=np.float32) * 0.8
        }
    
    def _calculate_face_normals(self, vertices: np.ndarray, faces: np.ndarray) -> np.ndarray:
        """Calculate face normals"""
        v0 = vertices[faces[:, 0]]
        v1 = vertices[faces[:, 1]]
        v2 = vertices[faces[:, 2]]
        
        edge1 = v1 - v0
        edge2 = v2 - v0
        normals = np.cross(edge1, edge2)
        normals = normals / np.linalg.norm(normals, axis=1, keepdims=True)
        return normals
    
    def _calculate_face_areas(self, vertices: np.ndarray, faces: np.ndarray) -> np.ndarray:
        """Calculate face areas"""
        v0 = vertices[faces[:, 0]]
        v1 = vertices[faces[:, 1]]
        v2 = vertices[faces[:, 2]]
        
        edge1 = v1 - v0
        edge2 = v2 - v0
        cross = np.cross(edge1, edge2)
        areas = np.linalg.norm(cross, axis=1) * 0.5
        return areas
    
    def _normals_to_rotations(self, normals: np.ndarray) -> np.ndarray:
        """Convert normals to rotation quaternions"""
        # Simplified: use identity rotations for now
        # In a full implementation, this would convert normals to quaternions
        rotations = np.zeros((len(normals), 4), dtype=np.float32)
        rotations[:, 0] = 1.0  # Identity quaternion
        return rotations
    
    def _save_splat_formats(self, splat_data: Dict[str, np.ndarray], output_dir: str) -> Dict[str, str]:
        """
        Saves splat data in different formats for different platforms
        """
        output_dir = Path(output_dir)
        output_dir.mkdir(parents=True, exist_ok=True)
        
        output_files = {}
        
        # 1. Web format (JSON for WebGL)
        web_file = output_dir / "splats_web.json"
        self._save_web_format(splat_data, web_file)
        output_files["web"] = str(web_file)
        
        # 2. Desktop format (Binary for OpenGL)
        desktop_file = output_dir / "splats_desktop.bin"
        self._save_desktop_format(splat_data, desktop_file)
        output_files["desktop"] = str(desktop_file)
        
        # 3. Android format (Optimized for mobile)
        android_file = output_dir / "splats_android.json"
        self._save_android_format(splat_data, android_file)
        output_files["android"] = str(android_file)
        
        return output_files
    
    def _save_web_format(self, splat_data: Dict[str, np.ndarray], file_path: Path):
        """Save splat data for WebGL"""
        web_data = {
            "positions": splat_data["positions"].tolist(),
            "scales": splat_data["scales"].tolist(),
            "rotations": splat_data["rotations"].tolist(),
            "colors": splat_data["colors"].tolist(),
            "opacities": splat_data["opacities"].tolist()
        }
        
        with open(file_path, 'w') as f:
            json.dump(web_data, f)
    
    def _save_desktop_format(self, splat_data: Dict[str, np.ndarray], file_path: Path):
        """Save splat data for desktop OpenGL"""
        # Binary format for better performance
        with open(file_path, 'wb') as f:
            # Write header
            f.write(b"SPLAT")
            
            # Write data
            for key in ["positions", "scales", "rotations", "colors", "opacities"]:
                data = splat_data[key]
                f.write(data.tobytes())
    
    def _save_android_format(self, splat_data: Dict[str, np.ndarray], file_path: Path):
        """Save splat data optimized for Android"""
        # Reduced quality for mobile performance
        # Sample every 4th splat for mobile
        indices = np.arange(0, len(splat_data["positions"]), 4)
        
        android_data = {
            "positions": splat_data["positions"][indices].tolist(),
            "scales": splat_data["scales"][indices].tolist(),
            "rotations": splat_data["rotations"][indices].tolist(),
            "colors": splat_data["colors"][indices].tolist(),
            "opacities": splat_data["opacities"][indices].tolist()
        }
        
        with open(file_path, 'w') as f:
            json.dump(android_data, f)

# Global instance
splat_converter = GaussianSplatConverter() 