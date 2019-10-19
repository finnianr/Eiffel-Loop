note
	description: "Summary description for {UNDERBIT_ID3_STRING_FIELD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	UNDERBIT_ID3_STRING_FIELD

inherit
	ID3_STRING_FIELD

	UNDERBIT_ID3_FRAME_FIELD
		rename
			make as make_from_pointer
		end

	UNDERBIT_ID3_STRING_ROUTINES

create
	make

feature -- Access

	string: ZSTRING
			--
		do
			Result := string_at_address (c_id3_field_getstring (self_ptr))
		end

	as_description: UNDERBIT_ID3_DESCRIPTION_FIELD
		do
			create Result.make (self_ptr, encoding)
		end

feature -- Element change

	set_encoding (new_encoding: NATURAL_8)
		do
		end

	set_string (str: ZSTRING)
		local
			str_32: STRING_32; to_c: ANY
		do
			str_32 := empty_once_string_32
			str.append_to_string_32 (str_32)
			to_c := str_32.to_c
			set_underbit_string ($to_c)
		end

feature {NONE} -- Implementation

	set_underbit_string (str_ptr: POINTER)
		do
			c_call_status := c_id3_field_setstring (self_ptr, str_ptr)
		ensure
			call_succeeded: c_call_status = 0
		end

feature {NONE} -- Constant

	Underbit_type: INTEGER
		once
			Result := field_type_string
		end
end
