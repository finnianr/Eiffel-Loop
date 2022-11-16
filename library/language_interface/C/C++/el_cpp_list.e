note
	description: "Iterable list of C++ objects conforming to [$source EL_CPP_OBJECT]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_CPP_LIST [C -> EL_CPP_ITERATION_CURSOR [G] create make end, G -> EL_CPP_OBJECT]

inherit
	ITERABLE [G]

create
	make

feature {NONE} -- Initialization

	make (a_cpp_iterator: like cpp_iterator)
			--
		do
			cpp_iterator := a_cpp_iterator
		end

feature -- Access

	new_cursor: C
		do
			cpp_iterator.apply
			create Result.make (cpp_iterator.last_result)
		end

feature {NONE} -- Internal attributes

	cpp_iterator: FUNCTION [POINTER]

end