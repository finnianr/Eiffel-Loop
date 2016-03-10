note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_FILE_TRAILING_SPACE_REMOVER

inherit
	EL_TEXT_FILE_EDITOR
		export
			{NONE} set_input_file_path
		end

	EL_TEXTUAL_PATTERN_FACTORY

create
	make

feature {NONE} -- Pattern definitions

	delimiting_pattern: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := repeat_pattern_1_until_pattern_2 (
				character_literal ('%/32/'), end_of_line_character
			) |to| agent on_trailing_space
		end

feature {NONE} -- Parsing actions

	on_trailing_space (class_name: EL_STRING_VIEW)
			-- Ignore trailing space
		do
			put_new_line
		end

end
