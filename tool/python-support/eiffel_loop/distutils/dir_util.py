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


class FILE_SYSTEM (object):

# Initialization
	def __init__ (self):
		self.make_path_cmd = ['mkdir']
		self.sudo = False
		if is_windows:
			self.copy_tree_cmd = ['xcopy', '/S', '/I']
			self.copy_file_cmd = ['copy']
			self.move_tree_cmd = ['move']
			self.remove_tree_cmd = ['rmdir', '/S', '/Q']
		else:
			self.copy_tree_cmd = ['cp', '-r']
			self.copy_file_cmd = ['cp']
			self.move_tree_cmd = ['mv']
			self.remove_tree_cmd = ['rm', '-r']

# Basic operations

	def copy_tree (self, src_path, dest_path):
		self.__call (self.copy_tree_cmd + [src_path, dest_path])

	def move_tree (self, src_path, dest_path):
		self.__call (self.move_tree_cmd + [src_path, dest_path])

	def copy_file (self, src_path, dest_path):
		self.__call (self.copy_file_cmd + [src_path, dest_path])

	def remove_tree (self, dir_path):
		self.__call (self.remove_tree_cmd + [dir_path])

	def make_path (self, dir_path):
		parent_path = path.dirname (dir_path)
		if not path.exists (parent_path):
			self.make_path (parent_path)

		self.__call (self.make_path_cmd + [dir_path])

# Implementation

	def __call (self, cmd):
		if is_windows:
			osprocess.call (cmd, shell = True)
		elif self.sudo:
			osprocess.sudo_call (cmd)		
		else:
			osprocess.call (cmd)		
		
