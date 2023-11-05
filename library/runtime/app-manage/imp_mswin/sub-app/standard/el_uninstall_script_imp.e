note
	description: "Windows implementation of [$source EL_UNINSTALL_SCRIPT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-05 17:24:33 GMT (Sunday 5th November 2023)"
	revision: "12"

class
	EL_UNINSTALL_SCRIPT_IMP

inherit
	EL_UNINSTALL_SCRIPT_I
		redefine
			write_remove_directory_lines
		end

	EL_WINDOWS_IMPLEMENTATION

	EL_MODULE_CONSOLE

create
	make

feature {NONE} -- Implementation

	script_encoding: EL_ENCODEABLE_AS_TEXT
		do
			create Result.make_default
			Result.set_encoding_other (Console.Encoding)
		end

	write_remove_directory_lines (script: like new_script)
		do
			script.put_string_8 ("Rem encoding: " + script.encoding_name)
			script.put_new_line_x2
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
		Rem encoding: $encoding_name
		@echo off
		title $title
		start /WAIT /D $uninstall_command
		if %ERRORLEVEL% neq 0 goto Cancelled
		call $remove_files_script_path
		del $remove_files_script_path
		echo $completion_message
		pause
		del $script_path
		:Cancelled
	]"

end