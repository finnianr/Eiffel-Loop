note
	description: "Source text processor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:24:56 GMT (Monday 21st November 2022)"
	revision: "2"

class
	EL_SOURCE_TEXT_PROCESSOR

inherit
	EL_FILE_PARSER
		rename
			pattern as delimiting_pattern
		export
			{NONE} all
			{ANY} fully_matched,
				set_source_text, set_source_text_from_line_source, set_source_text_from_file,
				delimiting_pattern
		end

	TP_FACTORY
		export
			{NONE} all
		end

	EL_NEW_PATTERN_BY_AGENT
		rename
			make_with_agent as make_with_delimiter
		end

create
	make_with_delimiter

feature -- Basic operations

	do_all
		do
			find_all (Void)
		end

end