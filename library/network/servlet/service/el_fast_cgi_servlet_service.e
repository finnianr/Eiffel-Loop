note
	description: "Summary description for {EL_FAST_CGI_SERVLET_SERVICE_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-29 14:03:42 GMT (Monday 29th September 2014)"
	revision: "5"

deferred class
	EL_FAST_CGI_SERVLET_SERVICE

inherit
	GOA_FAST_CGI_SERVLET_APP
		rename
			make as make_servlet_app,
			log as goa_log,
			request as fast_cgi_request,
			Execution_environment as goa_execution_environment,
			run as execute,
			register_servlets as set_servlets
		redefine
			fast_cgi_request, process_request, execute, initialise_logger, error, info, Log_hierarchy
		end

	EL_MODULE_LOG

	EL_MODULE_LOG_MANAGER

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_COMMAND

feature {EL_SERVLET_SUB_APPLICATION} -- Initialization

	make (config_dir: EL_DIR_PATH; config_name: ASTRING)
		do
			Servlet_app_log_category.wipe_out
			config := new_config (config_dir + (config_name + ".pyx"))
			make_servlet_app ("localhost", config.server_port, 10)
		end

feature -- Basic operations

	execute
		do
			log.enter ("execute")
			if config.is_valid then
				-- Call initialize here rather than in make so that a background thread will have it's own template copies
				-- stored in once per thread instance of EVOLICITY_TEMPLATES
				initialize
				log_or_io.put_integer_field ("Listening on port", svr_port)
				log_or_io.put_new_line

				Precursor
				on_shutdown
			else
				across config.error_messages as message loop
					log_or_io.put_labeled_string ("Error " + message.cursor_index.out, message.item)
					log_or_io.put_new_line
				end
			end
			log.exit
		end

feature {NONE} -- Implementation

	call (object: ANY)
		do
		end

	initialize
		do
			set_servlets
		end

	process_request
			-- Redefined process request to have type of response and request object defined in servlet
		local
			servlet_path: ASTRING; found: BOOLEAN
		do
			servlet_path := fast_cgi_request.path_info
			if servlet_path.is_empty then
				error (Servlet_app_log_category, "No path specified in HTTP header")
			else
				across << servlet_path, Default_servlet_key >> as path until found loop
					servlet_path := path.item
					servlets.search (servlet_path)
					found := servlets.found
				end
				if found then
					Service_info_template.set_variables_from_array (<<
						[once "path", servlet_path], [once "servlet_class", servlets.found_item.generator]
					>>)
					info (Servlet_app_log_category, Service_info_template.substituted)
					servlets.found_item.serve_fast_cgi (fast_cgi_request)
				else
					handle_missing_servlet (create {GOA_FAST_CGI_SERVLET_RESPONSE}.make (fast_cgi_request))
				end
			end
		end

	set_servlets
			-- assign servlets
		do
			servlets := servlet_table
		end

	initialise_logger
			-- Set logger appenders
		local
			appender: L4E_APPENDER; layout: L4E_LAYOUT; output_path: EL_FILE_PATH
		do
			output_path := Log_manager.output_directory_path + ("log" + svr_port.out + ".txt")
			create {L4E_FILE_APPENDER} appender.make (output_path.to_string.to_string_8, True)
			create {L4E_PATTERN_LAYOUT} layout.make ("@d [@-6p] @c - @m%N")
			appender.set_layout (layout)
			log_hierarchy.logger (Servlet_app_log_category).add_appender (appender)
		end

	error (logger: STRING; message: ANY)
		do
			Precursor (logger, message)
			if attached {STRING} message as str then
				log_message (str)
			else
				log_message (message.out)
			end
		end

	info (logger: STRING; message: ANY)
		do
			Precursor (logger, message)
			if attached {READABLE_STRING_GENERAL} message as str then
				log_message (str)
			else
				log_message (message.out)
			end
		end

	log_message (message: READABLE_STRING_GENERAL)
		local
			pos_colon: INTEGER
		do
			pos_colon := message.index_of (':', 1)
			if pos_colon > 0 then
				log_or_io.put_labeled_string (
					message.substring (1, pos_colon - 1), message.substring (pos_colon + 2, message.count)
				)
				log_or_io.put_new_line
			else
				log_or_io.put_line (message)
			end
		end

	new_config (file_path: EL_FILE_PATH): like config
		do
			create Result.make_from_file (file_path)
		end

	on_shutdown
		do
			Log_hierarchy.close_all
		end

	field_exception: BOOLEAN
			-- Should we attempt to retry?
		do
		end

	servlet_table: like servlets
		deferred
		end

feature {NONE} -- Implementation: attributes

	servlets: EL_ASTRING_HASH_TABLE [EL_HTTP_SERVLET]

	config: EL_SERVLET_CONFIG
			-- Configuration for servlets

	fast_cgi_request: EL_FAST_CGI_REQUEST

feature {NONE} -- Constants

	Log_hierarchy: L4E_HIERARCHY
			-- Shared logging hierarchy.
		once
			create Result.make (Info_p)
		end

	frozen Default_servlet_key: ASTRING
		once
			Result := "<DEFAULT>"
		end

	Service_info_template: EL_SUBSTITUTION_TEMPLATE [ASTRING]
		once
			create Result.make ("Servicing path: %"$path%" with servlet $servlet_class")
		end
end
