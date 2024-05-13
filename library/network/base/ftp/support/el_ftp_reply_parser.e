note
	description: "Parses FTP protocol replies"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:29:58 GMT (Monday 21st November 2022)"
	revision: "7"

class
	EL_FTP_REPLY_PARSER

inherit
	EL_PARSER
		rename
			make_default as make,
			parse as parse_complete
		export
			{NONE} all
			{ANY} set_source_text
		redefine
			default_source_text
		end

	TP_FACTORY

create
	make

feature -- Access

	last_ftp_cmd_result: STRING

	last_reply_code: INTEGER

feature -- Basic operations

	parse
		do
			find_all (Void)
		end

feature {NONE} -- Event handling

	on_ftp_cmd_result (start_index, end_index: INTEGER)
			--
		do
			last_ftp_cmd_result := new_source_substring (start_index, end_index)
		end

	on_reply_code (start_index, end_index: INTEGER)
			--
		do
			last_reply_code := integer_32_substring (start_index, end_index)
		end

feature {NONE} -- Pattern

	double_quote: TP_LITERAL_CHAR
			--
		do
			create Result.make ('"')
		end

	new_pattern: like all_of
		-- reply pattern
		do
			Result := all_of (<<
				start_of_line,
				signed_integer |to| agent on_reply_code,
				optional (all_of (<< nonbreaking_white_space, quoted_string_pattern >> ))
			>>)
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

feature {NONE} -- Implementation

	default_source_text: STRING
		do
			Result := Empty_string_8
		end

end