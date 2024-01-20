note
	description: "Iteration cursor for ${EL_ARRAYED_MAP_LIST}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "3"

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