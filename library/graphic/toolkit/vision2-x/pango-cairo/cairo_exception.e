note
	description: "Cairo exception"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-01 9:40:53 GMT (Wednesday 1st June 2022)"
	revision: "1"

class
	CAIRO_EXCEPTION

inherit
	DEVELOPER_EXCEPTION

	CAIRO_SHARED_GDK_API

create
	make

feature {NONE} -- Initialization

	make (heading: READABLE_STRING_GENERAL; error_ptr: POINTER)
		do
			set_description (heading + ": " + Gdk.error_message (error_ptr).string)
		end
end