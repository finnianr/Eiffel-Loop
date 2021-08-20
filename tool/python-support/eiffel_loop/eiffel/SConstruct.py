#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "3 June 2010"
#	revision: "0.2"

import os, sys

from os import path

from eiffel_loop.eiffel import ise
from eiffel_loop.eiffel import project
from eiffel_loop.scons import eiffel

from eiffel_loop.eiffel.ecf import EIFFEL_CONFIG_FILE
from eiffel_loop.eiffel.ecf import FREEZE_BUILD
from eiffel_loop.eiffel.ecf import C_CODE_TAR_BUILD
from eiffel_loop.eiffel.ecf import FINALIZED_BUILD
from eiffel_loop.eiffel.ecf import FINALIZED_BUILD_FROM_TAR

from SCons.Script import *

class OPTIONS (object):
	# command line options
	
	Action = 'action'

	# Command options
	Root_class = 'root_class'
	Help = 'help'
	Clean = 'clean'

	# Action values
	Freeze = 'freeze'
	Finalize = 'finalize'
	Finalize_and_test = 'finalize_and_test'
	Finalize_and_install = 'finalize_and_install'

# Access
	def action (self):
		# Eiffel compile action
		return self.env.get (self.Action)

	def root_class (self):
		# Alternative root class or None
		return self.env.get (self.Root_class)

# Element change
	def set_env_and_help (self):
		args = Variables()
		action_list = [self.Freeze, self.Finalize, self.Finalize_and_test, self.Finalize_and_install]

		args.Add (EnumVariable (self.Action, 'Set build action', self.Finalize, allowed_values = (action_list)))
		args.Add (PathVariable (self.Root_class, 'Path to alternative root class', None, PathVariable.PathExists))

		self.env = Environment (variables = args)
		Help (args.GenerateHelpText (self.env))

# Status query
	def clean (self):
		return self.env.GetOption (self.Clean)

	def finalize (self):
		return self.action () == self.Finalize

	def help (self):
		return self.env.GetOption (self.Help)

# end class OPTIONS

option = OPTIONS ()
option.set_env_and_help ()

env = option.env

if option.help ():
	None
	
else:
	print "Alternative root class: '%s'" % option.root_class ()
	
	project_py = project.read_project_py ()
	print "project_py.keep_assertions", project_py.keep_assertions

	print 'compile_eiffel', project_py.compile_eiffel

	project_py.set_build_environment ()

	env.Append (ENV = os.environ, ISE_PLATFORM = ise.platform, ISE_C_COMPILER = ise.c_compiler)
	
	config = EIFFEL_CONFIG_FILE (project_py.ecf)
	config.keep_assertions = project_py.keep_assertions
	config.root_class_path = option.root_class ()
	f_code_tar = None; tar_build = None

	if option.finalize ():
		if project_py.build_f_code_tar:
			# Two stage build
			# 1. Compile Eiffel, generate C and archive it in F_code-<platform>.tar
			# 2. Extract the code and compile the C
			tar_build = C_CODE_TAR_BUILD (config, project_py)
			env.Append (EIFFEL_BUILD = tar_build)

			env.Append (BUILDERS = {'eiffel_compile' : Builder (action = eiffel.compile_eiffel)})
			f_code_tar = env.eiffel_compile (tar_build.target (), project_py.ecf)
			build = FINALIZED_BUILD_FROM_TAR (config, project_py)

		elif project_py.compile_eiffel:
			# Normal Eiffel compile with C build
			build = FINALIZED_BUILD (config, project_py)
		else:
			# Building 32-bit version from F_code TAR archive
			build = FINALIZED_BUILD_FROM_TAR (config, project_py)

			if not path.exists (build.f_code_tar_path ()):
				print "Cannot find:", build.f_code_tar_path ()
				build = FINALIZED_BUILD (config, project_py)

	else:
		build = FREEZE_BUILD (config, project_py)

	env.Append (C_BUILD = build)
	env.Append (BUILDERS = {'c_compile' : Builder (action = eiffel.compile_C_code)})

	if f_code_tar:
		executable = env.c_compile (build.target (), tar_build.target ())
	else:
		executable = env.c_compile (build.target (), project_py.ecf)

	eiffel.check_C_libraries (env, build)
	if len (build.SConscripts) > 0:
		print "\nDepends on External libraries:"
		for script in build.SConscripts:
			print "\t" + script

	SConscript (build.SConscripts, exports='env')

	# only make library a dependency if it doesn't exist or object files are being cleaned out
	lib_dependencies = []
	for lib in build.scons_buildable_libs:
		if option.clean () or not path.exists (lib):
			if not lib in lib_dependencies:
				lib_dependencies.append (lib)

	if f_code_tar:
		Depends (tar_build.target (), lib_dependencies)
		productions = [executable, tar_build.target ()]
	else:
		Depends (executable, lib_dependencies)
		productions = [executable]

	env.NoClean (productions)

