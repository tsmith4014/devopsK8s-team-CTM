#!/bin/bash

# Change to the Terraform project directory
cd /home/user/my_projects/terraform_project/

# Define input and output files (now relative paths)
input_file="variables.tf"
output_file="sensitive-data.tfvars"

# Start the .tfvars file from scratch
echo "# This is the .tfvars file for sensitive variables" > $output_file

# Use awk to extract variable names with sensitive = true
awk '
  # When we find a variable declaration, store the variable name
  /variable/ {var=$2}
  
  # When we find sensitive = true on a line, print the stored variable name to the output file
  /sensitive[[:space:]]*=[[:space:]]*true/ {print var " = \"\"" >> "'"$output_file"'"}
' $input_file

echo "Generated $output_file with placeholders for sensitive variables."
