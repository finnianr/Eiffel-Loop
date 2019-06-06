# EiffelStudio project environment

import os
from eiffel_loop.eiffel.dev_environ import *

version = (1, 0, 0); build = 42

installation_sub_directory = 'Eiffel-Loop/graphical'

tests = None

if platform.system () == "Windows":
	program_files_dir = os.environ ['ProgramFiles']

	cairo_path = "$EIFFEL_LOOP/contrib/C/Cairo-1.12.16/spec/$ISE_PLATFORM"
	image_utils_path = "$EIFFEL_LOOP/C_library/image-utils/spec/$ISE_PLATFORM"

	# DLL paths must be prepended to search path otherwise you get this error:
	# "The procedure entry point g_type_class_adjust_private_offset cannot be found in library libgobject-2.0-0.dll"

	set_environ ('Path', "%s;%s;$Path" % (cairo_path, image_utils_path))


#	gtk_path = "$EIFFEL_LOOP/contrib/C/gtk3.0/spec/$ISE_PLATFORM"
#	svg_graphics_path = "$EIFFEL_LOOP/C_library/image-utils/spec/$ISE_PLATFORM"
#	environ ['PATH'] = "$PATH;%s;%s" % (gtk_path, svg_graphics_path)
	
else:
	program_files_dir = '/opt'
	set_environ ('LD_LIBRARY_PATH', "$EIFFEL_LOOP/C_library/image-utils/spec/$ISE_PLATFORM")

