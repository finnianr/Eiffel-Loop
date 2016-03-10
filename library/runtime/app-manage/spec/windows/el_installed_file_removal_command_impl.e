note
	description: "[
		Windows implementation of program directory removal
		
		Command:
			rmdir "$software_company_directory"
			
		only works if directory is empty (which is fine)
			
		Command:
			ping localhost -n 3 >nul
			
		provides some delay inorder to give calling process time to quit.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-17 11:28:36 GMT (Thursday 17th December 2015)"
	revision: "4"

class
	EL_INSTALLED_FILE_REMOVAL_COMMAND_IMPL

inherit
	EL_INSTALLED_FILE_REMOVAL_COMMAND

create
	make

feature {NONE} -- Constants

	Command_template: EL_ASTRING
		once
			Result := "cmd /C %"%S%""
		end

	Uninstall_script_name: EL_ASTRING
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
