# EiffelStudio project environment

import os
from eiffel_loop.project import *

version = (1, 0, 0)

installation_sub_directory = 'Eiffel-Loop/graphical'

tests = None

if platform.system () == "Windows":
	program_files_dir = os.environ ['ProgramFiles']
	gtk_path = "$EIFFEL_LOOP/contrib/C/gtk3.0/spec/$ISE_PLATFORM"
	svg_graphics_path = "$EIFFEL_LOOP/C_library/image-utils/spec/$ISE_PLATFORM"
	environ ['PATH'] = "$PATH;%s;%s" % (gtk_path, svg_graphics_path)
	
else:
	program_files_dir = '/opt'
	environ ['LD_LIBRARY_PATH'] = "$EIFFEL_LOOP/C_library/image-utils/spec/$ISE_PLATFORM"

