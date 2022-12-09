note
	description: "[
		Iteration cursor for [$source HASH_TABLE [ANY, HASHABLE]] to fix problem with `cursor_index'
		when items have been deleted
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-09 9:38:30 GMT (Friday 9th December 2022)"
	revision: "5"

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
			Result := ((iteration_position - first_index - deleted_skip_count).abs + step - 1) // step + 1
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