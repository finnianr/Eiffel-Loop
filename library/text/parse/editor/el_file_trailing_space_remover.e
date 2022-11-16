note
	description: "File trailing space remover"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EL_FILE_TRAILING_SPACE_REMOVER

inherit
	EL_FILE_PARSER_TEXT_EDITOR
		rename
			make_default as make
		export
			{NONE} set_file_path
		end

	EL_TEXT_PATTERN_FACTORY

create
	make

feature {NONE} -- Pattern definitions

	delimiting_pattern: like repeat_p1_until_p2
			--
		do
			Result := repeat_p1_until_p2 (character_literal ('%/32/'), end_of_line_character) |to| agent on_trailing_space
		end

feature {NONE} -- Parsing actions

	on_trailing_space (class_name: EL_STRING_VIEW)
			-- Ignore trailing space
		do
			put_new_line
		end

end