# EiffelStudio project environment

import os
from eiffel_loop.project import *

major_version = 1

minor_version = 0

installation_sub_directory = 'Eiffel-Loop/graphical'

tests = None

if platform.system () == "Windows":
	program_files_dir = os.environ ['ProgramFiles']
	gtk_path = "$EIFFEL_LOOP/contrib/C/gtk+/spec/$ISE_PLATFORM"
	rsvg_path = "$EIFFEL_LOOP/contrib/C/RSVG/spec/$ISE_PLATFORM"
	environ ['PATH'] = "$PATH;%s;%s" % (gtk_path, rsvg_path)
	
else:
	program_files_dir = '/opt'

	#environ ['LD_LIBRARY_PATH'] = path.join (program_files_dir, installation_sub_directory, 'bin')
	#environ ['LD_LIBRARY_PATH'] = "/mnt/Development/C/libcairo2-dev_1.10.2/lib/x86_64-linux-gnu"
	environ ['LD_LIBRARY_PATH'] = "$EIFFEL_LOOP/contrib/C/RSVG/spec/$ISE_PLATFORM"
