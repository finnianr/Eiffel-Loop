from os import path

from distutils import dir_util, file_util

if path.exists ('package'):
	dir_util.remove_tree ('package')
	
bin_path = path.join ('package', 'bin')
dir_util.mkpath (bin_path)
file_util.copy_file ('EIFGENs/classic/F_code/el_server', bin_path)
dir_util.copy_tree ('graphics/icons', 'package/icons')


