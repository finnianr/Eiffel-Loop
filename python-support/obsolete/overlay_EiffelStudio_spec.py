#! /usr/bin/python

#	author: Finnian Reilly
#	copyright: Copyright (c) 2001-2012 Finnian Reilly
#	contact: finnian at eiffel hyphen loop dot com
#	license: MIT license (See: en.wikipedia.org/wiki/MIT_License)

#	description: 
#		Setup Linux development environment by linking into Windows environment

#	date: 9 Aug 2011
#	revision: 0.1

import os, sys
from os import path

global spec_dir, source_root_dir, target_root_dir

def walk_dirs (source_dir, target_dir):
	print
	print "SOURCE:", source_dir

	for name in os.listdir (source_dir):
		source_path	= path.join (source_dir, name)
		target_path	= path.join (target_dir, name)
		if path.isdir (source_path):
			if name == 'spec':
				print source_path
			else:
				walk_dirs (source_path, target_path)
				


# Start
if len (args) == 3:
	source_root_dir = args [1]
	print "Overlaying specs from", 
	source_root_dir = '/mnt/win/D'
	target_root_dir

	walk_dirs (source_root_dir, target_root_dir)
else:
	print "Usage: overlay_EiffelStudio_spec.py <EiffelStudio source> <architecture>"

