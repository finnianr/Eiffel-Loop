note
	description: "Command options"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:47 GMT (Saturday 19th May 2018)"
	revision: "5"

class
	EL_COMMAND_OPTIONS

feature -- Constants

	Ask_user_to_quit: STRING = "ask_user_to_quit"
		-- Prompt user to quit when sub-application finishes (EL_SUB_APPLICATION)

	Silent: STRING = "silent"

	No_app_header: STRING = "no_app_header"

	Help: STRING = "help"

	Install: STRING = "install"

end
