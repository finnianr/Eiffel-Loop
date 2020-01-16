note
	description: "Server command handler"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-16 11:16:10 GMT (Thursday 16th January 2020)"
	revision: "8"

deferred class
	EL_SERVER_COMMAND_HANDLER

feature {NONE} -- Initialization

	make (a_socket: like socket)
		do
			socket := a_socket
			response := Response_ok
			command_table := new_command_table
		end

feature -- Access

	response: STRING

feature -- Basic operations

	execute (command, a_arguments: STRING)
		do
			if command_table.has_key (command) then
				command_table.found_item (a_arguments)
			end
		end

feature {NONE} -- Implementation

	command_table: EL_HASH_TABLE [PROCEDURE [STRING], STRING]

	new_command_table: like command_table
		deferred
		end

feature {NONE} -- Internal attributes

	socket: EL_STREAM_SOCKET

feature {EL_SIMPLE_SERVER} -- Constants

	Response_ok: STRING = "ok"

end
