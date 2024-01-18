note
	description: "List of ${INTEGER_32} tokens representing a path step"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_STEP_TOKEN_LIST

inherit
	ARRAYED_LIST [INTEGER]
		export
			{EL_PATH_STEPS_IMPLEMENTATION} set_area, sequential_index_of
		end

create
	make
end