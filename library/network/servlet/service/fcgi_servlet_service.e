note
	description: "[
		Fast-CGI service on a `port_number' that services HTTP requests forwarded by a web server
		from a table of servlets. The servlets are mapped to uri paths that are relative to the
		service path defined in the web server configuration. For example:
		
			/servlet/one
			/servlet/two
			/servlet/three
			
		The service path is "/servet" and the relative paths are "one", "two" and "three"
		
		The servlet service is configured by a file in Pyxis format.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-01-21 12:29:01 GMT (Sunday 21st January 2018)"
	revision: "8"

deferred class
	FCGI_SERVLET_SERVICE

inherit
	L4E_PRIORITY_CONSTANTS

	EL_MODULE_HTTP_STATUS

	EL_MODULE_LOG

	EL_MODULE_LOG_MANAGER

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_EXCEPTION

	EL_COMMAND

feature {EL_COMMAND_CLIENT} -- Initialization

	make (config_dir: EL_DIR_PATH; config_name: ZSTRING)
		do
			Servlet_app_log_category.wipe_out
			config := new_config (config_dir + (config_name + ".pyx"))
			create request.make
			create socket.make
			create servlets
			state := agent do_nothing
			initialize_logger
			server_backlog := 10
		end

feature -- Basic operations

	execute
		do
			log.enter ("execute")
			if config.is_valid then
				-- Call initialize here rather than in make so that a background thread will have it's own template copies
				-- stored in once per thread instance of EVOLICITY_TEMPLATES
				initialize_servlets
				lio.put_integer_field ("Listening on port", port_number)
				lio.put_new_line

				do_transitions
				if retries > Max_retries then
					error (Servlet_app_log_category, "Application ended because retries > Max_retries")
				end

				request.close; socket.close
				Log_hierarchy.close_all
				servlet_table.linear_representation.do_all (agent {FCGI_HTTP_SERVLET}.on_shutdown)
				on_shutdown
			else
				across config.error_messages as message loop
					lio.put_labeled_string ("Error " + message.cursor_index.out, message.item)
					lio.put_new_line
				end
			end
			log.exit
		end

feature -- Status change

	stop_service: BOOLEAN
			-- stop running the service
		do
			state := final
		end

feature -- Status query

	unable_to_listen: BOOLEAN
		-- True if the application is unable to listen on host_port

feature {NONE} -- States

	accepting_connection
		do
			socket.accept
			if attached {like socket} socket.accepted as connection_socket then
				-- accept new connection (blocking)
				state := agent reading_request (connection_socket)
			else
				state := agent opening_port
			end
		end

	finishing_request
			-- Finish the current request from the HTTP server. The
			-- current request was started by the most recent call to
			-- 'accept'.
		do
			if not request.is_closed then
				request.end_request
				-- Successfully finished responding to request so we can reset `retries' to zero
				retries := 0
			end
			state := agent accepting_connection
		rescue
			if Exception.received_broken_pipe_signal then
				request.close
				retry
			end
		end

	opening_port
			-- Set up port to listen for requests from the web server
		do
			unable_to_listen := False
			if not socket.is_closed then
				socket.close
			end
			unable_to_listen := True
			create socket.make_server_by_port (port_number)
			socket.listen (server_backlog)
			socket.set_blocking
--			Potentially this can be used to poll for application ending but has some problems
--			srv_socket.set_accept_timeout (500)

			state := agent accepting_connection
			retries := retries + 1
			unable_to_listen := False
		end

	processing_request
			-- Redefined process request to have type of response and request object defined in servlet
		local
			servlet_path: ZSTRING; found: BOOLEAN
		do
			if request.is_closed then
				state := agent accepting_connection
			else
				servlet_path := request.relative_path_info
				if servlet_path.is_empty then
					error (Servlet_app_log_category, "No path specified in HTTP header")
				else
					across << servlet_path, Default_servlet_key >> as path until found loop
						servlet_path := path.item
						servlets.search (servlet_path)
						found := servlets.found
					end
					if found then
						info (Servlet_app_log_category, Service_info_template #$ [servlet_path, servlets.found_item.servlet_info])
						servlets.found_item.serve_fast_cgi (request)
					else
						on_missing_servlet (create {FCGI_SERVLET_RESPONSE}.make (request))
					end
				end
				state := agent finishing_request
			end
		rescue
			if Exception.received_broken_pipe_signal then
				request.close
				retry
			end
		end

	reading_request (a_socket: like socket)
			-- Wait for a request to be received; Returns true if request was successfully read
		do
			request.set_socket (a_socket)
			request.read
			if request.is_aborted then
				state := agent accepting_connection

			elseif request.read_ok then
				if request.is_end_service then
					state := final
				else
					state := agent processing_request
				end
			else
				a_socket.close
				error (Servlet_app_log_category, "{FCGI_SERVLET_SERVICE}.reading_request failed")
				state := agent accepting_connection
			end
		end

feature {NONE} -- Event handling

	on_shutdown
		do
		end

	on_missing_servlet (resp: FCGI_SERVLET_RESPONSE)
			-- Send error page indicating missing servlet
		do
			resp.send_error (Http_status.not_found)
		end

feature {NONE} -- Implementation

	call (object: ANY)
		do
		end

	do_transitions
		-- iterate over state transitions
		do
			from state := agent opening_port until retries > Max_retries or state = Final loop
				state.apply
			end
		rescue
			if Exception.received_termination_signal then
				error (Servlet_app_log_category, "Received termination signal. Exiting..")
			else
				error (
					Servlet_app_log_category,
					"Uncaught exception, code: " + Exception.last_out + ", retry not requested, so exiting..."
				)
				write_exception_trace
			end
		end

	error (logger: STRING; message: ANY)
		do
			if Log_hierarchy.is_enabled_for (Error_p) then
				Log_hierarchy.logger (logger).error (message)
			end
			if attached {STRING} message as str then
				log_message (str)
			else
				log_message (message.out)
			end
		end

	info (logger: STRING; message: ANY)
		do
			if Log_hierarchy.is_enabled_for (Info_p) then
				Log_hierarchy.logger (logger).info (message)
			end
			if attached {READABLE_STRING_GENERAL} message as str then
				log_message (str)
			else
				log_message (message.out)
			end
		end

	initialize_logger
			-- Set logger appenders
		local
			appender: L4E_APPENDER; layout: L4E_LAYOUT; output_path: EL_FILE_PATH
		do
			output_path := Log_manager.output_directory_path + ("log" + port_number.out + ".txt")
			create {L4E_FILE_APPENDER} appender.make (output_path.to_string.to_string_8, True)
			create {L4E_PATTERN_LAYOUT} layout.make ("@d [@-6p] @c - @m%N")
			appender.set_layout (layout)
			log_hierarchy.logger (Servlet_app_log_category).add_appender (appender)
		end

	initialize_servlets
		-- initialize servlets
		do
			servlets := servlet_table
		end

	log_message (message: READABLE_STRING_GENERAL)
		local
			pos_colon: INTEGER
		do
			pos_colon := message.index_of (':', 1)
			if pos_colon > 0 then
				lio.put_labeled_string (message.substring (1, pos_colon - 1), message.substring (pos_colon + 2, message.count))
				lio.put_new_line
			else
				lio.put_line (message)
			end
		end

	new_config (file_path: EL_FILE_PATH): like config
		do
			create Result.make_from_file (file_path)
		end

	port_number: INTEGER
		-- The port to listen on.
		do
			Result := config.server_port
		end

	servlet_table: like servlets
		deferred
		end

	write_exception_trace
		local
			trace_path: EL_FILE_PATH; trace_file: EL_PLAIN_TEXT_FILE
		do
			trace_path := generator + "-exception.01.txt"
			create trace_file.make_open_write (trace_path.next_version_path)
			trace_file.put_string_32 (Exception.last_trace)
			trace_file.close
		end

feature {NONE} -- Implementation: attributes

	config: EL_SERVLET_SERVICE_CONFIG
			-- Configuration for servlets

	request: FCGI_REQUEST

	retries: INTEGER
		-- The number of times run has retried or called opening_port

	server_backlog: INTEGER
		-- The number of requests that can remain outstanding.

	servlets: EL_ZSTRING_HASH_TABLE [FCGI_HTTP_SERVLET]

	socket: EL_NETWORK_STREAM_SOCKET
		-- server socket

	state: PROCEDURE

feature {NONE} -- String constants

	Fcgi_web_server_addrs: STRING = "FCGI_WEB_SERVER_ADDRS"

	Final: PROCEDURE
		once
			Result := agent do_nothing
		end

	Service_info_template: ZSTRING
		once
			Result := "Servicing path: %"%S%" with servlet %S"
		end

	Servlet_app_log_category: STRING = "servlet.app"

	frozen Default_servlet_key: ZSTRING
		once
			Result := "<DEFAULT>"
		end

feature {NONE} -- Constants

	Log_hierarchy: L4E_HIERARCHY
			-- Shared logging hierarchy.
		once
			create Result.make (Info_p)
		end

	Max_retries: INTEGER
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

end
