import re
import os
import subprocess

# Define the code pattern
pattern = re.compile(r'\b[A-Z0-9]{4}-[A-Z0-9]{4}\b')

# Define the file path to monitor
file_path = os.path.expanduser('~/output.log')

# Initialize a list to store detected codes
detected_codes = []

# Continuously monitor the file for changes
while True:
    with open(file_path, 'r') as f:
        # Find the current end of the file
        f.seek(0, os.SEEK_END)
        end_pos = f.tell()

        # Seek to the last position we read from the file
        last_pos = f.tell() if end_pos < 1024 else end_pos - 1024
        f.seek(last_pos)

        # Read any new lines that were added to the file
        new_lines = f.read(end_pos - f.tell()).splitlines()

        # Search for the code pattern in the new lines
        codes = pattern.findall('\n'.join(new_lines))

        # Check if any new codes were detected
        new_codes = [code for code in codes if code not in detected_codes]
        if new_codes:
            # Add new codes to the list of detected codes
            detected_codes.extend(new_codes)
            with open('code.txt', 'w') as code_file:
                code_file.write(new_codes[-1] + '\n')
            # Trigger the action to notify with the new codes
            cmd = ['notify', '-data', 'code.txt', '-bulk']
            subprocess.run(cmd)
            os.remove('code.txt')