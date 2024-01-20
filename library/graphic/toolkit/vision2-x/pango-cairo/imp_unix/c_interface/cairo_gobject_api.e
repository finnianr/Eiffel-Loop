note
	description: "Unix implementation of ${CAIRO_GOBJECT_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "14"

class
	CAIRO_GOBJECT_API

inherit
	CAIRO_GOBJECT_I
		rename
			default_create as make,
			clear as g_clear_object,
			unref as object_unref
		end

	GTK2
		rename
			default_create as make
		export
			{NONE} all
		end

	EL_GTK_2_C_API
		rename
			default_create as make
		export
			{NONE} all
		end

	EL_UNIX_IMPLEMENTATION
		rename
			default_create as make
		end

create
	make

end