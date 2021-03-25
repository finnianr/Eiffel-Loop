note
	description: "[
		Iteration cursor for {HASH_TABLE} to fix problem with `cursor_index' when items have been deleted
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_HASH_TABLE_ITERATION_CURSOR [G, K -> detachable HASHABLE]

inherit
	HASH_TABLE_ITERATION_CURSOR [G, K]
		redefine
			cursor_index, start, forth
		end

create
	make

feature -- Access

	cursor_index: INTEGER
			-- <Precursor>
		do
			Result := Precursor - deleted_skip_count
		end

feature -- Cursor movement

	start
		do
			Precursor
			deleted_skip_count := 0
		end

	forth
			-- <Precursor>
		local
			i, nb: like step
			l_pos, previous_pos, next_pos: like iteration_position
		do
			l_pos := iteration_position
			nb := step
			if is_reversed then
				from
					i := 1
				until
					i > nb or else l_pos < 0
				loop
					previous_pos := target.previous_iteration_position (l_pos)
					if l_pos - previous_pos > 1 then
						deleted_skip_count := deleted_skip_count + ((l_pos - 1) - previous_pos)
					end
					l_pos := previous_pos
					i := i + 1
				end
			else
				from
					i := 1
				until
					i > nb or else l_pos >= target.keys.count
				loop
					next_pos := target.next_iteration_position (l_pos)
					if next_pos - l_pos > 1 then
						deleted_skip_count := deleted_skip_count + ((next_pos - 1) - l_pos)
					end
					l_pos := next_pos
					i := i + 1
				end
			end
			iteration_position := l_pos
		end

feature {NONE} -- Internal attributes

	deleted_skip_count: INTEGER
		-- count of deleted items that have been skipped
end
