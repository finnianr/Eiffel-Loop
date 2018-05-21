note
	description: "Source text processor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:04 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_SOURCE_TEXT_PROCESSOR

inherit
	EL_FILE_PARSER
		rename
			new_pattern as delimiting_pattern,
			pattern as delimiting_pattern,
			find_all as do_all
		export
			{NONE} all
			{ANY} do_all, fully_matched,
				set_source_text, set_unmatched_action, set_source_text_from_line_source, set_source_text_from_file,
				delimiting_pattern
		end

	EL_ZTEXT_PATTERN_FACTORY
		export
			{NONE} all
		end

create
	make_with_delimiter

feature {NONE} -- Initialization

	make_with_delimiter (a_pattern: EL_TEXT_PATTERN)

		do
			make_default
			delimiting_pattern := a_pattern
		end

end