#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "16 Dec 2011"
#	revision: "0.1"

import os, urllib, zipfile, re
from os import path
from distutils import dir_util

if os.name == 'posix':
	from debian import debfile

def display_progress (a,b,c): 
    # ',' at the end of the line is important!
    print "% 3.1f%% of %d bytes\r" % (min(100, float(a * b) / c * 100), c),
    #you can also use sys.stdout.write
    #sys.stdout.write("\r% 3.1f%% of %d bytes" 
    #                 % (min(100, float(a * b) / c * 100), c)
    #sys.stdout.flush()

def download_path (url, download_dir):
	url_basename = url.rsplit ('/')[-1:][0]
	result = path.join (download_dir, url_basename)
	return result

def download (url, download_dir):
	zip_path = download_path (url, download_dir)
	if path.exists (zip_path):
		print 'Found download:', zip_path
	else:
		dir_util.mkpath (download_dir)
		print 'Downloading:', url, ' to:', zip_path
		urllib.urlretrieve (url, zip_path, display_progress)

def unzip_selected (zip_file, selected_names, target_members):
	target_names = []
	for member in target_members:
		target_names.append (path.basename (member))
	for zip_member in selected_names:
		#print 'Content:%s\r' % zip_member,
		zip_member_base = path.basename (zip_member)
		#print 'zip_member_base', zip_member_base
		if zip_member_base in target_names:
			i = target_names.index (zip_member_base)
			dest_path = target_members [i]
			print 'Extracting: %s to %s' % (zip_member, dest_path)
			file_out = open (dest_path, 'wb')
			file_out.write (zip_file.read (zip_member))
			file_out.close ()

def zip_install (download_dir, url, target_members, zip_extracter = unzip_selected):
	download (url, download_dir)
	zip_file = zipfile.ZipFile (download_path (url, download_dir), 'r')
	namelist = zip_file.namelist ()
	zip_extracter (zip_file, namelist, target_members)
	zip_file.close ()
	#os.remove (zip_path)

def has_member (fname):
 return 

def debian_install (download_dir, url, target_members):
	download (url, download_dir)
	deb = debfile.DebFile (download_path (url, download_dir))
	for deb_fpath in deb.data:
		for fpath in target_members:
			fname = path.basename (fpath)
			if re.match(r'^.*%s$' % fname, deb_fpath):
				print('Extracting file %s ...' % deb_fpath)
				out = open(fpath, 'w')
				out.write(deb.data.get_content(deb_fpath))
				out.close()


def gnome_org_platform (ise_platform):
	if ise_platform == 'windows':
		result = 'win32'
	else:
		result = ise_platform
	return result

def debian_platform (ise_platform):
	if ise_platform.endswith ('x86-64'):
		result = 'amd64'
	else:
		result = 'i386'
	return result

def shortest_dirname (source):
	# dirname with fewest number of path steps
	min_steps = 1000
	result = '.'
	for item in source:
		source_path = str (item)
		path_steps = len (source_path.rsplit (os.sep))
		if path_steps < min_steps:
			result = path.dirname (source_path)
			min_steps = path_steps
	return result




