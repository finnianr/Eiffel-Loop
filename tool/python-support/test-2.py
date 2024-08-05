
arch_attribute = "processorArchitecture='%s'"

def write_manifest (input_file, output_file):
    # Open the input file in read mode
    with open (input_file, 'r') as infile:
        # Read the entire content of the file
        content = infile.read()

    # Open the output file in write mode and write the modified content
    with open (output_file, 'w') as outfile:
        outfile.write (content.replace (arch_attribute % ('amd64'), arch_attribute %('x86'), 1))

# Example usage:
input_file = 'myching.exe.manifest'
output_file = 'build/windows/package/bin/myching.exe.manifest'
write_manifest (input_file, output_file)

