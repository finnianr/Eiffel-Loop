note
	description: "Simple server"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-10 14:31:16 GMT (Monday 10th July 2023)"
	revision: "12"

class
	EL_SIMPLE_SERVER [H -> EL_SERVER_COMMAND_HANDLER create make end]

inherit
	ANY

	EL_MODULE_LIO

create
	make_local

feature {NONE} -- Initialization

	make_local (a_port: INTEGER)
		do
			create socket.make_server_by_port (a_port)
		end

feature -- Basic operations

	do_service_loop
			-- serve one client until quite received
		local
			handler: H; done: BOOLEAN; pos_space: INTEGER; command, message: STRING
		do
			socket.listen (1)
			if is_lio_enabled then
				lio.put_line ("Waiting for connection..")
			end
			socket.accept
			if attached {EL_STREAM_SOCKET} socket.accepted as client then
				if is_lio_enabled then
					lio.put_labeled_string ("connection", "accepted")
				end
				from until done loop
					client.set_latin_encoding (1)
					create handler.make (client)
					client.read_line
					message := client.last_string (False)
					if message ~ "quit" then
						done := True
					else
						pos_space := message.index_of (' ', 1)
						if pos_space > 0 then
							command := message.substring (1, pos_space - 1)
							handler.execute (command, message.substring (pos_space + 1, message.count))
						else
							handler.execute (message, "")
						end
					end
				end
				client.close
			else
				if is_lio_enabled then
					lio.put_labeled_string ("connection", "not accepted")
				end
			end
			socket.cleanup
		end

feature {NONE} -- Implementation

	socket: EL_NETWORK_STREAM_SOCKET

end