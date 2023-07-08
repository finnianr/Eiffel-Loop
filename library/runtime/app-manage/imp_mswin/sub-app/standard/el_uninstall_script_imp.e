note
	description: "Windows implementation of [$source EL_UNINSTALL_SCRIPT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-08 17:35:30 GMT (Saturday 8th July 2023)"
	revision: "10"

class
	EL_UNINSTALL_SCRIPT_IMP

inherit
	EL_UNINSTALL_SCRIPT_I
		rename
			new_script as new_batch_script
		redefine
			new_batch_script, serialize, write_remove_directory_lines
		end

	EL_OS_IMPLEMENTATION

	EL_MODULE_CONSOLE

create
	make

feature -- Basic operations

	serialize
		do
			File_system.make_directory (output_path.parent)
			if attached new_batch_script (output_path) as script then
				script.open_write
				serialize_to_stream (script)
				script.close
			end
		end

feature {NONE} -- Implementation

	new_batch_script (path: FILE_PATH): EL_PLAIN_TEXT_FILE
		do
			create Result.make_with_name (path)
			Result.set_other_encoding (Console.Encoding)
		end

	uninstall_base_list: EL_ZSTRING_LIST
		do
			create Result.make_comma_split ("start, /WAIT, /D")
			Result.extend (Directory.Application_bin.escaped)
			Result.extend (Executable.name)
		end

	write_remove_directory_lines (script: like new_batch_script)
		do
			script.put_string_8 ("Rem encoding: " + script.encoding_name)
			script.put_new_line
			script.put_new_line
			Precursor (script)
		end

feature {NONE} -- Constants

	Dot_extension: STRING = "bat"

	Lio_visible_types: ARRAY [TYPE [EL_MODULE_LIO]]
		once
			create Result.make_empty
		end

	Remove_dir_and_parent_commands: ZSTRING
		once
			-- '#' = '%S' substitution marker
			Result := "[
				rmdir /S /Q #
				rmdir #
			]"
		end

	Template: STRING = "[
		@echo off
		title $title
		$uninstall_command
		if %ERRORLEVEL% neq 0 goto Cancelled
		call $remove_files_script_path
		del $remove_files_script_path
		echo $completion_message
		pause
		del $script_path
		:Cancelled
	]"

end