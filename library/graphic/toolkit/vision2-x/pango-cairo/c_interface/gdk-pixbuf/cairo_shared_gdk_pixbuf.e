note
	description: "Cairo shared GDK pixbuf"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-30 15:13:37 GMT (Monday 30th May 2022)"
	revision: "1"

deferred class
	CAIRO_SHARED_GDK_PIXBUF

inherit
	EL_ANY_SHARED

feature -- Access

	Gdk_pixbuf: CAIRO_GDK_PIXBUF_I
		once
			create {CAIRO_GDK_PIXBUF_API} Result.make
		end
end