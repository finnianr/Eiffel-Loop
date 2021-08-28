note
	description: "[
		Fast-CGI service that services HTTP requests forwarded by a web server from a table of servlets.
		The service is configured from a Pyxis format configuration file and listens either on a port number
		or a Unix socket for request from the web server.
	]"
	notes: "See end of page"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-28 16:27:17 GMT (Saturday 28th August 2021)"
	revision: "20"

deferred class
	FCGI_SERVLET_SERVICE

inherit
	EL_COMMAND

	EL_SHARED_HTTP_STATUS

	EL_MODULE_DIRECTORY

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LOG

	EL_MODULE_LOG_MANAGER

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_EXCEPTION

	EL_MODULE_UNIX_SIGNALS

	EL_STRING_8_CONSTANTS

	EL_SHARED_DOCUMENT_TYPES

	EL_SHARED_OPERATING_ENVIRON

feature {EL_COMMAND_CLIENT} -- Initialization

	make (config_path: EL_FILE_PATH)
		require
			configuration_exists: config_path.exists
		do
			make_with_config (new_config (config_path))
		end

	make_default
		do
			create broker.make
			create {EL_NETWORK_STREAM_SOCKET} socket.make
			create servlet_table
			state := agent do_nothing
			server_backlog := 10
		end

	make_port (a_port: INTEGER)
		do
			make_with_config (create {like config}.make ("", a_port))
		end

	make_with_config (a_config: like config)
		do
			make_default
			config := a_config
			if not config.unix_socket_exists then
				create_server_socket_dir
			end
		end

feature {NONE} -- Initialization

	initialize_listening
			-- Set up port to listen for requests from the web server
		local
			retry_count: INTEGER
		do
			unable_to_listen := True
			retry_count := retry_count + 1

			socket := config.new_socket
			socket.listen (server_backlog)
			socket.set_blocking

			lio.put_labeled_string ("Listening on", socket.description)
			lio.put_new_line

--			Potentially this can be used to poll for application ending but has some problems
--			srv_socket.set_accept_timeout (500)
			unable_to_listen := False
		rescue
			if not socket.is_closed then
				socket.close
			end
			if retry_count <= Max_initialization_retry_count then
				Execution_environment.sleep (1000) -- Wait a second
				retry
			end
		end

	initialize_servlets
		-- initialize servlets
		deferred
		end

feature -- Access

	config: FCGI_SERVICE_CONFIG
			-- Configuration for servlets

feature -- Basic operations

	execute
		do
			log.enter ("execute")
			config.check_validity
			if config.is_valid then
				-- Call initialize here rather than in `make' so that a background thread will have it's
				-- own template copies stored in once per thread instance of EVOLICITY_TEMPLATES
				log.enter ("initialize_servlets")
					initialize_servlets
				log.exit
				initialize_listening

				if unable_to_listen then
					log_error (Empty_string_8, "Application unable to listen")
				else
					do_transitions

					broker.close
					across servlet_table as servlet loop
						servlet.item.on_shutdown
					end
					on_shutdown
				end
				socket.close
			else
				across config.error_messages as message loop
					log_error ("Configuration error " + message.cursor_index.out, message.item)
				end
			end
			log.exit
		end

feature -- Status change

	stop_service: BOOLEAN
			-- stop running the service
		do
			state := Final
		end

feature -- Status query

	unable_to_listen: BOOLEAN
		-- True if the application is unable to listen on host_port

feature {NONE} -- States

	accepting_connection
		do
			socket.accept
			if attached {EL_STREAM_SOCKET} socket.accepted as connection_socket then
				-- accept new connection (blocking)
				state := agent reading_request (connection_socket)
			end
		end

	finishing_request
			-- Finish the current request from the HTTP server. The
			-- current request was started by the most recent call to
			-- 'accept'.
		do
			broker.end_request
			state := agent accepting_connection
		end

	processing_request (table: like servlet_table)
			-- Redefined process request to have type of response and request object defined in servlet
		do
			table.search (broker.relative_path_info)
			if not table.found then
				table.search (Default_servlet_key)
			end
			if table.found then
				log_message (
					once "Servicing path", Service_info_template #$ [broker.relative_path_info, table.found_item.servlet_info]
				)
				table.found_item.serve_request
			else
				on_missing_servlet (create {FCGI_SERVLET_RESPONSE}.make (broker))
			end
			state := agent finishing_request
		end

	reading_request (a_socket: EL_STREAM_SOCKET)
			-- Wait for a request to be received; Returns true if request was successfully read
		do
			broker.set_socket (a_socket)
			broker.read
			if broker.is_aborted then
				state := agent accepting_connection

			elseif broker.read_ok then
				if broker.is_end_service then
					state := Final
				else
					state := agent processing_request (servlet_table)
				end
			else
				a_socket.close
				log_error ("routine reading_request", "failed")
				state := agent accepting_connection
			end
		end

feature {NONE} -- Event handling

	on_missing_servlet (resp: FCGI_SERVLET_RESPONSE)
			-- Send error page indicating missing servlet
		do
			resp.send_error (Http_status.not_found, "Resource not found", Doc_type_html_utf_8)
		end

	on_shutdown
		do
		end

feature {NONE} -- Implementation

	call (object: ANY)
		do
		end

	create_server_socket_dir
		local
			make_dir_cmd: EL_OS_COMMAND; var: TUPLE [socket_dir, user: STRING]
			socket_dir: EL_DIR_PATH
		do
			socket_dir := config.server_socket_path.parent
			create var
			create make_dir_cmd.make ("sudo mkdir $SOCKET_DIR; sudo chown $USER:www-data $SOCKET_DIR")
			make_dir_cmd.fill_variables (var)
			make_dir_cmd.put_path (Var.socket_dir, socket_dir)
			make_dir_cmd.put_string (Var.user, Operating_environ.user_name)

			log.put_path_field ("Creating Unix socket", socket_dir)
			log.put_new_line
			make_dir_cmd.execute
			log.put_new_line
		end

	do_transitions
		-- iterate over state transitions
		local
			except: EXCEPTION; signal: INTEGER
		do
			if state /= Final then
				from state := agent accepting_connection until state = Final loop
					state.apply
				end
			end
		rescue
			except := Exception.last_exception.cause -- `cause' gets cause of ROUTINE_FAILURE

			if attached {OPERATING_SYSTEM_SIGNAL_FAILURE} except as os then
				signal := os.signal_code
			elseif attached {IO_FAILURE} except then
				-- arrives here in workbench mode
				if broker.is_pipe_broken then
					signal := Unix_signals.broken_pipe
				end
			end
			if Unix_signals.is_termination (signal) then
				log_message (except.generator, except.description)
				log_message ("Ctrl-C detected", "shutting down ..")
				state := Final
				retry
			elseif signal = Unix_signals.broken_pipe then
				broker.close
				log_message (except.generator, Unix_signals.broken_pipe_message)
				retry
			else
				log_message ("Exiting after unrescueable exception", except.generator)
				Exception.write_last_trace (Current)
			end
		end

	log_error (label, message: READABLE_STRING_GENERAL)
		do
			log_message ("ERROR", generator)
			log_message (label, message)
		end

	log_message (label, message: READABLE_STRING_GENERAL)
		do
			if not label.is_empty then
				lio.put_labeled_string (label, message)
				lio.put_new_line
			else
				lio.put_line (message)
			end
		end

	new_config (file_path: EL_FILE_PATH): like config
		do
			create Result.make_from_file (file_path)
		end

feature {FCGI_HTTP_SERVLET, FCGI_SERVLET_REQUEST} -- Access

	broker: FCGI_REQUEST_BROKER
		-- broker to read and write request messages from the web server

feature {NONE} -- Implementation: attributes

	server_backlog: INTEGER
		-- The number of requests that can remain outstanding.

	servlet_table: EL_ZSTRING_HASH_TABLE [FCGI_HTTP_SERVLET]

	socket: EL_STREAM_SOCKET
		-- server socket

	state: PROCEDURE

feature {NONE} -- String constants

	frozen Default_servlet_key: ZSTRING
		once
			Result := "<DEFAULT>"
		end

	Fcgi_web_server_addrs: STRING = "FCGI_WEB_SERVER_ADDRS"

	Final: PROCEDURE
		once
			Result := agent do_nothing
		end

	Service_info_template: ZSTRING
		once
			Result := "[
				"#" with servlet #
			]"
		end

	Servlet_app_log_category: STRING = "servlet.app"

feature {NONE} -- Constants

	Max_initialization_retry_count: INTEGER
		-- The maximum number of times application will retry
		once
			Result := 3
		end

	Valid_peer_addresses: EL_ZSTRING_LIST
		-- Peer addresses that are allowed to connect to this server as defined
		-- in environment variable FCGI_WEB_SERVER_ADDRS.
		-- (not currently used)
		once
			create Result.make_with_separator (Execution_environment.item (Fcgi_web_server_addrs), ';', True)
			Result.right_adjust
		end

note
	notes: "[
		**Origins**

		This FastCGI implementation evolved from the one found in the Goanna library as a radical
		refactoring and redesign. There is almost nothing left of the old Goanna implementation except
		perhaps for the use of the L4E logging system. It uses EiffelNet sockets in preference to Eposix.

		**Servlet Mapping**

		The servlets are mapped to uri paths that are relative to the service path defined in the
		web server configuration. For example:

			/servlet/one
			/servlet/two
			/servlet/three

		The service path is "/servet" and the relative paths are "one", "two" and "three"

		The servlet service is configured by a file in Pyxis format.

		**Logging**

		Logging uses both the Eiffel-Loop system and the L4E system which it inherits from the Goanna
		predecessor to this library.

		**Testing**
		
		This and related classes have been tested in production with the
		[http://cherokee-project.com/ Cherokee Webserver]
	]"

end