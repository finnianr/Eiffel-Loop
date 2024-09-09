#! /usr/bin/python

#	author: Finnian Reilly
#	copyright: Copyright (c) 2001-2012 Finnian Reilly
#	contact: finnian at eiffel hyphen loop dot com
#	license: MIT license (See: en.wikipedia.org/wiki/MIT_License)

#	description: Setup Linux development environment by linking into Windows environment

#	date: 9 Aug 2011
#	revision: 0.1

#   Status: obsolete

import os, sys
from os import path

global build_dirs, file_types

project_dir = 'Development/Eiffel'
user_dir = path.expanduser ('~')
source_root_dir = '/mnt/win/D'
build_dirs = ['build', 'package', 'EIFGENs', 'EIFGENs.win', '.sconf_temp']
file_types = ['sh', 'ecf', 'py', 'pyx', 'dat', 'SConstruct', 'txt']

def walk_dirs (source_dir, target_dir):
	print
	print "SOURCE:", source_dir

	for name in os.listdir (source_dir):
		source_path	= path.join (source_dir, name)
		target_path	= path.join (target_dir, name)
		if not path.islink (target_path):
			if path.isdir (source_path):
				if path.exists (target_path) and not name in build_dirs:
					walk_dirs (source_path, target_path)
				else:
					if name in build_dirs:
						print 'Skipping:', target_path
					elif name == 'tar.gz':
						print 'Moving:', source_path
						print 'to', path.dirname (target_path)
					else:
						print 'Creating link:', target_path
						print 'to:', source_path
						os.symlink (source_path, target_path)
			else:
				if '.' in name:
					extension = path.splitext (name)[1][1:]
				else:
					extension = name
				if not path.exists (target_path) and extension in file_types:
					print 'Creating link:', target_path
					print 'to:', source_path
					os.symlink (source_path, target_path)
				


# Start
print "CREATING SHADOW DIRECTORY STRUCTURE"

walk_dirs (
	path.join (source_root_dir, project_dir),
	path.join (user_dir, project_dir)
)

