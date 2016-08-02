note
	description: "Summary description for {EL_OS_COMMAND_OUTPUT_PARSER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 7:24:57 GMT (Wednesday 16th December 2015)"
	revision: "1"

deferred class
	EL_OS_COMMAND_OUTPUT_PARSER

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE

feature {EL_OS_COMMAND} -- Access

	initial_state: like state
		do
			Result := agent find_line
		end

feature -- Status change

	reset
		deferred
		end

feature {NONE} -- Line states

	find_line (line: ZSTRING)
		do
		end

end