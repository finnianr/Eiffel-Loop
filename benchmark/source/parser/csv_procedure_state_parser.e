note
	description: "CSV parser using agent states"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-06 10:45:53 GMT (Monday 6th February 2023)"
	revision: "1"

class
	CSV_PROCEDURE_STATE_PARSER

inherit
	CSV_STATE_PARSER [PROCEDURE]

create
	make

feature {NONE} -- Implementation

	frozen final (str: STRING; i: INTEGER; c: CHARACTER)
		do
		end

	call (str: STRING; i: INTEGER; c: CHARACTER)
		do
			state (str, i, c)
		end

	set_states
		do
			s_check_back_slash := agent check_back_slash
			s_check_escaped_quote := agent check_escaped_quote
			s_final := agent final
			s_find_comma := agent find_comma
			s_find_end_quote := agent find_end_quote
		end

end