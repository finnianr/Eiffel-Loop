note
	description: "Server sub application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-06 16:43:09 GMT (Sunday 6th February 2022)"
	revision: "16"

deferred class
	EROS_SERVER_APPLICATION

inherit
	EL_LOGGED_APPLICATION
		rename
			on_operating_system_signal as on_ctrl_c
		redefine
			on_ctrl_c
		end

	EROS_SERVER_COMMAND
		rename
			execute as run,
			done as exit_signal_received,
			make as make_server
		undefine
			description
		end

feature {NONE} -- Initialization

	initialize
		do
			make_server (8000)
		end

feature {NONE} -- Implementation

	on_ctrl_c
			-- or other operating signal
		do
			log.put_new_line
			log.put_line ("Ctrl-C detected")
			log.put_line ("Disconnecting ..")
			if attached {EL_STREAM_SOCKET} socket.accepted as client then
				client.cleanup
			end
			socket.cleanup
--			no_message_on_failure
		end

end