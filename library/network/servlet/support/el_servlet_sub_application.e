note
	description: "Summary description for {EL_SERVLET_SUB_APPLICATION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-17 17:09:30 GMT (Wednesday 17th September 2014)"
	revision: "6"

deferred class
	EL_SERVLET_SUB_APPLICATION [S -> EL_FAST_CGI_SERVLET_SERVICE create default_create end]

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [S]
		rename
			command as servlet_service
		redefine
			on_operating_system_signal
		end

feature {NONE} -- Implementation

	default_operands: TUPLE [config_dir: EL_DIR_PATH; config_name: ASTRING]
		do
			create Result
			Result.config_dir := Directory.user_configuration.joined_dir_path (new_option_name)
			Result.config_name := "config"
		end

	argument_specs: ARRAY [like Type_argument_specification]
		do
			Result := <<
				optional_argument ("config_dir", "Location of configuration file"),
				optional_argument ("config", "Name of configuration file")
			>>
		end

	on_operating_system_signal
			--
		do
			log_or_io.put_line ("Closing application")
		end

end
