note
	description: "Summary description for {EL_COMMA_SEPARATED_PARSER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-14 10:43:32 GMT (Wednesday 14th January 2015)"
	revision: "3"

class
	EL_COMMA_SEPARATED_LINE

inherit
	EL_CHARACTER_STATE_MACHINE [CHARACTER_8]
		rename
			make as make_machine
		end

create
	make

feature {NONE} -- Initialization

	make (line: STRING)
		do
			make_machine
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
