note
	description: "File lexer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-16 17:07:16 GMT (Sunday 16th July 2023)"
	revision: "13"

deferred class
	EL_FILE_LEXER

inherit
	EL_FILE_PARSER
		export
			{NONE} all
			{EL_TOKEN_PARSER} source_text
		redefine
			make_default
		end

	TP_SHARED_OPTIMIZED_FACTORY

feature {NONE} -- Initialization

	make (a_source_text: READABLE_STRING_GENERAL)
		local
			s: EL_ZSTRING_ROUTINES
		do
			make_default
			set_source_text (s.as_zstring (a_source_text))
			fill_tokens_text
		end

	make_default
		do
			Precursor
			create source_interval_list.make (10)
			create tokens_text.make (10)
		end

feature -- Access

	source_interval_list: EL_ARRAYED_INTERVAL_LIST
		-- substring intervals for source text

	tokens_text: STRING_32

feature -- Basic operations

	fill_tokens_text
		do
			find_all (Void)
		end

feature {NONE} -- Implementation

	add_token (token_value: NATURAL_32; start_index, end_index: INTEGER)
			--
		do
			tokens_text.append_code (token_value)
			source_interval_list.extend (start_index, end_index)
		end

	add_token_action (token_id: NATURAL_32): like PARSE_ACTION
		-- Action to add token_id to the list of parser tokens
		-- '?' reserves a place for the source text view that matched the token
		do
			Result := agent add_token (token_id, ?, ?)
		end

	debug_consume_events
		-- Turn on trace
		do
			debug ("EL_FILE_LEXER")
				from
					source_interval_list.start
				until
					source_interval_list.after
				loop
--					log.put_integer_field ("TOKEN", token_source_text.code (token_text_array.index).to_integer_32)
--					log.put_string (" is %"")
--					log.put_string (token_text_array.item.out)
--					log.put_string ("%"")
--					log.put_new_line
					source_interval_list.forth
				end
			end
		end

	text_token (word: STRING; id: NATURAL): TP_LITERAL_PATTERN
		do
			Result := core.new_string_literal (word) |to| add_token_action (id)
		end

	token: EL_ENUMERATION_NATURAL_32
		deferred
		end

	token_name (token_value: NATURAL): IMMUTABLE_STRING_8
		do
			Result := token.name (token_value)
		end

end