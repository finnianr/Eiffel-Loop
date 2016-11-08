#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "3 June 2010"
#	revision: "0.2"

import os, sys

from os import path

from eiffel_loop.eiffel import project
from eiffel_loop.scons import eiffel

from eiffel_loop.eiffel.ecf import EIFFEL_CONFIG_FILE
from eiffel_loop.eiffel.ecf import FREEZE_BUILD
from eiffel_loop.eiffel.ecf import FINALIZE_BUILD
from eiffel_loop.eiffel.ecf import RECOMPILED_X64_FINALIZE_BUILD

from SCons.Script import *

# SCRIPT START
arguments = Variables()
arguments.Add (EnumVariable('cpu', 'Set target cpu for compiler', 'x64', allowed_values=('x64', 'x86')))
arguments.Add (
	EnumVariable('action', 'Set build action', 'finalize',
		allowed_values=(
			'freeze', 'finalize', 'finalize_and_test', 'finalize_and_install',
			'install_resources',
			'make_installers'
		)
	)
)
arguments.Add (BoolVariable ('install', 'Set to \'yes\' to install finalized release', 'no'))
arguments.Add (PathVariable ('project', 'Path to Eiffel configuration file', 'default.ecf'))		

env = Environment (variables = arguments)

Help (arguments.GenerateHelpText (env) + '\nproject: Set to name of Eiffel project configuration file (*.ecf)\n')

if env.GetOption ('help'):
	None
	
else:
	is_windows_platform = sys.platform == 'win32'
	project_py = project.read_project_py ()
	
	cpu_option = env.get ('cpu')
	project_py.MSC_options.append ('/' + cpu_option)
	ecf_path = env.get ('project')
	action = env.get ('action') 

	project_py.update_os_environ (cpu_option == 'x86')

	env.Append (ENV = os.environ, ISE_PLATFORM = os.environ ['ISE_PLATFORM'])
	if 'ISE_C_COMPILER' in os.environ:
		env.Append (ISE_C_COMPILER = os.environ ['ISE_C_COMPILER'])

	config = EIFFEL_CONFIG_FILE (ecf_path, True)

	if action == 'install_resources':
		build = FREEZE_BUILD (config, project_py)
		build.post_compilation ()
	else:
		if action in ['finalize', 'make_installers']:
			build = FINALIZE_BUILD (config, project_py)
			if is_windows_platform and '/x86' in project_py.MSC_options:
				print 'Found:', build.win64_target ()
				if path.exists (build.win64_target ()):
					build = RECOMPILED_X64_FINALIZE_BUILD (config, project_py)
		else:
			build = FREEZE_BUILD (config, project_py)

		env.Append (EIFFEL_BUILD = build)
		env.Append (BUILDERS = {'eiffel_compile' : Builder (action = eiffel.compile_executable)})
		executable = env.eiffel_compile (build.target (), build.ecf_path)

		if build.pecf_path:
			env.Append (BUILDERS = {'PECF_converter' : Builder (action = eiffel.write_ecf_from_pecf)})
			ecf = env.PECF_converter (build.ecf_path, build.pecf_path)

		if build.precompile_path:
			env.Append (BUILDERS = {'precomp_copier' : Builder (action = eiffel.copy_precompile)})
			precompile_name = path.basename (build.precompile_path)
			precompile_dir = path.dirname (path.dirname (build.precompile_path))
			precomp_ecf = env.precomp_copier (build.precompile_path, path.join (precompile_dir, precompile_name))
			Depends (executable, build.precompile_path)

		eiffel.check_C_libraries (env, build)
		if len (build.SConscripts) > 0:
			print "\nDepends on External libraries:"
			for script in build.SConscripts:
				print "\t" + script

		SConscript (build.SConscripts, exports='env')

		# only make library a dependency if it doesn't exist or object files are being cleaned out
		lib_dependencies = []
		for lib in build.scons_buildable_libs:
			if env.GetOption ('clean') or not path.exists (lib):
				if not lib in lib_dependencies:
					lib_dependencies.append (lib)

		Depends (executable, lib_dependencies)

		env.NoClean ([executable, precomp_ecf])

