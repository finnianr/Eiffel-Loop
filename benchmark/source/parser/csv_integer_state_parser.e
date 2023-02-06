note
	description: "CSV parser for lines encoded as Latin-1"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-06 10:48:05 GMT (Monday 6th February 2023)"
	revision: "5"

class
	CSV_INTEGER_STATE_PARSER

inherit
	CSV_STATE_PARSER [INTEGER]

create
	make

feature {NONE} -- Implementation

	call (str: STRING; i: INTEGER; c: CHARACTER)
		do
			inspect state
				when State_check_back_slash then
					check_back_slash (str, i, c)

				when State_check_escaped_quote then
					check_escaped_quote (str, i, c)

				when State_find_comma then
					find_comma (str, i, c)

				when State_find_end_quote then
					find_end_quote (str, i, c)
			else
			end
		end

	set_states
		do
			s_check_back_slash := State_check_back_slash
			s_check_escaped_quote := State_check_escaped_quote
			s_final := State_final
			s_find_comma := State_find_comma
			s_find_end_quote := State_find_end_quote
		end

feature {NONE} -- States

	State_check_escaped_quote: INTEGER = 1

	State_check_back_slash: INTEGER = 2

	State_find_comma: INTEGER = 3

	State_find_end_quote: INTEGER = 4

	State_final: INTEGER = 0

end