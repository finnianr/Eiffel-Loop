note
	description: "Tl file name"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-25 18:17:08 GMT (Friday   25th   October   2019)"
	revision: "1"

class
	TL_FILE_NAME

inherit
	MANAGED_POINTER
		rename
			make as make_sized
		export
			{NONE} all
			{EL_C_OBJECT} item
		end

	EL_SHARED_ONCE_STRING_8

create
	make

feature {NONE} -- Implementation

	make (name: ZSTRING)
		local
			utf_8: STRING
		do
			utf_8 := empty_once_string_8
			name.append_to_utf_8 (utf_8)
			make_sized (utf_8.count)
			make_from_pointer (utf_8.area.base_address, utf_8.count)
		end
end
