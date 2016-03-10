#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "2 June 2010"
#	revision: "0.1"

import platform
from os import path
from distutils.dir_util import *

from eiffel_loop import osprocess

global is_windows

is_windows = platform.system () == 'Windows'

# Directory operations requiring root or administrator permissions

def sudo_mkpath (dir_path):
	parent_path = path.dirname (dir_path)
	if not path.exists (parent_path):
		sudo_mkpath (parent_path)

	if is_windows:
		osprocess.call (['mkdir', dir_path], shell = True)
	else:
		osprocess.sudo_call (['mkdir', dir_path])

def sudo_copy_tree (src_path, dest_path):
	if is_windows:
		osprocess.call (['xcopy', '/S', '/I', src_path, dest_path], shell = True)
	else:
		osprocess.sudo_call (['cp', '-r', src_path, dest_path])

def sudo_remove_tree (dir_path):
	if is_windows:
		osprocess.call (['rmdir', '/S', '/Q', dir_path], shell = True)
	else:
		osprocess.sudo_call (['rm', '-r', dir_path])
		
def make_link (name, target):
	if is_windows:
		osprocess.call (['mklink', '/D', name, target], shell = True)
	else:
		return

def make_archive (archive_path, target):
	dir_path = path.dirname (target)
	target_dir = path.basename (target)
	command = ['tar', '--create', '--gzip', '--file=' + archive_path]
	if dir_path:
		command.extend (['--directory', dir_path, target_dir])
	else:
		command.append (target_dir)

	if is_windows:
		osprocess.call (command, shell = True)
	else:
		osprocess.call (command)

def extract_archive (archive_path, dir_path, env):
	command = ['tar', '--extract', '--gunzip', '--file=' + archive_path, '--directory', dir_path]
	if is_windows:
		osprocess.call (command, shell = True, env = env)
	else:
		osprocess.call (command, env = env)




