note
	description: "[
		List of items iterable by [https://www.geeksforgeeks.org/iterators-c-stl/ standard C++ iterators]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	EL_CPP_STD_LIST [C -> EL_CPP_STD_ITERATION_CURSOR [G] create make end, G]

inherit
	ITERABLE [G]

create
	make

feature {NONE} -- Initialization

	make (a_iterator_begin, a_iterator_end: like iterator_begin)
			--
		do
			iterator_begin := a_iterator_begin; iterator_end := a_iterator_end
		end

feature -- Access

	new_cursor: C
		do
			iterator_begin.apply; iterator_end.apply
			create Result.make (iterator_begin.last_result, iterator_end.last_result)
		end

feature {NONE} -- Internal attributes

	iterator_begin: FUNCTION [POINTER]

	iterator_end: FUNCTION [POINTER]

end