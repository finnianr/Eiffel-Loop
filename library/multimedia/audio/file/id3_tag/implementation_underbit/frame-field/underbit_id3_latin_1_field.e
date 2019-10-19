note
	description: "Summary description for {UNDERBIT_ID3_LATIN_1_FIELD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	UNDERBIT_ID3_LATIN_1_FIELD

inherit
	ID3_LATIN_1_STRING_FIELD

	UNDERBIT_ID3_FRAME_FIELD

create
	make

feature -- Access

	string: STRING
		do
			create Result.make_from_c (get_latin_1)
		end

feature -- Element change

	set_string (str: like string)
		local
			to_c: ANY
		do
			to_c := str.to_c
			set_latin_1 ($to_c)
		end

feature {NONE} -- Implementation

	set_latin_1 (c_str: POINTER)
		do
			c_call_status := c_id3_field_setlatin1 (self_ptr, c_str)
		ensure then
			is_set: c_call_status = 0
		end

	get_latin_1: POINTER
		do
			Result := c_id3_field_getlatin1 (self_ptr)
		end

feature {NONE} -- Constant

	Underbit_type: INTEGER
		once
			Result := field_type_latin1
		end

end
