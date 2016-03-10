note
	description: "Summary description for {EL_COMMA_SEPARATED_PARSER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_COMMA_SEPARATED_LINE

inherit
	EL_CHARACTER_STATE_MACHINE [CHARACTER_8]

create
	make

feature {NONE} -- Initialization

	make (line: STRING)
		do
			create fields.make
			fields.extend (create {STRING}.make_empty)
			parse (agent find_comma, line)
		end

feature -- Access

	fields: LINKED_LIST [STRING]

feature {NONE} -- State handlers

	find_comma (character: CHARACTER)
			--
		do
			inspect character
				when ',' then
					fields.extend (create {STRING}.make_empty)

				when Double_quote then
					state := agent find_end_quote
			else
				fields.last.append_character (character)
			end
		end

	find_end_quote (character: CHARACTER)
			--
		do
			inspect character
				when Double_quote then
					state := agent check_escaped_quote

			else
				fields.last.append_character (character)
			end
		end

	check_escaped_quote (character: CHARACTER)
			-- check if last character was escape quote
		do
			inspect character
				when Double_quote then
					fields.last.append_character (character)
					state := agent find_end_quote

			else -- last quote was end quote
				state := agent find_comma
			end
		end

feature {NONE} -- Constants

	Double_quote: CHARACTER = '"'

end
