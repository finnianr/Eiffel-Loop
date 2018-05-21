note
	description: "Column vector double"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:03 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_COLUMN_VECTOR_DOUBLE

inherit
	EL_COLUMN_VECTOR [DOUBLE]
		redefine
			divide
		end

create
	make, make_from_array

feature -- Basic operations

	power alias "^" (exponent: DOUBLE): like Current
			--
		local
			i: INTEGER
		do
			create Result.make (count)
			from i := 1 until i > count loop
				Result [i] := item (i) ^ exponent
				i := i + 1
			end
		end

	divide (divisor: DOUBLE)
			--
		local
			i: INTEGER
			l_item: DOUBLE
		do
			from i := lower until i > upper loop
				l_item := item (i)
				put (l_item / divisor, i)
				i := i + 1
			end
		end

end