note
	description: "[
		Interface to the Flash GUI. Listens for user commands on a network socket
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_FLASH_REMOTE_UI_EVENT_LISTENER

inherit
	EL_IDENTIFIED_THREAD
		rename
			exit as thread_exit
		redefine
			execute
		end

	EXECUTION_ENVIRONMENT
		rename
			launch as launch_program,
			sleep as program_sleep
		export
			{NONE} all
		undefine
			is_equal, copy
		end

	EL_MODULE_LOG_MANAGER
		undefine
			is_equal, copy
		end

	EL_MODULE_LOG
		undefine
			is_equal, copy
		end

	ASCII
		undefine
			is_equal, copy
		end

feature -- Initialization

	make (port_num: INTEGER)
			--
		do
			make_stoppable
			create listen_socket.make_server_by_port (port_num)

			create command_actions.make (Num_commands)
			create ok_to_close_connection.make
			create close_connection_mutex
			command_actions.put (agent on_close, Cmd_close)

		end

feature -- Basic operations

	execute
			-- Flash command loop interaction
		do
			log_manager.add_visible_thread (Current, generating_type.as_lower)
			log.enter ("execute")

			listen_socket.listen (1)

			if is_auto_launched then
				launch_program (Flash_GUI_prog_name)
			end

			listen_socket.accept

			cmd_socket := listen_socket.accepted

			log.put_line ("Command socket accepted")

			from until is_stopping loop
				read_command
				command_actions.search (last_command)
				if command_actions.found then
					command_actions.found_item.call ([])
				end
			end

			close_connection_mutex.lock

			log.put_string ("Waiting for signal to finish")
			log.put_new_line
			ok_to_close_connection.wait (close_connection_mutex)
					-- Wait here until signaled that it is OK to close
					-- (Last few messages have to be sent to Flash client first)

			close_connection_mutex.unlock

			cmd_socket.close
			listen_socket.cleanup
			log.exit
			set_stopped
		end

feature {NONE} -- Command actions

	on_close
			--
		do
			set_stopping
		end

feature -- Access

	ok_to_close_connection: CONDITION_VARIABLE

feature -- Status query

	is_auto_launched: BOOLEAN
			-- Is the Flash display executable automatically launched
			-- (The alternative is to manually launch it from the Flash development IDE)

		deferred
		end

feature {NONE} -- Implementation

	listen_socket, cmd_socket: NETWORK_STREAM_SOCKET

	command_actions: HASH_TABLE [PROCEDURE [EL_FLASH_REMOTE_UI_EVENT_LISTENER, TUPLE], STRING]

	last_command: STRING

	close_connection_mutex: MUTEX

	read_command
			--
		do
			cmd_socket.read_stream (Max_command_length)
			last_command := cmd_socket.last_string
			last_command.prune_all_trailing (Nul.to_character)
			if last_command.count = 0 then
				-- If this happens user has most likely hit Alt-F4 or Ctrl-W
				-- so issue application close command
				last_command := Cmd_close
			end
			log.put_string_field ("Received command", last_command)
			log.put_new_line
		end

feature {NONE} -- Constants

	Cmd_close: STRING = "close"

	Max_command_length: INTEGER = 64

	Num_commands: INTEGER
			--
		once
			Result := 7
		end

	Flash_GUI_prog_name: STRING
			-- Command name to launch Flash GUI application
		deferred
		end

end











