note
	description: "Menu of compressed logs to analyze"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-23 17:45:30 GMT (Thursday 23rd January 2025)"
	revision: "14"

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

	make (config_path: FILE_PATH)
		require
			config_exists: config_path.exists
		do
			create config.make (config_path)
			make_shell ("GEOGRAPHIC REPORT BY MONTH", 10)
		end

feature -- Constants

	Description: STRING = "Command shell for selecting log file to do traffic analysis"

feature {NONE} -- Commands

	analyse (web_log: EL_WEB_SERVER_LOG)
		do
			web_log.do_analysis (create {EL_TRAFFIC_ANALYSIS_COMMAND}.make (config))
		end

feature {NONE} -- Factory

	new_command_table: like command_table
		local
			log_list: EL_WEB_SERVER_LOG_LIST
		do
			create log_list.make (config.log_path)
			create Result.make (log_list.count)
			across log_list as list loop
				Result.put (agent analyse (list.item), list.item.description)
			end
		end

feature {NONE} -- Internal attributes

	config: EL_TRAFFIC_ANALYSIS_CONFIG

end