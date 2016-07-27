note
	description: "[
		Windows implementation of program directory removal command:
			rmdir "$software_company_directory"
			
		only works if directory is empty (which is fine)
			
		This command provides some delay inorder to give calling process time to quit.
			ping localhost -n 3 >nul
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-07 15:49:45 GMT (Thursday 7th July 2016)"
	revision: "4"

class
	EL_INSTALLED_FILE_REMOVAL_COMMAND_IMP

inherit
	EL_INSTALLED_FILE_REMOVAL_COMMAND
		redefine
			serialize_to_file
		end

create
	make

feature {NONE} -- Implemenation

	serialize_to_file (file_path: like command_path)
		local
			script_file: EL_BATCH_SCRIPT_FILE
		do
			create script_file.make_open_write (file_path)
			serialize_to_stream (script_file)
			script_file.close
		end

feature {NONE} -- Constants

	Command_template: ZSTRING
		once
			Result := "cmd /C %"%S%""
		end

	Uninstall_script_name: ZSTRING
		once
			Result := "uninstall.bat"
		end

	Template: STRING = "[
		@echo off
		ping localhost -n 3 >nul
		rmdir /S /Q "$program_directory"
		rmdir "$software_company_directory"
		echo $completion_message
		pause
	]"

end