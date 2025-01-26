note
	description: "[
		Command shell to analyse web logs with command conforming to ${EL_TRAFFIC_ANALYSIS_COMMAND}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-26 18:15:09 GMT (Sunday 26th January 2025)"
	revision: "2"

class
	EL_LOG_ANALYSIS_COMMAND_SHELL [COMMAND -> EL_TRAFFIC_ANALYSIS_COMMAND create make end]

inherit
	EL_COMMAND_SHELL_I
		rename
			make as make_shell
		end

create
	make

feature {NONE} -- Initialization

	make (title: STRING; config_path: FILE_PATH)
		require
			config_exists: config_path.exists
		do
			create config.make (config_path)
			make_shell (title, 10)
		end

feature {NONE} -- Implementation

	analyse (web_log: EL_WEB_SERVER_LOG)
		do
			web_log.do_analysis (create {COMMAND}.make (config))
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

feature {NONE} -- Internal attributes

	config: EL_TRAFFIC_ANALYSIS_CONFIG

end