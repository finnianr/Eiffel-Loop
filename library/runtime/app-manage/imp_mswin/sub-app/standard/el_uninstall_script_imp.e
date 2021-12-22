note
	description: "Windows implementation of [$source EL_UNINSTALL_SCRIPT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-20 19:00:15 GMT (Monday 20th December 2021)"
	revision: "8"

class
	EL_UNINSTALL_SCRIPT_IMP

inherit
	EL_UNINSTALL_SCRIPT_I
		redefine
			serialize, script
		end

	EL_OS_IMPLEMENTATION

create
	make

feature -- Basic operations

	serialize
		do
			File_system.make_directory (output_path.parent)
			script.make_open_write (output_path)
			serialize_to_stream (script)
			script.close
		end

feature {NONE} -- Implementation

	uninstall_base_list: EL_ZSTRING_LIST
		do
			create Result.make_comma_split ("start, /WAIT, /D")
			Result.extend (Directory.Application_bin.escaped)
			Result.extend (Executable.name)
		end

feature {NONE} -- Internal attributes

	script: EL_BATCH_SCRIPT_FILE

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