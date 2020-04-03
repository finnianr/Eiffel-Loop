note
	description: "Underbit id3 frame id field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-15 11:34:57 GMT (Tuesday 15th October 2019)"
	revision: "1"

class
	UNDERBIT_ID3_FRAME_ID_FIELD

inherit
	ID3_FRAME_ID_FIELD

	UNDERBIT_ID3_LATIN_1_FIELD
		rename
			string as id,
			set_string as set_id
		undefine
			type
		redefine
			get_latin_1, set_latin_1, Underbit_type
		end

create
	make

feature {NONE} -- Implementation

	set_latin_1 (c_str: POINTER)
		do
			c_call_status := c_id3_field_setframeid (self_ptr, c_str)
		ensure then
			is_set: c_call_status = 0
		end

	get_latin_1: POINTER
		do
			Result := c_id3_field_getframeid (self_ptr)
		end

feature {NONE} -- Constant

	Underbit_type: INTEGER
		once
			Result := field_type_frame_id
		end

end
