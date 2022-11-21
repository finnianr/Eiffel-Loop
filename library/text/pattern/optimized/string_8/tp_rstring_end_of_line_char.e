note
	description: "[
		[$source TP_END_OF_LINE_CHAR] optimized for string conforming to [$source READABLE_STRING_8]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:24:58 GMT (Monday 21st November 2022)"
	revision: "4"

class
	TP_RSTRING_END_OF_LINE_CHAR

inherit
	TP_END_OF_LINE_CHAR
		undefine
			i_th_matches, make_with_character
		end

	TP_RSTRING_LITERAL_CHAR
		rename
			make as make_with_character,
			make_with_action as make_literal_with_action
		undefine
			match_count, meets_definition, name_inserts, Name_template
		end

create
	make

end

