note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-01 12:36:50 GMT (Thursday 1st January 2015)"
	revision: "4"

deferred class
	EL_FILE_LEXER

inherit
	EL_FILE_PARSER
		rename
			find_all as do_lexing,
			consume_events as fill_tokens_text
		export
			{NONE} all
		end

feature {NONE} -- Initialization

	make (a_source_text: like source_text)
		do
			make_default
			source_text := a_source_text
			do_lexing
			create token_text_array.make (event_list.count)
			create tokens_text.make (event_list.count)
			fill_tokens_text
		end

feature -- Access

	tokens_text: STRING_32

	token_text_array: ARRAYED_LIST [EL_STRING_VIEW]

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
			token_text_array.extend (token_text)
--			log.exit
		end

	add_token_action (token_id: NATURAL_32): PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
			-- Action to add token_id to the list of parser tokens
			-- '?' reserves a place for the source text view that matched the token
		do
			Result := agent add_token (token_id, ?)
		end

end -- class EL_LEXER

