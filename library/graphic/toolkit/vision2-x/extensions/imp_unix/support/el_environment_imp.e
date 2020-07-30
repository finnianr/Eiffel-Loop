note
	description: "Environment with some routines to solve export visibility issues"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-29 10:19:07 GMT (Wednesday 29th July 2020)"
	revision: "1"

class
	EL_ENVIRONMENT_IMP

inherit
	EV_ENVIRONMENT_IMP

create
	make

feature {EL_SHARED_ACCESS} -- Access

	image_data (pixmap: EV_PIXMAP_IMP): POINTER
		-- Pointer to the GdkPixmap image data.
		do
			Result := pixmap.drawable
		end
end
