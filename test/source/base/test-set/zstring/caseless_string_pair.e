note
	description: "[
		[$source STRING_PAIR] for testing **same_caseless_characters**
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-16 16:44:56 GMT (Thursday 16th February 2023)"
	revision: "12"

class
	CASELESS_STRING_PAIR

inherit
	STRING_PAIR
		rename
			same_characters as same_caseless_characters
	 	redefine
	 		same_caseless_characters
	 	end

create
	default_create, make, make_filled

convert
	make ({STRING_32})

feature -- Test comparisons

	same_caseless_characters (index: INTEGER): BOOLEAN
		local
			s_32_upper, s_32_substring_upper: STRING_32; zs_upper, zs_substring_upper: ZSTRING
			s_8_upper: STRING; result_array: ARRAYED_LIST [BOOLEAN]
		do
			s_32_upper := s_32.as_upper; zs_upper := zs.as_upper
			s_32_substring_upper := s_32_substring.as_upper
			zs_substring_upper := s_32_substring_upper

			create result_array.make_from_array (<<
				s_32_upper.same_caseless_characters (s_32_substring, 1, s_32_substring.count, index),
				zs_upper.same_caseless_characters (s_32_substring, 1, s_32_substring.count, index),
				zs_upper.same_caseless_characters (zs_substring, 1, zs_substring.count, index),
--				Reversed
				s_32.same_caseless_characters (s_32_substring_upper, 1, s_32_substring.count, index),
				zs.same_caseless_characters (s_32_substring_upper, 1, s_32_substring.count, index),
				zs.same_caseless_characters (zs_substring_upper, 1, zs_substring.count, index)
			>>)
			if attached s_8_substring as s_8 then
				result_array.extend (zs_upper.same_caseless_characters_general (s_8, 1, s_8.count, index))
				result_array.extend (zs.same_caseless_characters_general (s_8.as_upper, 1, s_8.count, index))
			end
			Result := not result_array.has (False)
		end

end