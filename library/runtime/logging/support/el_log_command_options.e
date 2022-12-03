note
	description: "Command line options for logging"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-03 11:23:02 GMT (Saturday 3rd December 2022)"
	revision: "10"

class
	EL_LOG_COMMAND_OPTIONS

inherit
	EL_COMMAND_LINE_OPTIONS
		redefine
			Name
		end

create
	make, make_default

feature -- Access

	log_filters: BOOLEAN
		-- Display class and routine filtering information for log output

	keep_logs: BOOLEAN
		-- Do not delete logs

	logging: BOOLEAN
		-- turns on logging

	thread_toolbar: BOOLEAN
		-- active console thread management toolbar

feature -- Constants

	Name: TUPLE [logging, thread_toolbar: STRING]
		once
			create Result
			Tuple.fill (Result, "logging, thread_toolbar")
		end

feature {NONE} -- Constants

	Help_text: STRING = "[
		logging:
			Activate application logging to console
		keep_logs:
			Do not delete log file on program exit
		log_filters:
			Display class and routine filtering information for log output
		thread_toolbar:
			Activate thread management toolbar in GUI applications
	]"

end