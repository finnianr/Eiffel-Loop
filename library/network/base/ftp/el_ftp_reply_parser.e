note
	description: "Parses FTP protocol replies"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_FTP_REPLY_PARSER

inherit
	EL_SOURCE_TEXT_PROCESSOR

	EL_TEXT_PATTERN_FACTORY

create
	make

feature {NONE} -- Initialization

	make
		do
			make_with_delimiter (ftp_reply_pattern)
		end

feature -- Access

	last_ftp_cmd_result: STRING

	last_reply_code: INTEGER

feature {NONE} -- Event handling

	on_ftp_cmd_result (quoted_text: EL_STRING_VIEW)
			--
		do
			last_ftp_cmd_result := quoted_text
		end

	on_reply_code (reply_code_str: EL_STRING_VIEW)
			--
		do
			last_reply_code := reply_code_str.to_string_8.to_integer
		end

feature {NONE} -- Pattern

	double_quote: EL_LITERAL_CHAR_TP
			--
		do
			create Result.make ({ASCII}.Doublequote.to_natural_32)
		end

	ftp_reply_pattern: like all_of
			--
		do
			Result := all_of (<<
				start_of_line,
				integer |to| agent on_reply_code,
				optional (all_of (<< non_breaking_white_space, quoted_string_pattern >> ))
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

end