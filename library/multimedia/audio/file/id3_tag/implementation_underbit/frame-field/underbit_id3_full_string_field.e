note
	description: "Summary description for {UNDERBIT_ID3_FULL_STRING_FIELD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
