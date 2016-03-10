note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-03-11 13:54:30 GMT (Wednesday 11th March 2015)"
	revision: "7"

deferred class
	EL_TOKEN_PARSER  [L -> EL_FILE_LEXER create make end]

inherit
	EL_FILE_PARSER
		rename
			source_text as tokens_text
		redefine
			make_default, set_source_text
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			create {STRING} source_text.make_empty
			create token_text_array.make (0)
		end

feature -- Access

	source_text: READABLE_STRING_GENERAL

feature -- Element change

	set_source_text (a_source_text: like source_text)
		local
			lexer: L
		do
			Precursor (a_source_text)
			source_text := tokens_text
			create lexer.make (source_text)
			tokens_text := lexer.tokens_text
			token_text_array := lexer.token_text_array
		end

feature {NONE} -- Implementation

	source_text_for_token (i: INTEGER; matched_tokens: EL_STRING_VIEW): ASTRING
			-- source text corresponding to i'th token in matched_tokens
		require
			valid_index: i >= 1 and i <= matched_tokens.count
			valid_token_text_array_index: matched_tokens.item_absolute_pos (i) <= token_text_array.count
		do
			Result := token_text_array @ matched_tokens.item_absolute_pos (i)
		end

	token_text_array: ARRAYED_LIST [EL_STRING_VIEW]

end -- class EL_TOKEN_PARSER
