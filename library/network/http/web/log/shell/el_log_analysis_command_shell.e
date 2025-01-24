note
	description: "Abstract class for web log analysis shells"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-24 11:29:58 GMT (Friday 24th January 2025)"
	revision: "1"

deferred class
	EL_LOG_ANALYSIS_COMMAND_SHELL

inherit
	EL_COMMAND_SHELL_I
		rename
			make as make_shell
		end

feature {NONE} -- Initialization

	make (config_path: FILE_PATH)
		require
			config_exists: config_path.exists
		do
			create config.make (config_path)
			make_shell (title, 10)
		end

feature {NONE} -- Implementation

	analyse (web_log: EL_WEB_SERVER_LOG)
		do
			web_log.do_analysis (new_parser_command)
		end

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

feature {NONE} -- Deferred

	 new_parser_command: EL_WEB_LOG_PARSER_COMMAND
		deferred
		end

	title: STRING
		deferred
		end

feature {NONE} -- Internal attributes

	config: EL_TRAFFIC_ANALYSIS_CONFIG

end