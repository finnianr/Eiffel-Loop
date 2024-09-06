note
	description: "${HASH_TABLE_ITERATION_CURSOR} for ${EL_GROUPED_LIST_TABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-06 8:28:22 GMT (Friday 6th September 2024)"
	revision: "1"

class
	EL_GROUPED_LIST_TABLE_ITERATION_CURSOR [G, K -> detachable HASHABLE]

inherit
	HASH_TABLE_ITERATION_CURSOR [SPECIAL [G], K]
		rename
			item as item_area
		redefine
			target
		end

	EL_CONTAINER_HANDLER

create
	make

feature -- Access

	item: EL_ARRAYED_LIST [G]
		do
			Result := target.internal_list
			Result.set_area (item_area)
			Result := Result.twin
		end


feature {NONE} -- Internal attributes

	target: EL_GROUPED_LIST_TABLE [G, K]
end