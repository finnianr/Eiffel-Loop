note
	description: "Comments id3 frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-27 10:45:26 GMT (Sunday 27th April 2025)"
	revision: "13"

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

	EL_CHARACTER_8_SETS; EL_SET [CHARACTER]
		rename
			has as not_a_to_z_caseless
		end

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
			Result := Once_byte_vector.to_string_8
		-- Filter anything that is not in set 'a' .. 'z', 'A' .. 'Z'
		-- (weird characters found in test files)
			super_8 (Result).prune_set_members (Current) -- not_a_to_z_caseless
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