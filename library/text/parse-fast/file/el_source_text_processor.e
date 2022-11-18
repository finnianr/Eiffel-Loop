note
	description: "Source text processor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-18 7:20:17 GMT (Friday 18th November 2022)"
	revision: "10"

class
	EL_SOURCE_TEXT_PROCESSOR

inherit
	EL_FILE_PARSER
		rename
			find_all as do_all,
			pattern as delimiting_pattern
		export
			{NONE} all
			{ANY} do_all, fully_matched,
				set_source_text, set_source_text_from_line_source, set_source_text_from_file,
				delimiting_pattern
		end

	EL_TEXT_PATTERN_FACTORY
		export
			{NONE} all
		end

create
	make_with_delimiter

feature {NONE} -- Initialization

	make_with_delimiter (delimiting_pattern_agent: FUNCTION [EL_TEXT_PATTERN])

		do
			make_default
			new_delimiting_pattern := delimiting_pattern_agent
		end

feature {NONE} -- Implementation

	new_pattern: EL_TEXT_PATTERN
		do
			new_delimiting_pattern.apply
			Result := new_delimiting_pattern.last_result
		end

feature {NONE} -- Internal attributes

	new_delimiting_pattern: FUNCTION [EL_TEXT_PATTERN]

end