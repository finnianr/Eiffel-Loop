note
	description: "Underbit id3 date field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-15 11:29:31 GMT (Tuesday   15th   October   2019)"
	revision: "1"

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
