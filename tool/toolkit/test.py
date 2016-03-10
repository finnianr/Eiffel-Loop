from os import path
file_path = path.join ('source/build_info.e')

build_no = 1
if path.exists (file_path):
	f = open (file_path, 'r')
	for line in f.readlines ():
		if line.startswith ('\tBuild_number'):
			build_no = int (line.split ()[-1:][0]) + 1
			break
	f.close ()

print 'build_no', build_no
