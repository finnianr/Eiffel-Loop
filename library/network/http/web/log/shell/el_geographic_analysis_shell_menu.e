note
	description: "Shell to select log file for runnning ${EL_GEOGRAPHIC_ANALYSIS_COMMAND}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-24 11:32:24 GMT (Friday 24th January 2025)"
	revision: "2"

class
	EL_GEOGRAPHIC_ANALYSIS_SHELL_MENU

inherit
	EL_LOG_ANALYSIS_COMMAND_SHELL

create
	make

feature {NONE} -- Implementation

	 new_parser_command: EL_GEOGRAPHIC_ANALYSIS_COMMAND
		do
			create Result.make (config)
		end

	title: STRING
		do
			Result := "GEOGRAPHIC REPORT BY MONTH"
		end

end