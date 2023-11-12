note
	description: "[
		Wraps Taglib::FileName <tiostream.h>
			typedef const char *FileName;
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-11 14:34:48 GMT (Saturday 11th November 2023)"
	revision: "9"

class
	TL_FILE_NAME

inherit
	TL_FILE_NAME_I undefine copy, is_equal end

	MANAGED_POINTER
		rename
			make as make_sized
		export
			{NONE} all
			{EL_C_OBJECT} item, count
		end

	EL_SHARED_STRING_8_BUFFER_SCOPES

create
	make, make_from_string

convert
	make ({FILE_PATH})

feature {NONE} -- Initialization

	make_from_string (name: ZSTRING)
		local
			to_c: ANY
		do
			across String_8_scope as scope loop
				if attached scope.copied_utf_8_item (name) as utf_8 then
					to_c := utf_8.to_c
					make_from_pointer ($to_c, utf_8.count + 1)
				end
			end
		end
end