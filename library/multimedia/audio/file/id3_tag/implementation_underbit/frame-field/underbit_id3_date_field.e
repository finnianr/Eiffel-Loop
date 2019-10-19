note
	description: "Summary description for {UNDERBIT_ID3_DATE_FIELD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	UNDERBIT_ID3_DATE_FIELD

inherit
	ID3_DATE_FIELD

	UNDERBIT_ID3_LATIN_1_FIELD
		undefine
			type
		redefine
			set_string, get_latin_1, Underbit_type
		end

create
	make

feature -- Element change

	set_string (str: like string)
		require else
			three_characters: str.count = 8
		do
			set_immediate_value (str)
		end

feature {NONE} -- Implementation

	get_latin_1: POINTER
		do
			Result := c_id3_field_value (self_ptr) -- immediate.value
		end

feature {NONE} -- Constant

	Underbit_type: INTEGER
		once
			Result := field_type_date
		end
end
