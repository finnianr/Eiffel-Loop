from os import path
from glob import glob
from eiffel_loop.distutils import file_util

def has_class (line):
	return line.startswith ('class')

def has_def (line):
	result = False
	if 'def ' in line:
		result = True
	return result

class_count = 0; def_count = 0; mod_count = 0

for py in file_util.find_files ('eiffel_loop', '*.py'):
	if not '__' in py:
		class_count += file_util.match_count (py, has_class)
		def_count += file_util.match_count (py, has_def)
		mod_count += 1
		# print py

print "\nModules:", mod_count
print "Classes:", class_count
print "Definitions:", def_count
