note
	description: "Simple geometric fractal defined by Pyxis configuration file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-29 14:11:07 GMT (Wednesday 29th May 2019)"
	revision: "2"

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

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_required_argument ("config", "Configuration file path", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE
		do
			Result := agent {like command}.make (fractal_config)
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

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{FRACTAL_APP}, All_routines],
				[{FRACTAL_MAIN_WINDOW}, All_routines]
			>>
		end

end
