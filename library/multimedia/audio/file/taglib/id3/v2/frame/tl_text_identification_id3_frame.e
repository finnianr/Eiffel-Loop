note
	description: "Text identification ID3 frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-19 16:07:49 GMT (Thursday 19th March 2020)"
	revision: "5"

class
	TL_TEXT_IDENTIFICATION_ID3_FRAME

inherit
	TL_TEXT_ID3_FRAME

	TL_TEXT_IDENTIFICATION_ID3_FRAME_CPP_API
		export
			{TL_ID3_FRAME_ITERATION_CURSOR} cpp_conforms
		end

	TL_SHARED_STRING_ENCODING_ENUM

create
	make, make_from_pointer

feature {NONE} -- Initialization

	make (enum_code, encoding: NATURAL_8)
		require
			valid_code: valid_frame_id (enum_code)
			valid_encoding: valid_encoding (encoding)
		do
			Once_byte_vector.set_data_from_string (Frame_id.name (enum_code))
			make_from_pointer (cpp_new (Once_byte_vector.self_ptr, encoding))
		end

end
