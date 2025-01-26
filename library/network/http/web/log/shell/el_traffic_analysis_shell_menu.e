note
	description: "Command shell for selecting log file analysis report"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-26 18:12:26 GMT (Sunday 26th January 2025)"
	revision: "16"

class
	EL_TRAFFIC_ANALYSIS_SHELL_MENU

inherit
	EL_APPLICATION_COMMAND_SHELL
		rename
			make as make_shell
		end

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_config_path: FILE_PATH)
		do
			config_path := a_config_path
			make_shell ("LOG FILE ANALYSIS REPORTS", 10)
		end

feature -- Constants

	Description: STRING = "Command shell for selecting log file analysis report"

feature {NONE} -- Commands

	geographic_analysis
		local
			shell: EL_LOG_ANALYSIS_COMMAND_SHELL [EL_GEOGRAPHIC_ANALYSIS_COMMAND]
		do
			create shell.make ("GEOGRAPHIC REPORT BY MONTH", config_path)
			shell.run_command_loop
		end

	status_404_analysis
		local
			shell: EL_LOG_ANALYSIS_COMMAND_SHELL [EL_404_GEOGRAPHIC_ANALYSIS_COMMAND]
		do
			create shell.make ("PAGES NOT FOUND REPORT", config_path)
			shell.run_command_loop
		end

feature {NONE} -- Factory

	new_command_table: like command_table
		do
			create Result.make_assignments (<<
				["Visitor geographic location by month", agent geographic_analysis],
				["Summary report of bad visitors",		  agent status_404_analysis]
			>>)
		end

feature {NONE} -- Internal attributes

	config_path: FILE_PATH

end