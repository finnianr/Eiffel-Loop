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

from SCons.Script import *

# SCRIPT START
arguments = Variables()
arguments.Add (EnumVariable('cpu', 'Set target cpu for compiler', 'x64', allowed_values=('x64', 'x86')))

arguments.Add (
	EnumVariable('action', 'Set build action', 'finalize',
		allowed_values=(
			Split ("freeze finalize finalize_and_test finalize_and_install install_resources make_installers")
		)
	)
)
arguments.Add (BoolVariable ('compile_eiffel', 'Compile Eiffel source (no implies C compile only)', 'yes'))
arguments.Add (BoolVariable ('install', 'Set to \'yes\' to install finalized release', 'no'))

#arguments.Add (
#	ListVariable (
#		'MSC_options', 'Visual Studio setenv.cmd options', '', Split ("/Debug /Release /x86 /x64 /ia64 /vista /xp /2003 /2008 /win7")
#	)
#)

env = Environment (variables = arguments)

Help (arguments.GenerateHelpText (env) + '\nproject: Set to name of Eiffel project configuration file (*.ecf)\n')

if env.GetOption ('help'):
	None
	
else:
	is_windows_platform = sys.platform == 'win32'
	project_py = project.read_project_py ()

#	MSC_options = env.get ('MSC_options').data
#	if MSC_options:
#		project_py.MSC_options = MSC_options
#		print 'MSC_options:', project_py.MSC_options
	
	action = env.get ('action')
	compile_eiffel = env.get ('compile_eiffel')
	print 'compile_eiffel', compile_eiffel

	project_py.set_build_environment (env.get ('cpu'))


	env.Append (ENV = os.environ, ISE_PLATFORM = ise.platform, ISE_C_COMPILER = ise.c_compiler)
	
	pecf_path = path.splitext (project_py.ecf)[0] + '.pecf'
	config = EIFFEL_CONFIG_FILE (project_py.ecf)

	if action == 'install_resources':
		build = FREEZE_BUILD (config, project_py)
		build.post_compilation ()
	else:
		if action in ['finalize', 'make_installers']:
			tar_build = C_CODE_TAR_BUILD (config, project_py)
			build = FINALIZED_BUILD (config, project_py)
	
			if compile_eiffel:
				env.Append (EIFFEL_BUILD = tar_build)
				env.Append (BUILDERS = {'eiffel_compile' : Builder (action = eiffel.compile_eiffel)})
				f_code = env.eiffel_compile (tar_build.target (), project_py.ecf)
			else:
				f_code = None
				
		else:
			build = FREEZE_BUILD (config, project_py)
			f_code = None

		env.Append (C_BUILD = build)
		env.Append (BUILDERS = {'c_compile' : Builder (action = eiffel.compile_C_code)})
		if compile_eiffel:
			env.Append (BUILDERS = {'write_ecf' : Builder (action = eiffel.write_ecf_from_pecf)})
			ecf = env.write_ecf (project_py.ecf, pecf_path)
		else:
			ecf = None

		if f_code:
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
			if env.GetOption ('clean') or not path.exists (lib):
				if not lib in lib_dependencies:
					lib_dependencies.append (lib)

		if f_code:
			Depends (tar_build.target (), lib_dependencies)
			productions = [executable, tar_build.target ()]
		else:
			Depends (executable, lib_dependencies)
			productions = [executable]
		if ecf:
			productions.append (ecf)

		env.NoClean (productions)

