note
	description: "Summary description for {EL_SERVLET_SUB_APPLICATION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-30 20:03:50 GMT (Monday 30th October 2017)"
	revision: "5"

deferred class
	FCGI_SERVICE_SUB_APPLICATION [S -> FCGI_SERVLET_SERVICE]

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [S]
		rename
			command as servlet_service
		redefine
			on_operating_system_signal
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				optional_argument ("config_dir", "Location of configuration file"),
				optional_argument ("config", "Name of configuration file")
			>>
		end

	default_make: PROCEDURE
		do
			Result := agent {FCGI_SERVLET_SERVICE}.make (Default_config_dir, Default_config_name)
		end

	on_operating_system_signal
			--
		do
			lio.put_line ("Closing application")
		end

feature {NONE} -- Constants

	Default_config_dir: EL_DIR_PATH
		once
			Result := Directory.user_configuration.joined_dir_path (new_option_name)
		end

	Default_config_name: ZSTRING
		once
			Result := "config"
		end

	Serve_fast_cgi: STRING = "serve_fast_cgi"
end
