note
	description: "Console application installer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-24 10:02:36 GMT (Friday 24th June 2016)"
	revision: "4"

class
	EL_DESKTOP_CONSOLE_APPLICATION_INSTALLER_IMP

inherit
	EL_DESKTOP_APPLICATION_INSTALLER_IMP
		rename
			Command as Mod_command
		redefine
			Command_args_template
		end

create
	make

feature {EL_DESKTOP_CONSOLE_APPLICATION_INSTALLER_I} -- Implementation

	Command_args_template: ZSTRING
		-- geometry parameter from X manual page:

		-- 		geometry WIDTHxHEIGHT+XOFF+YOFF (where WIDTH, HEIGHT, XOFF, and YOFF are numbers)
		-- 		for specifying a preferred size and location for this application's main window.
		-- 		location relative to top left corner
		--		See: http://www.xfree86.org/current/X.7.html
		once
			Result := "[
				--command="$launch_command -$sub_application_option $command_options"
				--geometry=${term_width}x${term_height}+${term_pos_x}+${term_pos_y}
				--title="$title"
			]"
		end

	Command: STRING = "gnome-terminal"

feature {EL_DESKTOP_CONSOLE_APPLICATION_INSTALLER} -- Constants

	Default_terminal_pos: EL_GRAPH_POINT
			--
		once
			create Result.make (100, 100)
		end

	Default_terminal_width: INTEGER = 140

	Default_terminal_height: INTEGER = 50

end
