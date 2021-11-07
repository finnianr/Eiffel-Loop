import os, sys

from eiffel_loop.eiffel import dev_environ
#from eiffel_loop.eiffel import ise
from eiffel_loop.os import path
from eiffel_loop.os import environ
from eiffel_loop.eiffel import ise_environ
from eiffel_loop.C_util import C_dev

if sys.platform == "win32":
	import _winreg

# set PYTHONPATH=D:\Eiffel\library\Eiffel-Loop\tool\python-support;%PYTHONPATH%

#print "ise.version:", ise.version ()

# os.environ ["ISE_VERSION"] = "20.11"

# print "user path:", path.expandvars (os.sep.join ([environ.system_path (), environ.user_path ()]))

#print "ise.eiffel", ise.eiffel

# print path.files_x86 ("C:\\Program Files")

for key, value in environ.bash_profile_table ().items ():
	print key, value

ise = ise_environ.shared


