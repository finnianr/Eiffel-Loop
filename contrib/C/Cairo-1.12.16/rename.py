import os
from os import path
from glob import glob
from distutils import file_util

def rename_extensions ():
	for fpath in glob ("*.get"):
		parts = fpath.split ('.')
		ext = 'get' + parts [-2]
		parts = parts [:-2]
		parts.append (ext)
		print '.'.join (parts)
		os.rename (fpath, '.'.join (parts))


def rewrite_sources():
	for fpath in glob (r'source\*.getdll'):
		name = path.basename (fpath)
		destpath = path.join ('source2', name)
		fout = open (destpath, 'w')
		fout.write ('ftp://www.eiffel-loop.com/download/gtk_dll_3.4.2-1_win$CPU_BITS.zip')
		fout.close

rewrite_sources()
