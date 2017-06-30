note
	description: "[
		Objects that comments out and comments in 'log.xxx' lines
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-29 11:22:47 GMT (Thursday 29th June 2017)"
	revision: "3"

class
	LOG_LINE_COMMENTING_OUT_SOURCE_EDITOR

inherit
	EL_PATTERN_SEARCHING_EIFFEL_SOURCE_EDITOR

	EL_MODULE_LOG

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_default
			create string_tokenizer_by_new_line.make ("%N")
			create string_tokenizer_by_eiffel_comment_marker.make_with_delimiter (comment_prefix)
		end

feature {NONE} -- Pattern definitions

	search_patterns: ARRAYED_LIST [EL_TEXT_PATTERN]
		do
			create Result.make_from_array (<<
				end_of_line_character |to| agent on_unmatched_text,
				logging_statement  |to| agent on_logging_statement
			>>)
		end

	logging_statement: like one_of
			--
		do
			Result := one_of (<< logging_command, redirect_thread_to_console_command >>)
		end

	logging_command: like all_of
			--
		do
			Result := all_of ( <<
				maybe_non_breaking_white_space,
				one_of (<<
					string_literal ("log."),
					string_literal ("log_or_io.")
				>>),
				identifier,
				all_of (<< maybe_white_space, bracketed_expression >>) #occurs (0 |..| 1)
			>> )
		end

	redirect_thread_to_console_command: like all_of
			--
		do
			Result := all_of ( <<
				maybe_non_breaking_white_space,
				string_literal ("redirect_thread_to_console"),
				maybe_non_breaking_white_space,
				all_of (<<
					character_literal ('('),
					numeric_constant,
					character_literal (')')
				>>)
			>> )
		end

feature {NONE} -- Parsing actions

	on_logging_statement (text: EL_STRING_VIEW)
			--
		do
			log.enter_with_args ("on_logging_statement", <<text>>)
			string_tokenizer_by_new_line.set_from_string (text)
			from
				string_tokenizer_by_new_line.start
			until
				string_tokenizer_by_new_line.off
			loop
				put_string ("--")
				put_string (string_tokenizer_by_new_line.item)
				string_tokenizer_by_new_line.forth
				if not string_tokenizer_by_new_line.off then
					put_new_line
				end
			end
			log.exit
		end

feature {NONE} -- Implementation

	string_tokenizer_by_new_line: EL_SPLIT_STRING_LIST

	string_tokenizer_by_eiffel_comment_marker: EL_SPLIT_STRING_LIST

end
