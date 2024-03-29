note
	description: "Unix implementation of ${EL_UNINSTALL_APP_MENU_DESKTOP_ENV_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "9"

class
	EL_UNINSTALL_APP_MENU_DESKTOP_ENV_IMP

inherit
	EL_UNINSTALL_APP_MENU_DESKTOP_ENV_I
		rename
			make as make_desktop
		undefine
			application_command, make_desktop, Command_args_template
		redefine
			launch_command
		end

	EL_MENU_DESKTOP_ENVIRONMENT_IMP
		undefine
			launch_command, command_path
		redefine
			Command_args_template
		end

	EL_MODULE_COMMAND

create
	make

feature {NONE} -- Implementation

	launch_command: ZSTRING
		do
			Result := "gksu"
		end

feature {NONE} -- Constants

	Command_args_template: STRING
		once
			Result := "[
				-D "$menu_name" "gnome-terminal --title='$menu_name' --geometry=100x40+100+100 -x $command_path"
			]"
		end

end