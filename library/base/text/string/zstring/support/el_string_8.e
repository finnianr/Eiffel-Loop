note
	description: "String 8"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-29 15:21:56 GMT (Sunday   29th   September   2019)"
	revision: "1"

class
	EL_STRING_8

inherit
	STRING_8
		rename
			make as make_with_count
		end

create
	make, make_empty

feature {NONE} -- Initialization

	make (zstr: EL_ZSTRING_IMPLEMENTATION)
		do
			set_area_and_count (zstr.area, zstr.count)
		end

feature -- Element change

	set_area_and_count (a_area: like area; a_count: INTEGER)
		do
			area := a_area
			count := a_count
		end

	set_from_c (c_string: POINTER)
		do
			make_from_c (c_string)
		end

end
