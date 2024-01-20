note
	description: "List of ${INTEGER_32} tokens representing a path step"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "3"

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