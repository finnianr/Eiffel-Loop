#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "16 Dec 2011"
#	revision: "0.1"

import os, sys
from os import path

def prefixed_list (prefix, path_list):
	result = []
	for a_path in path_list:
		result.append (path.join (prefix, a_path))
	return result;

def complete_targets (target, source, env):
	# For use as an emitter with scons Builder.

	# Usually only the first source file has a target.
	# This completes the list of targets so that each source has a corresponding target 
	# by combining the directory name and extension of first target 
	# with the source base names (without the extension).

	first_target_path = str (target [0])
	target_dir = path.dirname (first_target_path)
	target_extension = path.splitext (first_target_path)[1]
	for i in range (1, len (source)):
		source_name = path.basename (str (source [i]))
		target_name = path.splitext (source_name)[0] + target_extension
		
		target.append (path.join (target_dir, target_name))
	return target, source

def add_lib_a_to_targets (target, source, env):
	print 'add_lib_a_to_targets', len (target), len (source)
	for i in range (0, len (source)):
		target_path = str (target [i])
		lib_a_path = target_path.replace ('.so.2',  '.a')
		print 'Emitting %s' % i, lib_a_path
		target.append (lib_a_path)
		source.append (source [i])
	return target, source

