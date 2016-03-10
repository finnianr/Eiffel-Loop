note
	description: "Summary description for {EL_SERVLET_SUB_APPLICATION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-11-20 13:07:22 GMT (Wednesday 20th November 2013)"
	revision: "4"

deferred class
	EL_SERVLET_SUB_APPLICATION [S -> EL_FAST_CGI_SERVLET_SERVICE create default_create end]

inherit
	EL_COMMAND_LINE_SUB_APPLICATTION [S]
		rename
			command as servlet_service_command
		redefine
			on_operating_system_signal
		end

feature {NONE} -- Implementation

	default_operands: TUPLE [config_file_path: EL_FILE_PATH]
		do
			create Result
			Result.config_file_path := ""
		end

	argument_specs: ARRAY [like Type_argument_specification]
		do
			Result := <<
				required_existing_path_argument ("config", "Path to configuration file")
			>>
		end

	on_operating_system_signal
			--
		do
			log_or_io.put_line ("Closing application")
		end

end
