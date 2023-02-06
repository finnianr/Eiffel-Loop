note
	description: "CSV parser for lines encoded as Latin-1"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-06 10:47:30 GMT (Monday 6th February 2023)"
	revision: "5"

class
	CSV_POINTER_STATE_PARSER

inherit
	CSV_STATE_PARSER [POINTER]

create
	make

feature {NONE} -- Implementation

	call (str: STRING; i: INTEGER; c: CHARACTER)
		local
			s: like state
		do
			s := state
			if s = $check_back_slash then
				check_back_slash (str, i, c)

			elseif s = $check_escaped_quote then
				check_escaped_quote (str, i, c)

			elseif s = $find_comma then
				find_comma (str, i, c)

			elseif s = $find_end_quote then
				find_end_quote (str, i, c)
			end
		end

	set_states
		do
			s_check_back_slash := $check_back_slash
			s_check_escaped_quote := $check_escaped_quote
			s_final := default_pointer
			s_find_comma := $find_comma
			s_find_end_quote := $find_end_quote
		end

end