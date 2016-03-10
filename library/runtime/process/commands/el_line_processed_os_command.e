note
	description: "Summary description for {EL_LINE_PROCESSED_OS_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 7:09:02 GMT (Wednesday 16th December 2015)"
	revision: "6"

deferred class
	EL_LINE_PROCESSED_OS_COMMAND

inherit
	EL_GENERAL_OS_COMMAND
		rename
			do_with_lines as do_with_output_lines
		redefine
			make_default, line_processing_enabled, do_command, do_with_output_lines
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		export
			{NONE} all
		end

feature {NONE} -- Initialization

	make_default
		do
			make_machine
			Precursor
		end

feature -- Status query

	line_processing_enabled: BOOLEAN
			--
		do
			Result := True
		end

feature -- Status change

	reset
		deferred
		end

feature {NONE} -- Line states

	initial_state: like state
		do
			Result := agent find_line
		end

	find_line (line: ZSTRING)
		do
		end

feature {NONE} -- Implementation

	do_command (a_system_command: like system_command)
		do
			reset
			Precursor (a_system_command)
		end

	do_with_output_lines (lines: EL_FILE_LINE_SOURCE)
		do
			do_once_with_file_lines (initial_state, lines)
		end

end
