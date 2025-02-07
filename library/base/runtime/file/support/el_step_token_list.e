note
	description: "List of ${INTEGER_32} tokens representing a path step"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-07 16:51:18 GMT (Friday 7th February 2025)"
	revision: "4"

class
	EL_STEP_TOKEN_LIST

inherit
	ARRAYED_LIST [INTEGER]
		export
			{EL_PATH_STEPS_BASE} set_area, sequential_index_of
		end

create
	make
end