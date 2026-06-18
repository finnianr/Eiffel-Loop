# EiffelStudio project environment

from eiffel_loop.eiffel.dev_environ import *

build_info_path = "source/root/build_info.e"

image_utils_path = "$EIFFEL_LOOP/C_library/image-utils/spec/$ISE_PLATFORM"

if os.name == "nt":
	# 'PATH' label must be UPPERCASE
	append_to_path (image_utils_path)

else:
	set_environ ('LD_LIBRARY_PATH', image_utils_path)

os.environ ['GTK_THEME'] = 'Mint-X-Teal-Custom:light'
