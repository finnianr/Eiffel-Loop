note
	description: "Summary description for {EL_OS_COMMAND_OUTPUT_PARSER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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

	find_line (line: ASTRING)
		do
		end

end
