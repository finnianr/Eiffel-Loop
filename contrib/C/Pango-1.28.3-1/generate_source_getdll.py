# 	Generate *.getdll from log file: src\tml\packaging\pango_1.28.3-1_win64.log

#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2010 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "24 July 2020"
#	revision: "0.1"

import os

def lib_version_name (p):
	# remove head upto path step 'win64'
	steps = p.split ('/')
	i = steps.index ('win64')
	return steps [i + 1]

with open ('pango_1.28.3-1_win64.log', 'r') as f:
	
	dependency_set = set ()

	search_list = [line.rstrip () for line in f if 'PATH=' in line]
	
	for item in search_list:
		win_64_list = [lib_version_name (p) for p in item.split (':') if 'win64' in p]
		for lib in win_64_list:
			dependency_set.add (lib)

	for dep in dependency_set:
		print dep
	
