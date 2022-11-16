note
	description: "Underbit id3 full string field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	UNDERBIT_ID3_FULL_STRING_FIELD

inherit
	UNDERBIT_ID3_STRING_FIELD
		redefine
			string, set_underbit_string, Underbit_type
		end

create
	make

feature -- Access

	string: ZSTRING
			--
		do
			Result := string_at_address (c_id3_field_getfullstring (self_ptr))
		end

feature {NONE} -- Implementation

	set_underbit_string (str_ptr: POINTER)
		do
			c_call_status := c_id3_field_setfullstring (self_ptr, str_ptr)
		end

feature {NONE} -- Constant

	Underbit_type: INTEGER
		once
			Result := field_type_full_string
		end
end