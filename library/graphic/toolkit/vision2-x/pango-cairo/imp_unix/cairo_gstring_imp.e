note
	description: "Cairo GDK string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-09 9:14:01 GMT (Tuesday 9th January 2024)"
	revision: "4"

class
	CAIRO_GSTRING_IMP

inherit
	CAIRO_GSTRING_I

	EV_GTK_C_STRING
		rename
			make_from_path as make_from_ise_path
		export
			{NONE} all
		end

create
	make_from_ise_path, make_from_path, share_from_pointer

feature {NONE} -- Initialization

	make_from_path (a_path: EL_PATH)
			-- Set `item' to the content of `a_path'.
		local
			utf_8: STRING; c_str: ANY
		do
			utf_8 := a_path.to_utf_8
			string_length := utf_8.count
			c_str := utf_8.to_c
			item := {GTK}.g_malloc (utf_8.count + 1)
			item.memory_copy ($c_str, utf_8.count + 1)
			is_shared := False
		end

end