note
	description: "Summary description for {UNDERBIT_ID3_FULL_LATIN_1_FIELD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	UNDERBIT_ID3_FULL_LATIN_1_FIELD

inherit
	UNDERBIT_ID3_LATIN_1_FIELD
		redefine
			get_latin_1, set_latin_1, Underbit_type
		end

create
	make

feature {NONE} -- Implementation

	set_latin_1 (c_str: POINTER)
		do
			c_call_status := c_id3_field_setfulllatin1 (self_ptr, c_str)
		ensure then
			is_set: c_call_status = 0
		end

	get_latin_1: POINTER
		do
			Result := c_id3_field_getfulllatin1 (self_ptr)
		end

feature {NONE} -- Constant

	Underbit_type: INTEGER
		once
			Result := field_type_full_latin1
		end
end
