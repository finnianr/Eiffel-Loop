note
	description: "Comments id3 frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-08 15:52:41 GMT (Tuesday 8th April 2025)"
	revision: "12"

class
	TL_COMMENTS_ID3_FRAME

inherit
	TL_COMMENTS

	TL_DESCRIBEABLE_ID3_TAG_FRAME

	TL_COMMENTS_ID3_FRAME_CPP_API
		export
			{TL_ID3_FRAME_ITERATION_CURSOR} cpp_conforms
		end

	TL_SHARED_BYTE_VECTOR; TL_SHARED_ONCE_STRING

	EL_STRING_GENERAL_ROUTINES_I

create
	make, make_from_pointer

feature {NONE} -- Initialization

	make (a_description, a_text: READABLE_STRING_GENERAL; a_language: STRING; a_encoding: NATURAL_8)
		do
			make_from_pointer (cpp_new (a_encoding))
			set_language (a_language)
			set_description (a_description)
			set_text (a_text)
		end

feature -- Access

	language: STRING
		local
			c: EL_CHARACTER_8_ROUTINES
		do
			cpp_get_language (self_ptr, Once_byte_vector.self_ptr)
			if attached Once_byte_vector.to_string_8 as tmp_str then
				create Result.make (tmp_str.count)
			-- Filter anything that is not in set 'a' .. 'z', 'A' .. 'Z'
			-- (weird characters found in test files)
				super_8 (tmp_str).filter (agent c.is_a_to_z_caseless, Result)
			end
		end

feature -- Status query

	is_default: BOOLEAN
		do
		end

feature -- Element change

	set_language (a_language: like language)
		do
			Once_byte_vector.set_data_from_string (a_language)
			cpp_set_language (self_ptr, Once_byte_vector.self_ptr)
		ensure
			set: language ~ a_language
		end

end