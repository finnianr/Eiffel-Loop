note
	description: "Windows implementation"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_INSTALLED_FILE_REMOVAL_COMMAND_IMPL

inherit
	EL_INSTALLED_FILE_REMOVAL_COMMAND

create
	make

feature {NONE} -- Constants

	Command_template: EL_TEMPLATE_STRING
		once
			Result := "cmd /C %"$S%""
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
