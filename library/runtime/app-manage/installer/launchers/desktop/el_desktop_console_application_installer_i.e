note
	description: "Summary description for {EL_MENU_CONSOLE_APPLICATION_LAUNCHER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-16 16:38:12 GMT (Friday 16th February 2018)"
	revision: "3"

deferred class
	EL_DESKTOP_CONSOLE_APPLICATION_INSTALLER_I

inherit
	EL_DESKTOP_APPLICATION_INSTALLER_I
		redefine
			make, getter_function_table
		end

feature {NONE} -- Initialization

	make (
		a_application: EL_SUB_APPLICATION; a_submenu_path: ARRAY [EL_DESKTOP_MENU_ITEM]
		a_desktop_launch_entry: EL_DESKTOP_LAUNCHER
	)
			--
		do
			Precursor (a_application, a_submenu_path, a_desktop_launch_entry)

			terminal_pos_x := default_terminal_pos.x
			terminal_pos_y := default_terminal_pos.y
			terminal_width := default_terminal_width
			terminal_height := default_terminal_height
		end

feature -- Access

	terminal_pos_x: INTEGER

	terminal_pos_y: INTEGER

	terminal_width: INTEGER
		-- width of terminal in characters

	terminal_height: INTEGER
		-- height of terminal in characters

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
				Result := Precursor +
					["term_pos_x", agent: INTEGER_REF do Result := terminal_pos_x.to_reference end] +
					["term_pos_y", agent: INTEGER_REF do Result := terminal_pos_y.to_reference end] +
					["term_width", agent: INTEGER_REF do Result := terminal_width.to_reference end] +
					["term_height", agent: INTEGER_REF do Result := terminal_height.to_reference end]
		end

feature -- Constants

	default_terminal_pos: EL_GRAPH_POINT
			--
		deferred
		end

	default_terminal_width: INTEGER
			--
		deferred
		end

	default_terminal_height: INTEGER
			--
		deferred
		end

end
