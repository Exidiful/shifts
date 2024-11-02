#!/bin/bash

# Check if a project directory is provided
if [ $# -eq 0 ]; then
    echo "Please provide the Flutter project directory path."
    exit 1
fi

# Set the project directory and output file
PROJECT_DIR="$1"
OUTPUT_FILE="flutter_project_info.txt"

# Function to write a separator line
write_separator() {
    echo "----------------------------------------" >> "$OUTPUT_FILE"
}

# Save project information
echo "Flutter Project Information" > "$OUTPUT_FILE"
echo "Date: $(date)" >> "$OUTPUT_FILE"
write_separator

# Save pubspec.yaml contents
echo "pubspec.yaml contents:" >> "$OUTPUT_FILE"
write_separator
cat "$PROJECT_DIR/pubspec.yaml" >> "$OUTPUT_FILE"
write_separator

# Save directory structure
echo "Project Structure:" >> "$OUTPUT_FILE"
write_separator
ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//  |/g' -e 's/^  |/    /' -e 's/|  /│   /' -e 's/  |/│   /' -e 's/│\([^│]\)/├──\1/' >> "$OUTPUT_FILE"
write_separator

# Function to save file contents
save_file_contents() {
    local file="$1"
    echo "File: $file" >> "$OUTPUT_FILE"
    write_separator
    cat "$file" >> "$OUTPUT_FILE"
    write_separator
}

# Save contents of Dart files
find "$PROJECT_DIR" -name "*.dart" | while read -r file; do
    save_file_contents "$file"
done

echo "Project information and file contents have been saved to $OUTPUT_FILE"