note
	description: "Menu of compressed logs to analyze"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-30 13:59:14 GMT (Thursday 30th June 2022)"
	revision: "3"

class
	EL_TRAFFIC_ANALYSIS_SHELL_MENU

inherit
	EL_APPLICATION_COMMAND_SHELL
		rename
			make as make_shell
		end

	EL_MODULE_LIO; EL_MODULE_OS; EL_MODULE_TUPLE

	EL_MODULE_COMMAND

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

	analyse_log (log_gz_path: FILE_PATH)
		local
			log_path: FILE_PATH; analysis_cmd: EL_TRAFFIC_ANALYSIS_COMMAND
		do
			log_path := log_gz_path.without_extension
			if attached Unzip_command as cmd then
				cmd.put_path (Var.path, log_gz_path)
				cmd.execute
			end
			if log_path.exists then
				create analysis_cmd.make (log_path, config)
				analysis_cmd.execute
				if attached Command.new_delete_file (log_path) as cmd then
					cmd.sudo.enable
					cmd.execute
				end
			end
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

	Unzip_command: EL_OS_COMMAND
		once
			create Result.make ("gunzip $path")
			Result.sudo.enable
		end

	Var: TUPLE [path: STRING]
		once
			create Result
			Unzip_command.fill_variables (Result)
		end

	Date_format: STRING = " yyyy/mm Mmm dd"
end