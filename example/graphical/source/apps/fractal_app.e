note
	description: "Simple geometric fractal defined by Pyxis configuration file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "11"

class
	FRACTAL_APP

inherit
	EL_LOGGED_COMMAND_LINE_APPLICATION [FRACTAL_COMMAND]
		redefine
			Option_name
		end

	SHARED_FRACTAL_CONFIG

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := << config_argument (Void) >>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (fractal_config)
		end

	log_filter_set: EL_LOG_FILTER_SET [like Current, FRACTAL_MAIN_WINDOW]
		do
			create Result.make
		end

feature {NONE} -- Constants

	Option_name: STRING
		once
			Result := "fractal"
		end

end