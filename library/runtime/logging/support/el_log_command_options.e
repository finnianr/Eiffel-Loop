note
	description: "Command line options for logging"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
