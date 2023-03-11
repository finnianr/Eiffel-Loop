note
	description: "Benchmark constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-10 10:10:54 GMT (Friday 10th March 2023)"
	revision: "6"

deferred class
	BENCHMARK_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	C_escape_table: EL_ESCAPE_TABLE
		once
			create Result.make (Back_slash, "\:=\, n:=%N, r:=%R, t:=%T, N:=%N, R:=%R, T:=%T")
		end

	Back_slash: CHARACTER = '\'

	Pinyin_u: CHARACTER_32 = 'ū'

	Escaped: STRING = "escaped"

	Ogham_padding: STRING_32
		once
			create Result.make_filled ((1680).to_character_32, 5)
		end

	Padded: STRING = "padded"

	Put_amp: STRING = "put_amp"

	Space_padding: STRING_32
		once
			create Result.make_filled (' ', 5)
		end

	Space: STRING = " "

feature {NONE} -- Routine sets

	Character_pair_tests: EL_STRING_8_LIST
		once
			Result := "prune_all, last_index_of, index_of"
		end

	Substring_tests: EL_STRING_8_LIST
		once
			Result := "append_string, insert_string, prepend_string, replace_substring_all,%
						%replace_substring, starts_with, translate"
		end

	Search_string_tests: EL_STRING_8_LIST
		once
			Result := "ends_with, substring_index"
		end

	General_concat_tests: EL_STRING_8_LIST
		once
			Result := "append_string_general, prepend_string_general"
		end

end