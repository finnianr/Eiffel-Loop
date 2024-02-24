note
	description: "${EL_INTEGER_COORDINATE} of cell on a grid initializeable by tuple [column, row]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-02-24 15:27:35 GMT (Saturday 24th February 2024)"
	revision: "2"

class
	EL_GRID_COORDINATE

inherit
	EL_INTEGER_COORDINATE
		rename
			x as column, y as row
		end

create
	make, make_tuple, default_create

convert
	make_tuple ({TUPLE [INTEGER, INTEGER]})

end