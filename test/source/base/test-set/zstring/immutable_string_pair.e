note
	description: "[
		Same as [$source STRING_PAIR] but with shared immutable substrings
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-25 10:06:03 GMT (Saturday 25th February 2023)"
	revision: "17"

class
	IMMUTABLE_STRING_PAIR

inherit
	STRING_PAIR
		redefine
			s_8_substring, s_32_substring, set, set_substrings
		end

create
	default_create, make, make_filled

convert
	make ({STRING_32})

feature -- Strings

	s_32_substring: IMMUTABLE_STRING_32

	s_8_substring: detachable IMMUTABLE_STRING_8

	immutable_32: IMMUTABLE_STRING_32

	immutable_8: detachable IMMUTABLE_STRING_8

feature -- Element change

	set (str_32: STRING_32)
		do
			Precursor (str_32)
			immutable_32 := s_32

			if s_32.is_valid_as_string_8 then
				immutable_8 := s_32.to_string_8
			else
				immutable_8 := Void
			end
		end

	set_substrings (start_index, end_index: INTEGER)
		do
			s_32_substring := immutable_32.shared_substring (start_index, end_index)

			create zs_substring.make_from_string (immutable_32)

			if attached immutable_8 as str_8 then
				s_8_substring := str_8.shared_substring (start_index, end_index)
			else
				s_8_substring := Void
			end
		end

end