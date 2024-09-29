note
	description: "Widget with width and ${COLOR_ENUM} color properties"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-29 9:29:37 GMT (Sunday 29th September 2024)"
	revision: "8"

class
	WIDGET

inherit
	ANY
		redefine
			out
		end

	SHARED_COLOR_ENUM
		rename
			Color as Color_enum
		end

create
	make, make_2

convert
	make ({TUPLE [NATURAL_8, INTEGER]})

feature {NONE} -- Initialization

	make (tuple: TUPLE [color: NATURAL_8; width: INTEGER])
		require
			valid_color: valid_color (tuple.color)
		do
			color := tuple.color; width := tuple.width
		end

	make_2 (a_color: NATURAL_8; a_width: INTEGER)
		do
			color := a_color; width := a_width
		end

feature -- Access

	color: NATURAL_8

	color_name: STRING_8
		do
			Result := Color_enum.name (color)
		end

	out: STRING
		do
			Result := Color_width_string #$ [color_name, width]
		end

	width: INTEGER

feature -- Element change

	set_color (a_color: NATURAL_8)
		require
			valid_color: valid_color (a_color)
		do
			color := a_color
		end

	set_width (a_width: INTEGER)
		do
			width := a_width
		end

feature -- Status query

	is_color (a_color: NATURAL_8): BOOLEAN
		do
			Result := color = a_color
		end

	valid_color (a_color: NATURAL_8): BOOLEAN
		do
			Result := Color_enum.valid_value (a_color)
		end

feature {NONE} -- Constants

	Color_width_string: ZSTRING
		once
			Result := "color: %S; width %S"
		end
end