import os, zipfile

from os import path
from Glob impor

def write_member (fpath, file_content):
	file_out = open (fpath, 'wb')
	file_out.write (file_content)
	file_out.close ()

def extract (zip_path):
	zip_file = zipfile.ZipFile (zip_path, 'r')
	for fpath in zip_file.namelist ():
		member_name = path.basename (fpath)
		if member_name == 'libglib-2.0-0.dll':
			print 'Extracting', member_name
			write_member (path.join ('archive', member_name), zip_file.read (fpath))
	zip_file.close ()


def extract_all (zip_path):
	zip_file = zipfile.ZipFile (zip_path, 'r')
	zip_file.extractall ('archive')
	zip_file.close ()

#extract_all (r'C:\Users\finnian\Downloads\SCons-packages\gtk_dll_3.4.2-1_win64.zip')



	




