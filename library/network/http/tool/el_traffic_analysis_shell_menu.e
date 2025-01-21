note
	description: "Menu of compressed logs to analyze"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-21 16:19:10 GMT (Tuesday 21st January 2025)"
	revision: "13"

class
	EL_TRAFFIC_ANALYSIS_SHELL_MENU

inherit
	EL_APPLICATION_COMMAND_SHELL
		rename
			make as make_shell
		end

	EL_MODULE_COMMAND; EL_MODULE_DATE_TIME; EL_MODULE_DIRECTORY; EL_MODULE_FILE
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

	analyse_log (log_path: FILE_PATH)
		-- analyse `log_path' and uncompress to temporary file if it ends with "gz" extension
		-- (The first log is usually not compressed)
		local
			analysis_cmd: EL_TRAFFIC_ANALYSIS_COMMAND; temp_log_path: FILE_PATH
		do
			temp_log_path := Directory.temporary + log_path.base_name
			temp_log_path.add_extension ("log")

			if log_path.has_extension (Extension_gz) and then attached Unzip_command as cmd then
				cmd.set_file_path (log_path)
				cmd.set_unzipped_path (temp_log_path)
				cmd.execute

			elseif attached File_list_command as cmd then
				cmd.put_path (cmd.var.input_path, log_path)
				cmd.put_path (cmd.var.output_path, temp_log_path)
				cmd.execute
			end
			if temp_log_path.exists then
				create analysis_cmd.make (temp_log_path, config)
				analysis_cmd.execute
				OS.File_system.remove_file (temp_log_path)
			end
		end

feature {NONE} -- Factory

	new_command_table: like command_table
		local
			label: ZSTRING; formatted_size_mb: STRING; size_mb: DOUBLE
			log_path_wilcard: FILE_PATH
		do
			log_path_wilcard := config.log_path.twin
			log_path_wilcard.add_extension ("*")
			if attached OS.file_pattern_list (log_path_wilcard) as file_list then
				create Result.make (file_list.count)
				file_list.order_by (agent {FILE_PATH}.modification_time, False)
				across file_list as list loop
					if attached list.item as path and then attached Date_time.modification_time (path) as date then
						if path.has_extension (Extension_gz) and then attached Zip_list_command as cmd then
							cmd.set_zip_path (path)
							size_mb := cmd.size_mb
						else
							size_mb := File.megabyte_count (path)
						end
						formatted_size_mb := Format.double ("99.9").formatted (size_mb)

						label := Label_template #$ [date.formatted_out (Date_format), formatted_size_mb]
						Result.put (agent analyse_log (path), label)
					end
				end
			end
		end

feature {NONE} -- Internal attributes

	config: EL_TRAFFIC_ANALYSIS_CONFIG

feature {NONE} -- OS commands

	File_list_command: EL_PARSED_OS_COMMAND [TUPLE [input_path, output_path: STRING]]
		once
			create Result.make_command ("cat $input_path > $output_path")
			Result.sudo.enable
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

feature {NONE} -- Constants

	Date_format: STRING = " yyyy/[0]mm Mmm [0]dd"

	Extension_gz: ZSTRING
		once
			Result := "gz"
		end

	Label_template: ZSTRING
		once
			Result := "%S (%S MB)"
		end

end