#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "3 June 2010"
#	revision: "0.2"

import os, sys

from os import path

from eiffel_loop.eiffel import project
from eiffel_loop.eiffel import ecf
from eiffel_loop.scons import eiffel

from SCons.Script import *

def set_precompile_variables (env, config):
	env.Append (EIF_PRECOMP_ECF = config.precompile_path)

	env.Append (EIF_PRECOMP_PLATFORM_DIR = path.dirname (config.precompile_path))
	env.Append (EIF_PRECOMP_DIR = path.dirname (env ['EIF_PRECOMP_PLATFORM_DIR']))
	env.Append (EIF_PRECOMP_NAME = config.precompile_name ())
	
	env.Append (EIF_PRECOMP_MASTER_ECF = path.join (env ['EIF_PRECOMP_DIR'], path.basename (config.precompile_path)))

	if env.has_key ('ISE_C_COMPILER'):
		# Must be Windows environment
		template = path.normpath ('$EIF_PRECOMP_PLATFORM_DIR/EIFGENs/$EIF_PRECOMP_NAME/W_code/$ISE_C_COMPILER/precomp$LIBSUFFIX')
	else:
		# Must be Unix environment
		template = path.normpath ('$EIF_PRECOMP_PLATFORM_DIR/EIFGENs/$EIF_PRECOMP_NAME/W_code/preobj$OBJSUFFIX')

	env.Append (EIF_PRECOMP_OBJECT = env.subst (template))
	print 'EIF_PRECOMP_OBJECT =', env ['EIF_PRECOMP_OBJECT']

# SCRIPT START

project_py = project.read_project_py ()
project.set_build_environment (project_py) 

arguments = Variables()
arguments.Add (EnumVariable('cpu', 'Set target cpu for compiler', 'x64', allowed_values=('x64', 'x86')))
arguments.Add (
	EnumVariable('action', 'Set build action', 'finalize',
		allowed_values=(
			'freeze',
			'finalize', 
			'finalize_and_test', 
			'finalize_and_install',
			'install_resources',
			'make_installers'
		)
	)
)
arguments.Add (BoolVariable ('install', 'Set to \'yes\' to install finalized release', 'no'))
arguments.Add (PathVariable ('project', 'Path to Eiffel configuration file', 'default.ecf'))		

env = Environment (
	variables = arguments, ENV = os.environ, ASCII_ENV = project.ascii_environ, ISE_PLATFORM = os.environ ['ISE_PLATFORM']
)
if os.environ.has_key ('ISE_C_COMPILER'):
	env.Replace (ISE_C_COMPILER = os.environ ['ISE_C_COMPILER'])

Help (arguments.GenerateHelpText (env) + '\nproject: Set to name of Eiffel project configuration file (*.ecf)\n')

if env.GetOption ('help'):
	None
	
else:
	action = env.get ('action') 
	if action == 'install_resources':
		config = ecf.FREEZE_BUILD (env, project_py)
		config.post_compilation ()
	else:
		if action in ['finalize', 'make_installers']:
			code_archive_config = ecf.GENERATE_EIFFEL_C_CODE (env, project_py)
			config = ecf.EIFFEL_C_CODE_COMPILE  (env, project_py)

			env.Append (EIFFEL_CONFIG = config)
			env.Append (EIFFEL_CODE_ARCHIVE_CONFIG = code_archive_config)

			env.Append (BUILDERS = {'Generate_code_archive' : Builder (action = eiffel.compile_to_C)})
			env.Append (BUILDERS = {'Eiffel_C_compile' : Builder (action = eiffel.compile_executable)})

			code_archive = env.Generate_code_archive (code_archive_config.target (), code_archive_config.ecf_path)
			print 'code_archive', code_archive
			env.NoClean (code_archive)

			executable = env.Eiffel_C_compile (config.target (), code_archive_config.target ())
		else:
			config = ecf.FREEZE_BUILD (env, project_py)
			env.Append (EIFFEL_CONFIG = config)
			env.Append (BUILDERS = {'Freeze_compile' : Builder (action = eiffel.compile_executable)})
			executable = env.Freeze_compile (config.target (), config.ecf_path)

		if config.pecf_path:
			env.Append (BUILDERS = {'PECF_converter' : Builder (action = eiffel.write_ecf_from_pecf)})
			ecf = env.PECF_converter (config.ecf_path, config.pecf_path)

		eiffel.check_C_libraries (env, config)
		print "\nDepends on External libraries", config.SConscripts
		SConscript (config.SConscripts, exports='env')

		# only make library a dependency if it doesn't exist or object files are being cleaned out
		lib_dependencies = []
		for lib in config.scons_buildable_libs:
			if env.GetOption ('clean') or not path.exists (lib):
				if not lib in lib_dependencies:
					lib_dependencies.append (lib)

		Depends (executable, lib_dependencies)

		if config.precompile_path:
			set_precompile_variables (env, config)

			env.Append (BUILDERS = {'Precompile' : Builder (action = eiffel.precompile)})

			precompile = env.Precompile ('$EIF_PRECOMP_OBJECT', '$EIF_PRECOMP_MASTER_ECF')

			Depends (executable, precompile)
			env.NoClean (precompile)

		env.NoClean (executable)

