note
	description: "Desktop console application installer i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "8"

deferred class
	EL_CONSOLE_APP_MENU_DESKTOP_ENV_I

inherit
	EL_MENU_DESKTOP_ENVIRONMENT_I
		redefine
			make_default, getter_function_table
		end

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			geometry := default_geometry.twin
		end

feature -- Access

	geometry: like default_geometry
		-- position, width and height of terminal in characters

feature -- Element change

	set_terminal_position (x, y: INTEGER)
			--
		do
			geometry.pos_x := x
			geometry.pos_y := y
		end

	set_terminal_dimensions (chars_width, chars_heigth: INTEGER)
			-- set width and heigth of terminal in characters
		do
			geometry.width := chars_width
			geometry.height := chars_heigth
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor +
				["term_pos_x", agent: INTEGER_REF do Result := geometry.pos_x.to_reference end] +
				["term_pos_y", agent: INTEGER_REF do Result := geometry.pos_y.to_reference end] +
				["term_width", agent: INTEGER_REF do Result := geometry.width.to_reference end] +
				["term_height", agent: INTEGER_REF do Result := geometry.height.to_reference end]
		end

feature -- Constants

	default_geometry: TUPLE [pos_x, pos_y, width, height: INTEGER]
			--
		deferred
		end

end