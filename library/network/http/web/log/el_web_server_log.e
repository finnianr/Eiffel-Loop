note
	description: "Web server log for analysis with parser conforming to ${EL_WEB_LOG_PARSER_COMMAND}"
	notes: "[
		The server log may be either compressed or plain text. Usually the most recent backup
		after a log rotation is plain text.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-23 17:56:37 GMT (Thursday 23rd January 2025)"
	revision: "1"

class
	EL_WEB_SERVER_LOG

inherit
	ANY

	EL_MODULE_DATE_TIME; EL_MODULE_DIRECTORY; EL_MODULE_FILE; EL_MODULE_OS

	EL_SHARED_FORMAT_FACTORY

create
	make

feature {NONE} -- Initialization

	make (a_path: FILE_PATH)
		do
			path := a_path
			if is_compressed and then attached Zip_list_command as cmd then
				cmd.set_zip_path (path)
				size_mb := cmd.size_mb
			else
				size_mb := File.megabyte_count (path)
			end
		end

feature -- Access

	description: ZSTRING
		local
			date: EL_DATE_TIME
		do
			date := Date_time.modification_time (path)
			Result := Info_template #$ [date.formatted_out (Date_format), formatted_size_mb]
		end

	formatted_size_mb: STRING
		do
			Result := Format.double ("99.9").formatted (size_mb)
		end

	modification_time: INTEGER
		do
			Result := path.modification_time
		end

	path: FILE_PATH

	size_mb: DOUBLE

feature -- Status query

	is_compressed: BOOLEAN
		-- `True' if log file at `path' is compressed with gzip command
		do
			Result := path.has_extension (Extension_gz)
		end

feature -- Basic operations

	do_analysis (parser_cmd: EL_WEB_LOG_PARSER_COMMAND)
		-- write `path' file to temporary file uncompressing it if `is_compressed' is true
		-- and then analyze with `parser_cmd'
		local
			temp_log_path: FILE_PATH
		do
			temp_log_path := Directory.temporary + path.base_name
			temp_log_path.add_extension ("log")

			if is_compressed and then attached Unzip_command as cmd then
				cmd.set_file_path (path)
				cmd.set_unzipped_path (temp_log_path)
				cmd.execute

			elseif attached File_list_command as cmd then
				cmd.put_path (cmd.var.input_path, path)
				cmd.put_path (cmd.var.output_path, temp_log_path)
				cmd.execute
			end
			if temp_log_path.exists then
				parser_cmd.set_log_path (temp_log_path)
				parser_cmd.execute
				OS.File_system.remove_file (temp_log_path)
			end
		end

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

	Date_format: STRING = "yyyy/[0]mm Mmm [0]dd"

	Extension_gz: ZSTRING
		once
			Result := "gz"
		end

	Info_template: ZSTRING
		once
			Result := "%S (%S MB)"
		end

end