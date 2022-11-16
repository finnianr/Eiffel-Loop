note
	description: "[
		Matches quoted string with the characters **'** and **"** escaped by backslash.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 17:40:11 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_MATCH_BASIC_QUOTED_STRING_TP

inherit
	EL_MATCH_QUOTED_STRING_TP

	EL_TEXT_PATTERN_FACTORY

create
	make

feature -- Constants

	Language_name: STRING = ""

feature {NONE} -- Implementation

	new_escape_sequence: like all_of
		do
			Result := all_of (<<
				character_literal (Escape_character), one_character_from (new_escaped_set)
			>>)
		end

	new_escaped_set: STRING
		do
			create Result.make_filled (Escape_character.to_character_8, 2)
			Result [2] := quote.to_character_8
		end

	unescaped_code (text: READABLE_STRING_GENERAL; start_index, end_index, sequence_count: INTEGER): NATURAL
		do
			if sequence_count = 2 then
				Result := text [end_index].natural_32_code
			end
		end

feature {NONE} -- Constants

	Escape_character: CHARACTER_32 = '\'

end