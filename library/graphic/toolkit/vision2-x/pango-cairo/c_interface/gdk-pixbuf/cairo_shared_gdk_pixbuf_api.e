note
	description: "Shared instance of class conforming to ${CAIRO_GDK_PIXBUF_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "3"

deferred class
	CAIRO_SHARED_GDK_PIXBUF_API

inherit
	EL_ANY_SHARED

feature -- Access

	Gdk_pixbuf: CAIRO_GDK_PIXBUF_I
		once
			create {CAIRO_GDK_PIXBUF_API} Result.make
		end
end