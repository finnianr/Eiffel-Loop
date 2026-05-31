from eiffel_loop.test import *

import sysconfig

from eiffel_loop.os import env as os_env

check ('jdk_home', path.exists (path.join (os_env.jdk_home (), 'bin/java')))
check ('eiffel_loop_dir', os_env.eiffel_loop_dir () == path.expanded ('$EIFFEL/library/Eiffel-Loop'))
check ('python3_include', os_env.python3_include () == sysconfig.get_path ("include"))

if os.name == 'posix':
	lib_path = sysconfig.get_config_var ("LIBDIR") + "/lib%s.so" %  os_env.python3_lib_name ()
	print ('Python3 lib path:', lib_path)
	check ('python3_lib_name', path.exists (lib_path))
