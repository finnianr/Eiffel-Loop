note
	description: "Integer coordinate"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-21 11:16:26 GMT (Friday 21st August 2020)"
	revision: "1"

class
	EL_INTEGER_COORDINATE

create
	make

feature {NONE} -- Initialization

	make (a_x, a_y: INTEGER)
		do
			x := a_x; y := a_y
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
end
