import numpy as np
import re
import os

def process_npy_file(file_path):
    # Extract filename from the path
    filename = os.path.basename(file_path)
    
    # Use regex to extract the number after 'NumStreamlines_'
    match = re.search(r'NumStreamlines_(\d+)', filename)
    if not match:
        raise ValueError("Could not extract NumStreamlines value from filename")
    
    num_streamlines = int(match.group(1))
    
    # Load the .npy file
    data = np.load(file_path)
    
    # Divide all values by num_streamlines
    data = data[data > (num_streamlines)*0.00001]
    
    # Create a new filename
    new_filename = filename.replace('.npy', '_normalized.npy')
    new_file_path = os.path.join(os.path.dirname(file_path), new_filename)
    
    # Save the modified array
    np.save(new_file_path, data)
    print(f"Processed file saved as: {new_file_path}")

# Example usage
# process_npy_file("/path/to/CONNECTOME_SIFT2NUMSTREAMS_NumStreamlines_5000000_Atlas_slant_Iteration_5.npy")
