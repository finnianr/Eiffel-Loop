note
	description: "Command line options for logging"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-13 17:47:54 GMT (Monday 13th January 2020)"
	revision: "7"

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

	keep_logs: BOOLEAN
		-- Do not delete logs

	logging: BOOLEAN
		-- turns on logging

	thread_toolbar: BOOLEAN
		-- active console thread management toolbar

feature {NONE} -- Implementation

	new_default: like Current
		do
			create Result.make_default
		end

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
		thread_toolbar:
			Activate thread management toolbar in GUI applications
	]"

end
