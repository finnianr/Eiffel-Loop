note
	description: "[
		Command shell to analyse web logs with command conforming to ${EL_TRAFFIC_ANALYSIS_COMMAND}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-31 9:23:25 GMT (Friday 31st January 2025)"
	revision: "3"

class
	EL_LOG_ANALYSIS_COMMAND_SHELL [COMMAND -> EL_TRAFFIC_ANALYSIS_COMMAND create make end]

inherit
	EL_COMMAND_SHELL_I
		rename
			make as make_shell
		redefine
			display_menu
		end

create
	make

feature {NONE} -- Initialization

	make (title: STRING; config_path: FILE_PATH)
		require
			config_exists: config_path.exists
		do
			create config.make (config_path)
			create request_method.make_empty
			make_shell (title, 10)
		end

feature {NONE} -- Implementation

	analyse (web_log: EL_WEB_SERVER_LOG)
		local
			command: COMMAND
		do
			create command.make (config)
			command.set_request_method (request_method)
			web_log.do_analysis (command)
		end

	display_menu
		do
			menu.display
			if request_method.count > 0 then
				lio.put_labeled_string ("Method filter", request_method)
				lio.put_new_line
			end
		end

	set_request_method
		do
			request_method := User_input.line ("Enter request method filter (GET/HEAD/POST)")
			lio.put_new_line
		end

	new_command_table: like command_table
		local
			log_list: EL_WEB_SERVER_LOG_LIST
		do
			create log_list.make (config.log_path)
			create Result.make (log_list.count + 1)
			Result.put (agent set_request_method, "Set HTTP request method filter")
			across log_list as list loop
				Result.put (agent analyse (list.item), list.item.description)
			end
		end

feature {NONE} -- Internal attributes

	config: EL_TRAFFIC_ANALYSIS_CONFIG

	request_method: STRING

end