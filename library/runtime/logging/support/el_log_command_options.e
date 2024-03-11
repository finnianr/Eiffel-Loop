note
	description: "Command line options for logging"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-05 11:29:17 GMT (Tuesday 5th March 2024)"
	revision: "12"

class
	EL_LOG_COMMAND_OPTIONS

inherit
	EL_COMMAND_LINE_OPTIONS

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

	Name_logging: STRING
		once
			Result := field_name_for_address ($logging)
		end

	Name_thread_toolbar: STRING
		once
			Result := field_name_for_address ($thread_toolbar)
		end

feature {NONE} -- Constants

	Help_text: STRING = "[
		logging:
			Activate application logging to console
		keep_logs:
			Do not delete log files on program exit
		log_filters:
			Display class and routine filtering information for log output
		thread_toolbar:
			Activate thread management toolbar in GUI applications
	]"

end