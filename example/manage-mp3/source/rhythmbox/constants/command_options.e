note
	description: "Command options"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2019 Finnian Reilly"
	contact: "finnian at hex11software dot com"

	license: "All rights reserved"
	date: "2019-07-03 8:45:33 GMT (Wednesday 3rd July 2019)"
	revision: "3"

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
