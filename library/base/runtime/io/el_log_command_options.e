note
	description: "Command line options for logging"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_LOG_COMMAND_OPTIONS

inherit
	EL_COMMAND_OPTIONS

feature -- Constants

	Keep_logs: STRING = "keep_logs"
		-- Do not delete logs

	Logging: STRING = "logging"
		-- turns on logging

	Thread_toolbar: STRING = "thread_toolbar"
		-- active console thread management toolbar

	No_highlighting: STRING = "no_highlighting"
		-- turns off logging color highlighting

end
