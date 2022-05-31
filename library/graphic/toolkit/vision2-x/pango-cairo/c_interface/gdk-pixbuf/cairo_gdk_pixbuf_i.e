note
	description: "Interface to routines in `<gdk-pixbuf.h>'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-31 10:12:27 GMT (Tuesday 31st May 2022)"
	revision: "1"

deferred class
	CAIRO_GDK_PIXBUF_I

inherit
	EL_C_API_ROUTINES

feature -- Access

	new_from_file (file_path: FILE_PATH): POINTER
		deferred
		end

feature -- Measurement

	height (a_pixbuf: POINTER): INTEGER_32
		deferred
		end

	width (a_pixbuf: POINTER): INTEGER_32
		deferred
		end
end