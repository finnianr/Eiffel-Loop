note
	description: "Vector complex double sequence"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-21 11:01:39 GMT (Tuesday 21st January 2020)"
	revision: "8"

class
	ITERABLE_COMPLEX_64_VECTOR

inherit
	ITERABLE [COMPLEX_64]

create
	make

feature {NONE} -- Initialization

	make (a_vector: like vector)
			--
		do
			vector := a_vector
		end

feature {NONE} -- Implementation

	new_cursor: VECTOR_COMPLEX_64_ITERATION_CURSOR
		do
			create Result.make (vector)
		end

	vector: VECTOR_COMPLEX_64

end
