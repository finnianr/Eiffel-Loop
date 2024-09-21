note
	description: "${ITERATION_CURSOR} for ${EL_HASH_SET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-21 11:12:56 GMT (Saturday 21st September 2024)"
	revision: "1"

class
	EL_HASH_SET_ITERATION_CURSOR [K -> HASHABLE]

inherit
	ITERATION_CURSOR [K]

create
	make

feature {NONE} -- Initialization

	make (a_target: like target)
			-- Initialize current with `a_target'.
		do
			target := a_target
			iteration_position := a_target.next_iteration_position (-1)
			last_index := a_target.capacity - 1
		ensure
			target_set: target = a_target
		end

feature -- Access

	item: K
			-- <Precursor>
		do
			check attached target.content.item (iteration_position) as l_item then
				Result := l_item
			end
		end

feature -- Status report

	after: BOOLEAN
			-- <Precursor>
		do
			Result := iteration_position > last_index
		end

feature -- Cursor movement

	forth
			-- <Precursor>
		do
			iteration_position := target.next_iteration_position (iteration_position)
		end

feature {NONE} -- Access

	last_index: INTEGER

	iteration_position: INTEGER
			-- Current position in traversal of `target'.

	target: EL_HASH_SET [K];
			-- Associated structure used for iteration.

end