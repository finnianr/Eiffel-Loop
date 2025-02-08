note
	description: "Command shell for selecting log file analysis report"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-08 9:36:45 GMT (Saturday 8th February 2025)"
	revision: "21"

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

	status_404_uri_extension_occurrences
		local
			shell: EL_LOG_ANALYSIS_COMMAND_SHELL [EL_URI_EXTENSION_404_ANALYSIS_COMMAND]
		do
			create shell.make ("404 REPORT OF EXTENSION OCCURRENCE FREQUENCY", config_path)
			shell.run_command_loop
		end

	status_404_uri_1st_step_occurrences
		local
			shell: EL_LOG_ANALYSIS_COMMAND_SHELL [EL_URI_FIRST_STEP_404_ANALYSIS_COMMAND]
		do
			create shell.make ("404 REPORT OF 1st STEP OCCURRENCE FREQUENCY", config_path)
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
				["Visitor geographic location by month",				  agent selected_geographic],
				["404 status by geopraphic location",					  agent status_404_geographic],
				["404 status by user agent with summary",				  agent status_404_user_agent],
				["404 status by URI 1st step occurrence frequency",  agent status_404_uri_1st_step_occurrences],
				["404 status by URI extension occurrence frequency", agent status_404_uri_extension_occurrences]
			>>)
		end

feature {NONE} -- Internal attributes

	config_path: FILE_PATH

end