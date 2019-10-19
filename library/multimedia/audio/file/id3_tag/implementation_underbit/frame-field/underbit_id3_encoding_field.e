note
	description: "Underbit id3 encoding field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	UNDERBIT_ID3_ENCODING_FIELD

inherit
	ID3_ENCODING_FIELD

	UNDERBIT_ID3_FRAME_FIELD

create
	make

feature -- Access

	encoding: NATURAL_8
			--
		do
			Result := c_id3_field_gettextencoding (self_ptr).to_natural_8
		end

feature -- Element change

	set_encoding (new_encoding: NATURAL_8)
		do
			c_call_status := c_id3_field_settextencoding (self_ptr, new_encoding.to_integer_32)
		ensure then
			c_call_succeeded: c_call_status = 0
		end

feature {NONE} -- Constant

	Underbit_type: INTEGER
		once
			Result := field_type_text_encoding
		end

end
