note
	description: "Unix implementation of `EL_DESKTOP_CONSOLE_APPLICATION_INSTALLER_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-24 10:05:16 GMT (Friday 24th June 2016)"
	revision: "5"

class
	EL_DESKTOP_CONSOLE_APPLICATION_INSTALLER_IMP

inherit
	EL_DESKTOP_CONSOLE_APPLICATION_INSTALLER_I
		redefine
			new_command_args_template, launch_command
		end

	EL_DESKTOP_APPLICATION_INSTALLER_IMP
		undefine
			make, launch_command, getter_function_table
		redefine
			new_command_args_template, launch_command
		end

create
	make

feature {NONE} -- Factory

	new_command_args_template: ZSTRING
		-- geometry parameter from X manual page:

		-- 		geometry WIDTHxHEIGHT+XOFF+YOFF (where WIDTH, HEIGHT, XOFF, and YOFF are numbers)
		-- 		for specifying a preferred size and location for this application's main window.
		-- 		location relative to top left corner
		--		See: http://www.xfree86.org/current/X.7.html
		do
			Result := "[
				--command="'$application_command' -$sub_application_option $command_options"
				--geometry=${term_width}x${term_height}+${term_pos_x}+${term_pos_y} 
				--title="$title"
			]"
		end

feature {EL_DESKTOP_CONSOLE_APPLICATION_INSTALLER_I} -- Implementation

	Launch_command: ZSTRING
		once
			Result := "gnome-terminal"
		end

feature {EL_DESKTOP_CONSOLE_APPLICATION_INSTALLER_I} -- Constants

	Default_terminal_pos: EL_GRAPH_POINT
			--
		once
			create Result.make (100, 100)
		end

	Default_terminal_width: INTEGER = 140

	Default_terminal_height: INTEGER = 50

end
