import os
import json
import csv

def json_to_csv(directory, output_csv):
    # Collect all data to be written to the CSV
    combined_data = []
    header_set = set()

    # Traverse directory and read JSON files
    for root, _, files in os.walk(directory):
        for file in files:
            if file.startswith("graphmeasures_SIFT2MU_") and file.endswith(".json"):
                file_path = os.path.join(root, file)
                
                # Read JSON file
                with open(file_path, 'r', encoding='utf-8') as f:
                    try:
                        data = json.load(f)
                    except json.JSONDecodeError:
                        print(f"Error decoding JSON in file: {file_path}")
                        continue

                # Flatten JSON data, if it's nested
                flat_data = {}
                def flatten(data, parent_key=''):
                    if isinstance(data, dict):
                        for k, v in data.items():
                            new_key = f"{parent_key}.{k}" if parent_key else k
                            flatten(v, new_key)
                    elif isinstance(data, list):
                        for i, item in enumerate(data):
                            flatten(item, f"{parent_key}.{i}")
                    else:
                        flat_data[parent_key] = data
                        
                flatten(data)
                
                # Add file path to the flat data
                flat_data['file_path'] = file_path

                # Add keys to header set and data to combined list
                header_set.update(flat_data.keys())
                combined_data.append(flat_data)

    # Determine if we need to write headers (only if the CSV doesn't exist)
    write_headers = not os.path.exists(output_csv)
    headers = list(header_set)
    
    # Append data to CSV
    with open(output_csv, 'a', newline='', encoding='utf-8') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=headers)
        if write_headers:
            writer.writeheader()  # Only write header if file is new
        for data in combined_data:
            writer.writerow(data)

import sys
# Specify the directory containing JSON files and output CSV path
input_directory = sys.argv[1]
output_csv_path = 'combined_data_sift2.csv'
json_to_csv(input_directory, output_csv_path)

print(f"Data from all JSON files has been appended to {output_csv_path}")
