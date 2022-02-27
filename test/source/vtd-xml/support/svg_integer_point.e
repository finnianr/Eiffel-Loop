note
	description: "Svg integer point"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-25 10:29:07 GMT (Friday 25th February 2022)"
	revision: "5"

class
	SVG_INTEGER_POINT

inherit
	SINGLE_MATH

create
	make

feature {NONE} -- Initialization

	make (node: EL_XPATH_NODE_CONTEXT; subscript: INTEGER)
			--
		local
			x_name, y_name: STRING
		do
			x_name := "x"
			x_name.append_integer (subscript)

			y_name := "y"
			y_name.append_integer (subscript)

			x := node [x_name]
			y := node [y_name]
		end

feature -- Access

	x, y: INTEGER

feature -- Measurement

	distance (other: SVG_INTEGER_POINT): INTEGER
			--
		local
			x_distance, y_distance: INTEGER
		do
			x_distance := x - other.x
			y_distance := y - other.y
			Result := sqrt ((x_distance * x_distance - y_distance * y_distance).abs).rounded
		end

end