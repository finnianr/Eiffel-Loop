note
	description: "Menu of compressed logs to analyze"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-30 11:54:28 GMT (Thursday 30th June 2022)"
	revision: "2"

class
	EL_TRAFFIC_ANALYSIS_SHELL_MENU

inherit
	EL_APPLICATION_COMMAND_SHELL
		rename
			make as make_shell
		end

	EL_MODULE_OS

	EL_MODULE_LIO

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (config_path: FILE_PATH)
		require
			config_exists: config_path.exists
		do
			create config.make (config_path)
			make_shell ("LOG MENU", 10)
		end

feature -- Constants

	Description: STRING = "Command shell for selecting log file to do traffic analysis"

feature {NONE} -- Commands

	analyse_log (log_path: FILE_PATH)
		do
		end

feature {NONE} -- Implementation



feature {NONE} -- Factory

	new_command_table: like command_table
		local
			date: EL_DATE_TIME
		do
			if attached OS.file_pattern_list (config.archived_web_logs) as file_list then
				create Result.make_equal (file_list.count)
				file_list.order_by (agent {FILE_PATH}.modification_time, False)
				across file_list as list loop
					date := list.item.modification_date_time
					Result.put (agent analyse_log (list.item), date.formatted_out (Date_format))
				end
			end
		end

feature {NONE} -- Internal attributes

	config: EL_TRAFFIC_ANALYSIS_CONFIG

feature {NONE} -- Constants

	Date_format: STRING = " yyyy/mm Mmm dd"
end