note
	description: "Command shell for selecting log file analysis report"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-28 8:13:07 GMT (Tuesday 28th January 2025)"
	revision: "18"

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

	selected_geographic
		local
			shell: EL_LOG_ANALYSIS_COMMAND_SHELL [EL_GEOGRAPHIC_ANALYSIS_COMMAND]
		do
			create shell.make ("SELECTED PAGES REPORT BY MONTH AND GEOGRAPHIC LOCATION", config_path)
			shell.run_command_loop
		end

	status_404_geographic
		local
			shell: EL_LOG_ANALYSIS_COMMAND_SHELL [EL_GEOGRAPHIC_404_ANALYSIS_COMMAND]
		do
			create shell.make ("404 REPORT BY GEOGRAPHIC LOCATION", config_path)
			shell.run_command_loop
		end

	status_404_request_count
		local
			shell: EL_LOG_ANALYSIS_COMMAND_SHELL [EL_REQUEST_COUNT_404_ANALYSIS_COMMAND]
		do
			create shell.make ("404 REPORT BY USER AGENT", config_path)
			shell.run_command_loop
		end

	status_404_user_agent
		local
			shell: EL_LOG_ANALYSIS_COMMAND_SHELL [EL_USER_AGENT_404_ANALYSIS_COMMAND]
		do
			create shell.make ("404 REPORT BY USER AGENT", config_path)
			shell.run_command_loop
		end

feature {NONE} -- Factory

	new_command_table: like command_table
		do
			create Result.make_assignments (<<
				["Visitor geographic location by month",			  agent selected_geographic],
				["Request 404 status by geopraphic location",	  agent status_404_geographic],
				["Request 404 status by user agent with summary", agent status_404_user_agent],
				["Request 404 status request count summary",		  agent status_404_request_count]
			>>)
		end

feature {NONE} -- Internal attributes

	config_path: FILE_PATH

end