note
	description: "Iterate over `NATURAL_8' frame codes defined by [$source IL_FRAME_CODE_ENUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-10 16:10:07 GMT (Sunday 10th November 2019)"
	revision: "1"

class
	TL_ID3_FRAME_CODE_LIST

inherit
	ITERABLE [NATURAL_8]

create
	make

feature {NONE} -- Initialization

	make (a_iterator_begin, a_iterator_end: like iterator_begin)
			--
		do
			iterator_begin := a_iterator_begin; iterator_end := a_iterator_end
		end

feature -- Access

	new_cursor: TL_ID3_FRAME_CODE_ITERATION_CURSOR
		do
			iterator_begin.apply; iterator_end.apply
			create Result.make (iterator_begin.last_result, iterator_end.last_result)
		end

feature {NONE} -- Internal attributes

	iterator_begin: FUNCTION [POINTER]

	iterator_end: FUNCTION [POINTER]

end
