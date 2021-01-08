note
	description: "[
		Wraps Taglib::FileName <tiostream.h>
			typedef const char *FileName;
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-08 15:56:47 GMT (Friday 8th January 2021)"
	revision: "6"

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

create
	make, make_from_string

convert
	make ({EL_FILE_PATH})

feature {NONE} -- Initialization

	make_from_string (name: ZSTRING)
		local
			utf_8: STRING; to_c: ANY; buffer: EL_STRING_8_BUFFER_ROUTINES
		do
			utf_8 := buffer.copied_general_as_utf_8 (name)
			to_c := utf_8.to_c
			make_from_pointer ($to_c, utf_8.count + 1)
		end
end