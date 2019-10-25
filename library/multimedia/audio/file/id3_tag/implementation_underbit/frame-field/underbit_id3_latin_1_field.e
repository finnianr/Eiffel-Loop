note
	description: "Underbit id3 latin 1 field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-15 11:31:21 GMT (Tuesday   15th   October   2019)"
	revision: "1"

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
