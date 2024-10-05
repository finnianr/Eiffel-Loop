note

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-04 12:14:07 GMT (Friday 4th October 2024)"
	revision: "15"

class
	ZSTRING_SAME_CHARACTERS_COMPARISON

inherit
	STRING_BENCHMARK_COMPARISON

	EL_SHARED_ZSTRING_CODEC

create
	make

feature -- Access

	Description: STRING = "ZSTRING.same_characters variations"

feature -- Basic operations

	execute
		local
			str, end_string: ZSTRING; start_pos, end_pos: INTEGER
		do
			str := Text.cyrillic_line
			start_pos :=  str.index_of (str [1], 2)
			end_pos := str.count
			end_string := str.substring_end (start_pos)

			same_characters_zstring (str, end_string, start_pos, end_pos)
			same_characters_zstring_1 (str, end_string, start_pos, end_pos)
			same_characters_zstring_2 (str, end_string, start_pos, end_pos)

			compare ("compare append character", <<
				["same_characters_zstring", 	agent same_characters_zstring (str, end_string, start_pos, end_pos)],
				["same_characters_zstring_1", agent same_characters_zstring_1 (str, end_string, start_pos, end_pos)],
				["same_characters_zstring_2", agent same_characters_zstring_2 (str, end_string, start_pos, end_pos)]
			>>)
		end

feature {NONE} -- append_character

	same_characters_zstring (str, end_string: ZSTRING; start_pos, end_pos: INTEGER)

		do
--			if end_string.same_characters_zstring (str, start_pos, end_pos, 1) then
--				do_nothing
--			end
		end

	same_characters_zstring_1 (str, end_string: ZSTRING; start_pos, end_pos: INTEGER)

		do
--			if end_string.same_characters_zstring_1 (str, start_pos, end_pos, 1) then
--				do_nothing
--			end
		end

	same_characters_zstring_2 (str, end_string: ZSTRING; start_pos, end_pos: INTEGER)

		do
--			if end_string.same_characters_zstring_2 (str, start_pos, end_pos, 1) then
--				do_nothing
--			end
		end
end