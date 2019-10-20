
from eiffel_loop.distutils import file_util

table = file_util.read_table ('source/taglib.getlib')
for key in table.keys ():
	print key + ': ' + table [key]
