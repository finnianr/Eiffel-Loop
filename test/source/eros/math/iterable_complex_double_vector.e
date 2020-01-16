note
	description: "Vector complex double sequence"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-16 14:38:49 GMT (Thursday 16th January 2020)"
	revision: "6"

class
	ITERABLE_COMPLEX_DOUBLE_VECTOR

inherit
	ITERABLE [COMPLEX_DOUBLE]

create
	make

feature {NONE} -- Initialization

	make (a_vector: like vector)
			--
		do
			vector := a_vector
		end

feature {NONE} -- Implementation

	new_cursor: VECTOR_COMPLEX_DOUBLE_ITERATION_CURSOR
		do
			create Result.make (vector)
		end

	vector: VECTOR_COMPLEX_DOUBLE

end
