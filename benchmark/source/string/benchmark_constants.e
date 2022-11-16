note
	description: "Benchmark constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "2"

deferred class
	BENCHMARK_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	C_escape_table: HASH_TABLE [CHARACTER_32, CHARACTER_32]
		once
			create Result.make (7)
			Result ['n'] := '%N'
			Result ['r'] := '%R'
			Result ['t'] := '%T'

			Result ['N'] := '%N'
			Result ['R'] := '%R'
			Result ['T'] := '%T'
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

feature {NONE} -- Routine sets

	Character_pair_tests: EL_STRING_8_LIST
		once
			Result := "prune_all, last_index_of, index_of"
		end

	Substring_tests: EL_STRING_8_LIST
		once
			Result := "append_string, ends_with, insert_string, prepend_string, replace_substring_all,%
						%replace_substring, substring_index, starts_with, translate"
		end

	General_concat_tests: EL_STRING_8_LIST
		once
			Result := "append_string_general, prepend_string_general"
		end

end