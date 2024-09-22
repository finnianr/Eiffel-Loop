note
	description: "Menu of compressed logs to analyze"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 17:41:49 GMT (Sunday 22nd September 2024)"
	revision: "12"

class
	EL_TRAFFIC_ANALYSIS_SHELL_MENU

inherit
	EL_APPLICATION_COMMAND_SHELL
		rename
			make as make_shell
		end

	EL_MODULE_COMMAND; EL_MODULE_DATE_TIME; EL_MODULE_DIRECTORY
	EL_MODULE_LIO; EL_MODULE_OS; EL_MODULE_TUPLE

	EL_SHARED_FORMAT_FACTORY

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
			analysis_cmd: EL_TRAFFIC_ANALYSIS_COMMAND
		do
			if attached (Directory.temporary + (log_gz_path.base_name + ".log")) as log_path then
				if attached Unzip_command as cmd then
					cmd.set_file_path (log_gz_path)
					cmd.set_unzipped_path (log_path)
					cmd.execute
					if log_path.exists then
						create analysis_cmd.make (log_path, config)
						analysis_cmd.execute
						OS.File_system.remove_file (log_path)
					end
				end
			end
		end

feature {NONE} -- Factory

	new_command_table: like command_table
		local
			label: ZSTRING; size_mb: STRING
		do
			if attached OS.file_pattern_list (config.archived_web_logs) as file_list then
				create Result.make (file_list.count)
				file_list.order_by (agent {FILE_PATH}.modification_time, False)
				across file_list as list loop
					if attached Date_time.modification_time (list.item) as date
						and then attached Zip_list_command as cmd
					then
						cmd.set_zip_path (list.item)
						size_mb := Format.double ("99.9").formatted (cmd.size_mb)

						label := Label_template #$ [date.formatted_out (Date_format), size_mb]
						Result.put (agent analyse_log (list.item), label)
					end
				end
			end
		end

feature {NONE} -- Internal attributes

	config: EL_TRAFFIC_ANALYSIS_CONFIG

feature {NONE} -- Constants

	Label_template: ZSTRING
		once
			Result := "%S (%S MB)"
		end

	Unzip_command: EL_GUNZIP_COMMAND
		once
			create Result.make
			Result.sudo.enable
		end

	Zip_list_command: EL_GUNZIP_LIST_COMMAND
		once
			create Result.make
			Result.sudo.enable
		end

	Date_format: STRING = " yyyy/[0]mm Mmm [0]dd"
end