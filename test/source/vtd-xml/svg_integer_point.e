note
	description: "Summary description for {SVG_INTEGER_POINT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:02 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	SVG_INTEGER_POINT

inherit
	SINGLE_MATH

create
	make

feature {NONE} -- Initialization

	make (attributes: EL_ELEMENT_ATTRIBUTE_TABLE; subscript: INTEGER)
			--
		local
			x_name, y_name: STRING
		do
			create x_name.make_from_string ("x")
			x_name.append_integer (subscript)

			create y_name.make_from_string ("y")
			y_name.append_integer (subscript)

			x := attributes.integer (x_name)
			y := attributes.integer (y_name)
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