note
	description: "Cairo GDK string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	CAIRO_GSTRING_IMP

inherit
	CAIRO_GSTRING_I

	EV_GTK_C_STRING
		export
			{NONE} all
		end

create
	make_from_path, make_from_file_path, share_from_pointer

feature {NONE} -- Initialization

	make_from_file_path (file_path: FILE_PATH)
			-- Set `item' to the content of `a_path'.
		local
			utf_8: STRING; c_str: ANY
		do
			utf_8 := file_path.to_utf_8
			string_length := utf_8.count
			c_str := utf_8.to_c
			item := {GTK}.g_malloc (utf_8.count + 1)
			item.memory_copy ($c_str, utf_8.count + 1)
			is_shared := False
		end

end