note
	description: "Widget with weight and color properties"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-29 10:40:05 GMT (Wednesday 29th May 2024)"
	revision: "4"

class
	WIDGET

create
	make

convert
	make ({TUPLE [INTEGER, INTEGER]})

feature {NONE} -- Initialization

	make (tuple: TUPLE [INTEGER, INTEGER])
		do
			color := tuple.integer_32_item (1)
			weight := tuple.integer_32_item (2)
		end

feature -- Access

	color: INTEGER

	color_name: STRING
		local
			s: EL_STRING_8_ROUTINES
		do
			Result := s.selected (color, << Red, Blue, Green >>, once "Red, Blue, Green")
		end

	weight: INTEGER

feature -- Element change

	set_color (a_color: INTEGER)
		do
			color := a_color
		end

	set_weight (a_weight: INTEGER)
		do
			weight := a_weight
		end

feature -- Status query

	is_color (a_color: INTEGER): BOOLEAN
		do
			Result := color = a_color
		end

feature -- Constants

	Blue: INTEGER = 2

	Green: INTEGER = 3

	Red: INTEGER = 1

end