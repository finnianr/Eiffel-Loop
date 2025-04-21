note
	description: "Token parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-20 6:09:00 GMT (Sunday 20th April 2025)"
	revision: "20"

deferred class
	EL_TOKEN_PARSER  [L -> EL_FILE_LEXER create make end]

inherit
	EL_PARSER_32
		rename
			source_text as tokens_text,
			set_source_text as set_tokens_text,
			default_source_text as default_tokens_text
		export
			{NONE} all
			{ANY} parse
		redefine
			make_default
		end

	EL_FILE_SOURCE_TEXT
		redefine
			make_default, set_source_text
		end

	EL_TOKEN_TEXT_I
		export
			{NONE} all
		end

	EL_STRING_GENERAL_ROUTINES_I

	EL_STRING_32_CONSTANTS

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor {EL_PARSER_32}
			Precursor {EL_FILE_SOURCE_TEXT}
			create source_interval_list.make (0)
		end

feature -- Element change

	set_source_text_general (a_source_text: READABLE_STRING_GENERAL)
		do
			set_source_text (as_zstring (a_source_text))
		end

	set_source_text (a_source_text: ZSTRING)
		local
			lexer: L
		do
			source_text := a_source_text
			create lexer.make (a_source_text)
			source_interval_list := lexer.source_interval_list
			set_tokens_text (lexer.tokens_text)
		end

feature {NONE} -- Implementation

	keyword, symbol (a_token_id: NATURAL_32): TP_LITERAL_CHAR
		do
			Result := core.new_character_literal (a_token_id.to_character_32)
		end

feature {NONE} -- Internal attributes

	source_interval_list: EL_ARRAYED_INTERVAL_LIST
		-- substring intervals for `source_text'

end