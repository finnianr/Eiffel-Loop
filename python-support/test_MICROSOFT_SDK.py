import os, sys

from eiffel_loop.eiffel import dev_environ
#from eiffel_loop.eiffel import ise
from eiffel_loop.os import path
from eiffel_loop.os import environ
from eiffel_loop.eiffel import ise_environ
from eiffel_loop.C_util import C_dev
from eiffel_loop.os.environ import REGISTRY_NODE

if sys.platform == "win32":
	import _winreg

# set PYTHONPATH=D:\Eiffel\library\Eiffel-Loop\tool\python-support;%PYTHONPATH%

#sdk = C_dev.MICROSOFT_SDK ('msc_vc100', ['-arch=amd64'])
sdk = C_dev.MICROSOFT_SDK ('msc', C_dev.MICROSOFT_COMPILER_OPTIONS ())

print "sdk.sdk_version", sdk.sdk_version

print "sdk.setenv_cmd", sdk.setenv_cmd
 
sdk_environ = sdk.compiler_environ () 
for lib in ["LIB", "PATH"]:
	print lib, ":"
	for name in sdk_environ [lib].split (os.pathsep):
		print name
