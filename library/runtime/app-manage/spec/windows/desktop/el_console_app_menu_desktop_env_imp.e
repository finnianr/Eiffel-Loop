note
	description: "Windows implementation of [$source EL_CONSOLE_APP_MENU_DESKTOP_ENV_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "6"

class
	EL_CONSOLE_APP_MENU_DESKTOP_ENV_IMP

inherit
	EL_CONSOLE_APP_MENU_DESKTOP_ENV_I
		undefine
			make, application_command, Command_args_template, launch_command
		end

	EL_MENU_DESKTOP_ENVIRONMENT_IMP
		undefine
			make_default, launch_command, getter_function_table
		redefine
			Command_args_template, launch_command
		end

create
	make

feature {EL_CONSOLE_APP_MENU_DESKTOP_ENV_I} -- Constants

	Command_args_template: STRING
		-- geometry parameter from X manual page:

		-- 		geometry WIDTHxHEIGHT+XOFF+YOFF (where WIDTH, HEIGHT, XOFF, and YOFF are numbers)
		-- 		for specifying a preferred size and location for this application's main window.
		-- 		location relative to top left corner
		--		See: http://www.xfree86.org/current/X.7.html
		once
			Result := "[
				--geometry=${term_width}x${term_height}+${term_pos_x}+${term_pos_y} 
				--title="$menu_name"
				-x $command_path -$sub_application_option $command_options
			]"
		end

	Default_geometry: TUPLE [pos_x, pos_y, width, height: INTEGER]
			--
		once
			Result := [100, 100, 140, 50]
		end

	Launch_command: ZSTRING
		once
			Result := "gnome-terminal"
		end

end
