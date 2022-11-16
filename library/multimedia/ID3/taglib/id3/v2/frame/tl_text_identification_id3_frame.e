note
	description: "Text identification ID3 frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "9"

class
	TL_TEXT_IDENTIFICATION_ID3_FRAME

inherit
	TL_ID3_TAG_FRAME

	TL_TEXT_IDENTIFICATION_ID3_FRAME_CPP_API
		export
			{TL_ID3_FRAME_ITERATION_CURSOR} cpp_conforms
		end

	TL_SHARED_STRING_ENCODING_ENUM

create
	make, make_from_pointer

feature {NONE} -- Initialization

	make (a_frame_id, a_encoding: NATURAL_8)
		require
			valid_code: valid_frame_id (a_frame_id)
			valid_encoding: valid_encoding (a_encoding)
		do
			Once_byte_vector.set_data_from_string (Frame_id.name (a_frame_id))
			make_from_pointer (cpp_new (Once_byte_vector.self_ptr, a_encoding))
		end

feature -- Access

	encoding: NATURAL_8
		-- the text encoding used when rendering this frame
		do
			Result := cpp_text_encoding (self_ptr)
		ensure
			valid: String_encoding.is_valid_value (Result)
		end

	field_list: EL_ZSTRING_LIST
		do
			Once_string_list.replace_all (cpp_field_list (self_ptr))
			Result := Once_string_list.to_list
		end

end