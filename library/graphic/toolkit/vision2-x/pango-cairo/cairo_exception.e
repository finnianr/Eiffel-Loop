note
	description: "Cairo exception"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-09 9:46:35 GMT (Tuesday 9th January 2024)"
	revision: "3"

class
	CAIRO_EXCEPTION

inherit
	DEVELOPER_EXCEPTION

	CAIRO_GLIB_SHARED_API

create
	make

feature {NONE} -- Initialization

	make (error: CAIRO_GSTRING_I)
		do
			set_description (error.string)
		end
end