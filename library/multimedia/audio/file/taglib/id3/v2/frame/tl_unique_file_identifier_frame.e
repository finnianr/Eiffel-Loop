note
	description: "Tl unique file identifier frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-18 18:09:34 GMT (Wednesday 18th March 2020)"
	revision: "1"

class
	TL_UNIQUE_FILE_IDENTIFIER_FRAME

inherit
	TL_ID3_TAG_FRAME

	TL_UNIQUE_FILE_IDENTIFIER_FRAME_CPP_API
		export
			{TL_ID3_FRAME_ITERATION_CURSOR} cpp_conforms
		end

create
	make, make_from_pointer

feature {NONE} -- Initialization

	make (a_owner_id: READABLE_STRING_GENERAL; a_id: STRING)
		do
			Once_string.set_from_string (a_owner_id)
			Once_byte_vector.set_data_from_string (a_id)
			make_from_pointer (cpp_new (Once_string.self_ptr, Once_byte_vector.self_ptr))
		end

feature -- Access

	identifier: STRING
		do
			cpp_get_identifier (self_ptr, Once_byte_vector.self_ptr)
			Result := Once_byte_vector.to_string_8
		end

	owner: ZSTRING
		do
			cpp_get_owner (self_ptr, Once_string.self_ptr)
			Result := Once_string.to_string
		end

feature -- Element change

	set_identifier (a_identifier: STRING)
		do
			Once_byte_vector.set_data_from_string (a_identifier)
			cpp_set_identifier (self_ptr, Once_byte_vector.self_ptr)
		ensure
			set: identifier ~ a_identifier
		end

	set_owner (a_owner: READABLE_STRING_GENERAL)
		do
			Once_string.set_from_string (a_owner)
			cpp_set_owner (self_ptr, Once_string.self_ptr)
		ensure
			set: a_owner.same_string (owner)
		end
end
