note
	description: "Command options"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-25 15:45:00 GMT (Wednesday 25th September 2019)"
	revision: "4"

class
	COMMAND_OPTIONS

inherit
	EL_COMMAND_OPTIONS

feature -- Access

	File_placeholder: STRING = "%%f"

	Config: STRING = "config"

	Main: STRING = "main"

	Options_list: ARRAY [STRING]
		once
			Result := << Silent, Config, File_placeholder >>
		end

end
