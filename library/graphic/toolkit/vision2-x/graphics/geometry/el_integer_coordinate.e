note
	description: "Integer coordinate"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-02-10 17:40:27 GMT (Saturday 10th February 2024)"
	revision: "4"

class
	EL_INTEGER_COORDINATE

create
	make, make_tuple, default_create

convert
	make_tuple ({TUPLE [INTEGER, INTEGER]})

feature {NONE} -- Initialization

	make (a_x, a_y: INTEGER)
		do
			x := a_x; y := a_y
		end

	make_tuple (tuple: TUPLE [x, y: INTEGER])
		do
			make (tuple.x, tuple.y)
		end

feature -- Access

	x: INTEGER

	y: INTEGER

feature -- Element change

	move (delta_x, delta_y: INTEGER)
		do
			x := x + delta_x
			y := y + delta_y
		end

	set (a_x, a_y: INTEGER)
		do
			make (a_x, a_y)
		end

end