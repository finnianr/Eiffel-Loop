note
	description: "Cairo exception"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "2"

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