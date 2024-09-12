note
	description: "Widget with width and color properties"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-12 14:36:35 GMT (Thursday 12th September 2024)"
	revision: "7"

class
	WIDGET

inherit
	ANY
	SHARED_COLOR_ENUM
		rename
			Color as Color_enum
		end

create
	make

convert
	make ({TUPLE [NATURAL_8, INTEGER]})

feature {NONE} -- Initialization

	make (tuple: TUPLE [color: NATURAL_8; width: INTEGER])
		do
			color := tuple.color
			width := tuple.width
		end

feature -- Access

	color: NATURAL_8

	color_name: STRING_8
		do
			Result := Color_enum.name (color)
		end

	width: INTEGER

feature -- Element change

	set_color (a_color: NATURAL_8)
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

end