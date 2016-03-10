note
	description: "Summary description for {EL_FAST_CGI_SERVLET_SERVICE_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-22 17:07:09 GMT (Saturday 22nd June 2013)"
	revision: "3"

deferred class
	EL_FAST_CGI_SERVLET_SERVICE

inherit
	GOA_FAST_CGI_SERVLET_APP
		rename
			make as make_servlet_app,
			log as goa_log,
			Execution_environment as goa_execution_environment,
			run as execute
		redefine
			execute
		end

	EL_MODULE_LOG

	EL_COMMAND

feature {EL_SERVLET_SUB_APPLICATION} -- Initialization

	make (a_config_file_path: EL_FILE_PATH)
		do
			log_hierarchy.disable_all
			create config.make_from_file (a_config_file_path)
			make_servlet_app ("localhost", config.server_port, 10)
			register_servlets
		end

feature -- Basic operations

	execute
		do
			log.enter ("execute")
			if config.is_valid then
				log_or_io.put_integer_field ("Listening on port", svr_port)
				log_or_io.put_new_line

				Precursor
				on_shutdown
			else
				log_or_io.put_string_field ("Error", "Invalid configuration")
				log_or_io.put_new_line
			end
			log.exit
		end

feature {NONE} -- Implementation

	register_servlets
			-- Initialise servlets
		do
			-- register servlets
			servlet_manager.set_config (config)
			servlets := servlet_table
			across servlets as servlet loop
				servlet_manager.register_servlet (servlet.item, servlet.key.to_utf8)
				if servlet.key = default_servlet_name then
					servlet_manager.register_default_servlet (servlet.item)
				end
			end
		end

	on_shutdown
		do
		end

	field_exception: BOOLEAN
			-- Should we attempt to retry?
		do
		end

	servlet_table: like servlets
		deferred
		end

	default_servlet_name: STRING
		deferred
		end

	servlets: EL_ASTRING_HASH_TABLE [EL_HTTP_SERVLET]

	config: EL_SERVLET_CONFIG
			-- Configuration for servlets

end
