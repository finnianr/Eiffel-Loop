# EiffelStudio project environment

from eiffel_loop.eiffel.dev_environ import *

ecf = 'graphical.ecf'

tests = None

if platform.system () == "Windows":

	# DLL paths must be prepended to search path otherwise you get this error:
	# "The procedure entry point g_type_class_adjust_private_offset cannot be found in library libgobject-2.0-0.dll"

	append_to_path ("$EIFFEL_LOOP/contrib/C/Cairo-1.12.16/spec/$ISE_PLATFORM")
	append_to_path ("$EIFFEL_LOOP/C_library/image-utils/spec/$ISE_PLATFORM")

#	gtk_path = "$EIFFEL_LOOP/contrib/C/gtk3.0/spec/$ISE_PLATFORM"
#	svg_graphics_path = "$EIFFEL_LOOP/C_library/image-utils/spec/$ISE_PLATFORM"
#	environ ['PATH'] = "$PATH;%s;%s" % (gtk_path, svg_graphics_path)
	
else:
	program_files_dir = '/opt'
	set_environ ('LD_LIBRARY_PATH', "$EIFFEL_LOOP/C_library/image-utils/spec/$ISE_PLATFORM")

