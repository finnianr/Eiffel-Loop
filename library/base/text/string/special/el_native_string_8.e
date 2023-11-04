note
	description: "String with characters encoded in OS dependent manner"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-04 16:46:56 GMT (Saturday 4th November 2023)"
	revision: "1"

class
	EL_NATIVE_STRING_8

inherit
	STRING_8
		export
			{NONE} all
			{ANY} count
		redefine
			make_from_c
		end

	NATIVE_STRING_HANDLER
		undefine
			out, copy, is_equal
		end

create
	make_from_c
	
feature {NONE} -- Initialization

	make_from_c (c_string: POINTER)
		local
			byte_count: INTEGER
		do
			byte_count := pointer_length_in_bytes (c_string)
			make (byte_count)
			set_count (byte_count)
			area.base_address.memory_copy (c_string, byte_count)
		end

feature -- Conversion

	to_string: ZSTRING
		do
			if {PLATFORM}.is_windows then
				create Result.make_from_utf_16_le (Current)
			else
				create Result.make_from_utf_8 (Current)
			end
		end
end