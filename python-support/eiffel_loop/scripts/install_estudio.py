import sys, subprocess
from os import path
from glob import glob

if len (sys.argv) < 3:
	print "Usage: install_estudio <version> <ise_platform>"
	quit ()

version =  sys.argv [1]
ise_platform =  sys.argv [2]

if ise_platform == "win64":
	output_dir = r"D:\Program Files"
else:
	output_dir = r"D:\Program Files (x86)"	

print "Archives found"
for archive_path in glob ("Eiffel" + version + "*" + ise_platform + ".7z"):
	print "  ", archive_path
	eiffel_archive_path = archive_path

print

installed_path = path.join (output_dir, "Eiffel" + version) 
if path.exists (installed_path):
	print installed_path, "already exists. Delete first."
	quit ()

s = raw_input ("Install " + eiffel_archive_path + " (y/n) ")

if s == "y":
	subprocess.call (['7z', 'x', '-r', '-o' + output_dir, eiffel_archive_path])
