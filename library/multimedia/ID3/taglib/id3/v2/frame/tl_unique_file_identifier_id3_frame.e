note
	description: "Unique file identifier frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	TL_UNIQUE_FILE_IDENTIFIER_ID3_FRAME

inherit
	TL_UNIQUE_FILE_IDENTIFIER

	TL_DESCRIBEABLE_ID3_TAG_FRAME
		rename
			description as owner,
			set_description as set_owner,
			cpp_get_description as cpp_get_owner,
			cpp_set_description as cpp_set_owner
		end

	TL_UNIQUE_FILE_IDENTIFIER_FRAME_CPP_API
		export
			{TL_ID3_FRAME_ITERATION_CURSOR} cpp_conforms
		end

create
	make, make_from_pointer

feature {NONE} -- Initialization

	make (a_owner: READABLE_STRING_GENERAL; a_identifier: STRING)
		do
			Once_string.set_from_string (a_owner)
			Once_byte_vector.set_data_from_string (a_identifier)
			make_from_pointer (cpp_new (Once_string.self_ptr, Once_byte_vector.self_ptr))
		end

feature -- Access

	identifier: STRING
		do
			cpp_get_identifier (self_ptr, Once_byte_vector.self_ptr)
			Result := Once_byte_vector.to_string_8
		end

feature -- Status query

	is_default: BOOLEAN
		do
		end

feature -- Element change

	set_identifier (a_identifier: STRING)
		do
			Once_byte_vector.set_data_from_string (a_identifier)
			cpp_set_identifier (self_ptr, Once_byte_vector.self_ptr)
		end

end