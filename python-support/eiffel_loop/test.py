
import os
from eiffel_loop.os import path

def check (name, test_result):
	print('Checking', name, end=' ')
	assert test_result, "Unexpected result for: " + name
	print('OK')

def check_C_library_paths (var_names):
	for key, value in var_names.items ():
		dir_path = os.environ [key]
		succeeds = path.exists (dir_path) and path.basename (dir_path).startswith (value)
		check (key + " exists and matches", succeeds)
