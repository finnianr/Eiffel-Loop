note
	description: "Server sub application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "18"

deferred class
	EROS_SERVER_APPLICATION [C -> EROS_SERVER_COMMAND [TUPLE] create make end]

inherit
	EL_LOGGED_COMMAND_LINE_APPLICATION [C]

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				optional_argument ("port", "Port number", No_checks)
			>>
		end

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent make_server (?, 8000)
		end

	make_server (a_command: like command; port: INTEGER)
		do
			a_command.make (port)
		end

	on_ctrl_c
			-- or other operating signal
		do
			log.put_new_line
			log.put_line ("Ctrl-C detected")
			log.put_line ("Disconnecting ..")
			command.clean_up
		end

end