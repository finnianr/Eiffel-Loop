note
	description: "Summary description for {EL_MENU_CONSOLE_APPLICATION_LAUNCHER_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-02-27 16:30:27 GMT (Thursday 27th February 2014)"
	revision: "3"

class
	EL_DESKTOP_CONSOLE_APPLICATION_INSTALLER_IMPL

inherit
	EL_DESKTOP_APPLICATION_INSTALLER_IMPL
		redefine
			command_args_template
		end

create
	make, default_create

feature {EL_DESKTOP_CONSOLE_APPLICATION_INSTALLER} -- Implementation

	Command_args_template: STRING =
		-- geometry parameter from X manual page:

		-- 		geometry WIDTHxHEIGHT+XOFF+YOFF (where WIDTH, HEIGHT, XOFF, and YOFF are numbers)
		-- 		for specifying a preferred size and location for this application's main window.
		-- 		location relative to top left corner
		--		See: http://www.xfree86.org/current/X.7.html
	"[
		--command="'$command' -$sub_application_option $command_options"
		--geometry=${term_width}x${term_height}+${term_pos_x}+${term_pos_y} 
		--title="$title"
	]"

	command: STRING = "gnome-terminal"

feature {EL_DESKTOP_CONSOLE_APPLICATION_INSTALLER} -- Constants

	Default_terminal_pos: EL_GRAPH_POINT
			--
		once
			create Result.make (100, 100)
		end

	Default_terminal_width: INTEGER = 140

	Default_terminal_height: INTEGER = 50

end
