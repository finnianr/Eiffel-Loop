note
	description: "Iteration cursor for [$source EL_ARRAYED_MAP_LIST]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-27 18:38:35 GMT (Monday 27th March 2023)"
	revision: "1"

class
	EL_ARRAYED_MAP_ITERATION_CURSOR [K, G]

inherit
	ARRAYED_LIST_ITERATION_CURSOR [K]
		rename
			item as key
		redefine
			make, target
		end

create
	make

feature {NONE} -- Initialization

	make (a_target: like target)
		do
			Precursor (a_target)
			value_area := a_target.internal_value_list.area_v2
		end

feature -- Access

	value: G
		do
			Result := value_area [area_index]
		end

feature {NONE} -- Internal attributes

	target: EL_ARRAYED_MAP_LIST [K, G]

	value_area: SPECIAL [G]

end