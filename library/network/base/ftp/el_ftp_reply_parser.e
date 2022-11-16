note
	description: "Parses FTP protocol replies"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-16 16:56:33 GMT (Wednesday 16th November 2022)"
	revision: "4"

class
	EL_FTP_REPLY_PARSER

inherit
	EL_SOURCE_TEXT_PROCESSOR
		redefine
			source_text
		end

	EL_TEXT_PATTERN_FACTORY

create
	make

feature {NONE} -- Initialization

	make
		do
			create source_text.make_empty
			set_optimal_core (source_text)
			make_with_delimiter (agent ftp_reply_pattern)
		end

feature -- Access

	last_ftp_cmd_result: STRING

	last_reply_code: INTEGER

feature {NONE} -- Event handling

	on_ftp_cmd_result (start_index, end_index: INTEGER)
			--
		do
			last_ftp_cmd_result := source_substring (start_index, end_index, True)
		end

	on_reply_code (start_index, end_index: INTEGER)
			--
		do
			last_reply_code := source_substring (start_index, end_index, False).to_integer
		end

feature {NONE} -- Pattern

	double_quote: EL_LITERAL_CHAR_TP
			--
		do
			create Result.make ('"')
		end

	ftp_reply_pattern: like all_of
			--
		do
			Result := all_of (<<
				start_of_line,
				signed_integer |to| agent on_reply_code,
				optional (all_of (<< nonbreaking_white_space, quoted_string_pattern >> ))
			>> )
		end

	quoted_string_pattern: like all_of
			-- Quoted string with embedded double-quotes escaped by double-quotes
		do
			Result := all_of (<<
				double_quote,
				zero_or_more (
					one_of ( << string_literal ("%"%""), not double_quote >> )
				) |to| agent on_ftp_cmd_result,

				double_quote
			>> )
		end

feature {NONE} -- Internal attributes

	source_text: STRING
end