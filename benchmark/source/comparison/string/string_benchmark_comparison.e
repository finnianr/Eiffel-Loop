note
	description: "String benchmark comparison"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-30 7:52:14 GMT (Thursday 30th November 2023)"
	revision: "11"

deferred class
	STRING_BENCHMARK_COMPARISON

inherit
	EL_BENCHMARK_COMPARISON

	EL_SHARED_TEST_TEXT

	SHARED_HEXAGRAM_STRINGS

	EL_ZCODE_CONVERSION

	EL_STRING_8_CONSTANTS

	STRING_HANDLER

feature {NONE} -- Constants

	Hanzi_strings: ARRAY [ZSTRING]
		local
			names: HEXAGRAM_NAMES
		once
			Result := << names.i_th_combined (1), names.i_th_combined (2) >>
			across Result as list loop
				list.item.keep_tail (3)
			end
		end

	Hanzi_strings_32: ARRAY [STRING_32]
		once
			Result := << Hanzi_strings [1], Hanzi_strings [1] >>
		end

	Hexagram_1_title_list: EL_STRING_32_LIST
		local
			names: HEXAGRAM_NAMES
		once
			if attached Hexagram.Hexagram_1_array as a then
				create Result.make_from_general (<< a [1], a [4], names.i_th_combined (1) >>)
			end
		end

	Hexagram_1_title: STRING_32
		-- Hex. #1 - The Creative, Creating, Pure Yang, Inspiring Force, Dragon - Qián (屯)
		once
			Result := Hexagram_1_title_list.joined_with_string (" - ")
		end

end