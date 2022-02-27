note
	description: "Svg point"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-25 10:30:52 GMT (Friday 25th February 2022)"
	revision: "5"

class
	SVG_POINT

inherit
	DOUBLE_MATH

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

	x, y: DOUBLE

feature -- Measurement

	distance (other: SVG_POINT): DOUBLE
			--
		do
			Result := sqrt (dabs ( (x - other.x) ^ 2.0 - (y - other.y) ^ 2.0))
		end

end