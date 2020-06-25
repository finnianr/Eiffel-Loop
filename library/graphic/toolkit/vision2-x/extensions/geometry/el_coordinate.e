note
	description: "Hashable coordinate"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-25 10:29:13 GMT (Thursday 25th June 2020)"
	revision: "1"

class
	EL_COORDINATE

inherit
	EV_COORDINATE

	HASHABLE

create
	default_create, make, make_with_position, make_precise, set

feature -- Access

	hash_code: INTEGER
		do
			Result := (x & 0xFFFF) |<< 16 | (y & 0xFFFF)
		end

	plus alias "+" (delta: TUPLE [x, y: DOUBLE]): like Current
		do
			create Result.make_precise (x_precise + delta.x, y_precise + delta.y)
		end

	minus alias "-" (delta: TUPLE [x, y: DOUBLE]): like Current
		do
			create Result.make_precise (x_precise - delta.x, y_precise - delta.y)
		end

end
