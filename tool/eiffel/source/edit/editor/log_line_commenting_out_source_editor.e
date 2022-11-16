note
	description: "[
		Objects that comments out and comments in 'log.xxx' lines
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-16 16:02:14 GMT (Wednesday 16th November 2022)"
	revision: "9"

class
	LOG_LINE_COMMENTING_OUT_SOURCE_EDITOR

inherit
	EL_PATTERN_SEARCHING_EIFFEL_SOURCE_EDITOR

	EL_MODULE_LIO

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

	search_patterns: ARRAYED_LIST [EL_TEXT_PATTERN_2]
		do
			create Result.make_from_array (<<
				end_of_line_character	|to| agent on_unmatched_text,
				logging_statement			|to| agent on_logging_statement
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
				optional_nonbreaking_white_space,
				one_of (<<
					string_literal ("log."),
					string_literal ("log_or_io.")
				>>),
				identifier,
				all_of (<< optional_white_space, bracketed_expression >>) #occurs (0 |..| 1)
			>> )
		end

	redirect_thread_to_console_command: like all_of
			--
		do
			Result := all_of ( <<
				optional_nonbreaking_white_space,
				string_literal ("redirect_thread_to_console"),
				optional_nonbreaking_white_space,
				all_of (<<
					character_literal ('('),
					decimal_constant,
					character_literal (')')
				>>)
			>> )
		end

feature {NONE} -- Parsing actions

	on_logging_statement (start_index, end_index: INTEGER)
			--
		do
			string_tokenizer_by_new_line.set_from_string (source_substring (start_index, end_index, True))
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
		end

feature {NONE} -- Implementation

	string_tokenizer_by_new_line: EL_PATTERN_SPLIT_STRING_LIST

	string_tokenizer_by_eiffel_comment_marker: EL_PATTERN_SPLIT_STRING_LIST

end