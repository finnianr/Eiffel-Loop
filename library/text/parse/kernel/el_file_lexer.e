note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-21 11:19:16 GMT (Thursday 21st January 2016)"
	revision: "5"

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

	EL_MODULE_LOG

feature {NONE} -- Initialization

	make (a_source_text: like source_text)
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
--			log.enter ("consume_events")
			if log.current_routine_is_active then
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
--			log.exit
		end

	add_token (token_value: NATURAL_32; token_text: EL_STRING_VIEW)
			--
		do
--			log.enter_with_args ("add_token", << token_text >>)
			tokens_text.append_code (token_value)
			token_text_array.extend (token_text.interval)
--			log.exit
		end

	add_token_action (token_id: NATURAL_32): like default_action
			-- Action to add token_id to the list of parser tokens
			-- '?' reserves a place for the source text view that matched the token
		do
			Result := agent add_token (token_id, ?)
		end

end

