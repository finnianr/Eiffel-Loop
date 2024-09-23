note
	description: "[
		Iteration cursor for ${EL_HASH_TABLE [ANY, HASHABLE]} to fix problem with `cursor_index'
		when items have been deleted
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-23 10:10:46 GMT (Monday 23rd September 2024)"
	revision: "8"

class
	EL_HASH_TABLE_ITERATION_CURSOR [G, K -> detachable HASHABLE]

inherit
	HASH_TABLE_ITERATION_CURSOR [G, K]
		rename
			iteration_position as position_index
		redefine
			after, cursor_index, item, key, make, start, forth, target
		end

create
	make

feature {NONE} -- Initialization

	make (t: like target)
		local
			pos, pos_upper: INTEGER; break: BOOLEAN
		do
			Precursor (t)
			keys := t.keys; content := t.content
			create positions_array.make_empty (t.count)
			if attached t.deleted_marks as is_deleted then
				pos_upper := content.count - 1
				from pos := -1 until break loop
					pos := t.next_iteration_index (pos, pos_upper, is_deleted)
					if pos > pos_upper then
						break := True
					else
						positions_array.extend (pos)
					end
				end
			end
		end

feature -- Access

	item: G
			-- <Precursor>
		do
			Result := content [positions_array [position_index]]
		end

	key: K
			-- Key at current cursor position
		do
			Result := keys [positions_array [position_index]]
		end

	cursor_index: INTEGER
			-- <Precursor>
		do
			Result := if is_reversed then first_index - position_index + 1 else position_index + 1 end
		end

	value_key_pair: TUPLE [value: G; key: K]
		do
			Result := [item, key]
		end

feature -- Status report

	after: BOOLEAN
			-- <Precursor>
		do
			Result := position_index > last_index or position_index < 0
		end

feature -- Cursor movement

	start
		do
			if is_reversed then
				first_index := target.count - 1
				last_index := 0
			else
				first_index := 0
				last_index := target.count - 1
			end
			position_index := first_index
		end

	forth
			-- <Precursor>
		do
			position_index := position_index + (not is_reversed).to_integer
		end

feature {NONE} -- Internal attributes

	positions_array: SPECIAL [INTEGER]

	content: like target.content

	keys: like target.keys

	target: EL_HASH_TABLE [G, K]
end