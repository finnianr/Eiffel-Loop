note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-28 10:55:23 GMT (Sunday 28th July 2013)"
	revision: "3"

class
	EL_SOURCE_TEXT_PROCESSOR

inherit
	EL_FILE_PARSER
		rename
			make as make_parser,
			new_pattern as delimiting_pattern
		export
			{NONE} all
			{ANY} set_source_text, set_unmatched_text_action,
					 set_source_text_from_line_source, set_source_text_from_file, full_match_succeeded
		end

	EL_TEXTUAL_PATTERN_FACTORY
		export
			{NONE} all
		end

create
	make_with_delimiter

feature -- Access

	delimiting_pattern: EL_TEXTUAL_PATTERN

feature {NONE} -- Initialization

	make_with_delimiter (a_pattern: EL_TEXTUAL_PATTERN)

		do
			make_parser
			delimiting_pattern := a_pattern
		end

feature -- Basic operations

	do_all
		--
		require
			valid_delimiting_pattern: delimiting_pattern /= Void
		do
			find_all
			consume_events
		end

end -- class EL_SOURCE_TEXT_PROCESSOR
