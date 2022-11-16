note
	description: "File lexer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "8"

deferred class
	EL_FILE_LEXER

inherit
	EL_FILE_PARSER
		rename
			find_all as fill_tokens_text
		export
			{NONE} all
			{EL_TOKEN_PARSER} source_view
		redefine
			make_default
		end

	EL_EIFFEL_TEXT_PATTERN_FACTORY

feature {NONE} -- Initialization

	make (a_source_text: READABLE_STRING_GENERAL)
		do
			make_default
			set_source_text (a_source_text)
			fill_tokens_text
		end

	make_default
		do
			Precursor
			create token_text_array.make (10)
			create tokens_text.make (10)
		end

feature -- Access

	tokens_text: STRING_32

	token_text_array: ARRAYED_LIST [INTEGER_64]

feature {NONE} -- Implementation

	debug_consume_events
		-- Turn on trace
		do
			debug ("EL_FILE_LEXER")
				from
					token_text_array.start
				until
					token_text_array.after
				loop
--					log.put_integer_field ("TOKEN", token_source_text.code (token_text_array.index).to_integer_32)
--					log.put_string (" is %"")
--					log.put_string (token_text_array.item.out)
--					log.put_string ("%"")
--					log.put_new_line
					token_text_array.forth
				end
			end
		end

	add_token (token_value: NATURAL_32; token_text: EL_STRING_VIEW)
			--
		do
			tokens_text.append_code (token_value)
			token_text_array.extend (token_text.interval)
		end

	add_token_action (token_id: NATURAL_32): like default_action
		-- Action to add token_id to the list of parser tokens
		-- '?' reserves a place for the source text view that matched the token
		do
			Result := agent add_token (token_id, ?)
		end

	text_token (word: STRING; id: NATURAL): like string_literal
		do
			Result := string_literal (word) |to| add_token_action (id)
		end

end