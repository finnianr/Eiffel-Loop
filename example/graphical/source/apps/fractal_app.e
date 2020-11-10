note
	description: "Simple geometric fractal defined by Pyxis configuration file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-10 10:16:22 GMT (Tuesday 10th November 2020)"
	revision: "6"

class
	FRACTAL_APP

inherit
	EL_LOGGED_COMMAND_LINE_SUB_APPLICATION [FRACTAL_COMMAND]
		redefine
			Option_name
		end

	SHARED_FRACTAL_CONFIG

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("config", "Configuration file path", << file_must_exist >>)
			>>
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

	Description: STRING
		once
			Result := "Simple geometric fractal defined by Pyxis configuration file"
		end

end