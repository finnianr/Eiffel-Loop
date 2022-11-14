note
	description: "Matches end of line for [$source ZSTRING] text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-14 8:22:10 GMT (Monday 14th November 2022)"
	revision: "1"

class
	EL_ZSTRING_END_OF_LINE_CHAR_TP

inherit
	EL_END_OF_LINE_CHAR_TP
		undefine
			i_th_matches, make_with_character
		end

	EL_ZSTRING_LITERAL_CHAR_TP
		rename
			make as make_with_character,
			make_with_action as make_literal_with_action
		undefine
			match_count, meets_definition, name_inserts, Name_template
		end

create
	make

end