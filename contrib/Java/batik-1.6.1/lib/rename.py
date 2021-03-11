import os
from os import path
from glob import glob
from distutils import file_util

for fpath in glob ("*.get"):
	parts = fpath.split ('.')
	ext = 'get' + parts [-2]
	parts = parts [:-2]
	parts.append (ext)
	print '.'.join (parts)
	os.rename (fpath, '.'.join (parts))
	

