note
	description: "Summary description for {UNDERBIT_ID3_INTEGER_FIELD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	UNDERBIT_ID3_INTEGER_FIELD

inherit
	ID3_INTEGER_FIELD

	UNDERBIT_ID3_FRAME_FIELD
		redefine
			is_field_type_valid
		end

create
	make

feature -- Access

	integer: INTEGER
			--
		do
			Result := c_id3_field_getint (self_ptr)
		end

feature -- Element change

	set_integer (number: INTEGER)
		do
			c_call_status := c_id3_field_setint (self_ptr, number)
		ensure then
			c_call_succeeded: c_call_status = 0
		end

feature {NONE} -- Contract Support

	is_field_type_valid: BOOLEAN
		do
			Result := Precursor
				or else underbit_field_type = field_type_int8
				or else underbit_field_type = field_type_int16
				or else underbit_field_type = field_type_int24
		end

feature {NONE} -- Constant

	Underbit_type: INTEGER
		once
			Result := field_type_int32
		end
end
