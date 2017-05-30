note
	description: "Summary description for {EL_SERVLET_SUB_APPLICATION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-29 23:24:52 GMT (Monday 29th May 2017)"
	revision: "2"

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

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				optional_argument ("config_dir", "Location of configuration file"),
				optional_argument ("config", "Name of configuration file")
			>>
		end

	default_operands: TUPLE [config_dir: EL_DIR_PATH; config_name: ZSTRING]
		do
			create Result
			Result.config_dir := Directory.user_configuration.joined_dir_path (new_option_name)
			Result.config_name := "config"
		end

	on_operating_system_signal
			--
		do
			lio.put_line ("Closing application")
		end

feature {NONE} -- Constants

	Serve_fast_cgi: STRING = "serve_fast_cgi"
end
