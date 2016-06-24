note
	description: "Unix implementation"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-24 10:06:22 GMT (Friday 24th June 2016)"
	revision: "5"

class
	EL_INSTALLED_FILE_REMOVAL_COMMAND_IMP

inherit
	EL_INSTALLED_FILE_REMOVAL_COMMAND

create
	make

feature {NONE} -- Constants

	Command_template: ZSTRING
		once
			Result := "%S"
		end

	Uninstall_script_name: ZSTRING
		once
			Result := "uninstall.sh"
		end

	Template: STRING = "[
		ping localhost -n 3 > /dev/null
		rm -r "$program_directory"
		#rmdir "$software_company_directory"
		echo $completion_message
		read -p '<RETURN TO FINISH>' str
	]"

end
