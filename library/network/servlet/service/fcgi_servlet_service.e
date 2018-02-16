note
	description: "[
		Fast-CGI service that services HTTP requests forwarded by a web server from a table of servlets.
		The service is configured from a Pyxis format configuration file and listens either on a port number
		or a Unix socket for request from the web server.
	]"
	notes: "See end of page"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-09 15:17:02 GMT (Friday 9th February 2018)"
	revision: "9"

deferred class
	FCGI_SERVLET_SERVICE

inherit
	L4E_PRIORITY_CONSTANTS

	EL_MODULE_HTTP_STATUS

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LOG

	EL_MODULE_LOG_MANAGER

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_EXCEPTION

	EL_COMMAND

feature {EL_COMMAND_CLIENT} -- Initialization

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

	initialize_logger
			-- Set logger appenders
		local
			appender: L4E_APPENDER; layout: L4E_LAYOUT; output_path: EL_FILE_PATH
		do
			output_path := Log_manager.output_directory_path + ("log" + config.server_port.out + ".txt")
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

	make (config_dir: EL_DIR_PATH; config_name: ZSTRING)
		do
			Servlet_app_log_category.wipe_out
			config := new_config (config_dir + (config_name + ".pyx"))
			create broker.make
			create {EL_NETWORK_STREAM_SOCKET} socket.make
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
				-- Call initialize here rather than in `make' so that a background thread will have it's
				-- own template copies stored in once per thread instance of EVOLICITY_TEMPLATES
				initialize_servlets; initialize_listening

				if unable_to_listen then
					log_servlet_error ("Application unable to listen")
				else
					do_transitions

					broker.close
					Log_hierarchy.close_all
					servlets.linear_representation.do_all (agent {FCGI_HTTP_SERVLET}.on_shutdown)
					on_shutdown
				end
				socket.close
				if attached {EL_UNIX_STREAM_SOCKET} socket then
					File_system.remove_file (config.server_socket_path)
				end
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

	processing_request
			-- Redefined process request to have type of response and request object defined in servlet
		local
			servlet_path: ZSTRING; found: BOOLEAN
		do
			servlet_path := broker.relative_path_info
			if servlet_path.is_empty then
				log_servlet_error ("No path specified in HTTP header")
			else
				across << servlet_path, Default_servlet_key >> as path until found loop
					servlet_path := path.item
					servlets.search (servlet_path)
					found := servlets.found
				end
				if found then
					log_servlet_info (Service_info_template #$ [servlet_path, servlets.found_item.servlet_info])
					servlets.found_item.serve_fast_cgi (broker)
				else
					on_missing_servlet (create {FCGI_SERVLET_RESPONSE}.make (broker))
				end
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
					state := agent processing_request
				end
			else
				a_socket.close
				log_servlet_error ("{FCGI_SERVLET_SERVICE}.reading_request failed")
				state := agent accepting_connection
			end
		end

feature {NONE} -- Event handling

	on_missing_servlet (resp: FCGI_SERVLET_RESPONSE)
			-- Send error page indicating missing servlet
		do
			resp.send_error (Http_status.not_found)
		end

	on_shutdown
		do
		end

feature {NONE} -- Implementation

	call (object: ANY)
		do
		end

	do_transitions
		-- iterate over state transitions
		do
			if state /= Final then
				from state := agent accepting_connection until state = Final loop
					state.apply
				end
			end
		rescue
			if Exception.received_broken_pipe_signal then
				broker.close
				log_servlet_error ("Broken pipe exception")
				retry

			elseif Exception.received_termination_signal then
				log_servlet_error (" Ctrl-C detected, shutting down ..")
				state := Final
				retry
			else
				log_servlet_error ("Exiting after unrescueable exception: " + Exception.last_out)
				Exception.write_last_trace (Current)
			end
		end

	log_error (logger: STRING; message: ANY)
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

	log_info (logger: STRING; message: ANY)
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

	log_message (message: READABLE_STRING_GENERAL)
		local
			pos_colon: INTEGER; label: READABLE_STRING_GENERAL
		do
			pos_colon := message.index_of (':', 1)
			if pos_colon > 0 then
				label := message.substring (1, pos_colon - 1)
				lio.put_labeled_string (label, message.substring (pos_colon + 2, message.count))
				lio.put_new_line
			else
				lio.put_line (message)
			end
		end

	log_servlet_error (message: ANY)
		do
			log_error (Servlet_app_log_category, message)
		end

	log_servlet_info (message: ANY)
		do
			log_info (Servlet_app_log_category, message)
		end

	new_config (file_path: EL_FILE_PATH): like config
		do
			create Result.make_from_file (file_path)
		end

	servlet_table: like servlets
		deferred
		end

feature {NONE} -- Implementation: attributes

	broker: FCGI_REQUEST_BROKER
		-- broker to read and write request messages from the web server

	config: EL_SERVLET_SERVICE_CONFIG
			-- Configuration for servlets

	server_backlog: INTEGER
		-- The number of requests that can remain outstanding.

	servlets: EL_ZSTRING_HASH_TABLE [FCGI_HTTP_SERVLET]

	socket: EL_STREAM_SOCKET
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
