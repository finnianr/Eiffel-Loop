note
	description: "Integer coordinate"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-27 12:54:24 GMT (Saturday 27th January 2024)"
	revision: "3"

class
	EL_INTEGER_COORDINATE

create
	make, default_create

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

	set (a_x, a_y: INTEGER)
		do
			make (a_x, a_y)
		end
		
end