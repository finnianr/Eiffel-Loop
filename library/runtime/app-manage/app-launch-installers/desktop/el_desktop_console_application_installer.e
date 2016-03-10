note
	description: "Summary description for {EL_MENU_CONSOLE_APPLICATION_LAUNCHER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 11:56:18 GMT (Monday 24th June 2013)"
	revision: "2"

class
	EL_DESKTOP_CONSOLE_APPLICATION_INSTALLER

inherit
	EL_DESKTOP_APPLICATION_INSTALLER
		redefine
			make, getter_function_table, implementation, command, create_implementation
		end

create
	make

feature {NONE} -- Initialization

	make (a_application: EL_SUB_APPLICATION; a_submenu_path: ARRAY [EL_DESKTOP_MENU_ITEM]; a_desktop_launch_entry: EL_DESKTOP_LAUNCHER)
			--
		do
			Precursor (a_application, a_submenu_path, a_desktop_launch_entry)

			terminal_pos_x := default_terminal_pos.x
			terminal_pos_y := default_terminal_pos.y
			terminal_width := default_terminal_width
			terminal_height := default_terminal_height
		end

	create_implementation
			--
		do
			create implementation.make (Current)
		end

feature -- Access

	terminal_pos_x: INTEGER

	terminal_pos_y: INTEGER

	terminal_width: INTEGER
		-- width of terminal in characters

	terminal_height: INTEGER
		-- height of terminal in characters

	command: EL_ASTRING
		do
			Result := implementation.Command
		end

feature -- Element change

	set_terminal_position (x, y: INTEGER)
			--
		do
			terminal_pos_x := x
			terminal_pos_y := y
		end

	set_terminal_dimensions (chars_width, chars_heigth: INTEGER)
			-- set width and heigth of terminal in characters
		do
			terminal_width := chars_width
			terminal_height := chars_heigth
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor
			Result.append_tuples (<<
				["term_pos_x", agent: INTEGER do Result := terminal_pos_x.to_reference end],
				["term_pos_y", agent: INTEGER do Result := terminal_pos_y.to_reference end],
				["term_width", agent: INTEGER do Result := terminal_width.to_reference end],
				["term_height", agent: INTEGER do Result := terminal_height.to_reference end]
			>>)
		end

feature {NONE} -- Implementation

	implementation: EL_DESKTOP_CONSOLE_APPLICATION_INSTALLER_IMPL

feature -- Constants

	Default_terminal_pos: EL_GRAPH_POINT
			--
		do
			Result := implementation.Default_terminal_pos
		end

	Default_terminal_width: INTEGER
			--
		do
			Result := implementation.Default_terminal_width
		end

	Default_terminal_height: INTEGER
			--
		do
			Result := implementation.Default_terminal_height
		end

end
