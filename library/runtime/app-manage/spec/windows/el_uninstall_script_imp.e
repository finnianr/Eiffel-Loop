note
	description: "Windows implementation of [$source EL_UNINSTALL_SCRIPT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-29 11:58:35 GMT (Friday 29th June 2018)"
	revision: "5"

class
	EL_UNINSTALL_SCRIPT_IMP

inherit
	EL_UNINSTALL_SCRIPT_I
		redefine
			serialize, script, getter_function_table
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

feature {NONE} -- Internal attributes

	script: EL_BATCH_SCRIPT_FILE

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor +
				["application_bin", agent: ZSTRING do Result := Directory.Application_bin.escaped end] +
				["executable_name", agent: ZSTRING do Result := Execution_environment.Executable_name end]
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
		start /WAIT /D $application_bin $executable_name -uninstall
		if %ERRORLEVEL% neq 0 goto Cancelled
		call $remove_files_script_path
		del $remove_files_script_path
		echo $completion_message
		pause
		del $script_path
		:Cancelled
	]"

end
