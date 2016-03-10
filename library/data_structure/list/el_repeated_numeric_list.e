note
	description: "[
		Object that uses run length encoding to data compress a sequence of numeric values that tend to repeat a lot.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "2"

class
	EL_REPEATED_NUMERIC_LIST [G -> NUMERIC]

inherit
	LIST [G]
		export
			{NONE} all
			{ANY} item, readable, off, before, after, go_i_th, valid_cursor_index
		redefine
			start, finish, go_i_th, move
		end

create
	make

feature {NONE} -- Initialization

	make (repeated_item_count: INTEGER)
			-- Create an empty list.
		do
			create compact_list.make (repeated_item_count)
		end

feature -- Access

	item: G
			-- Current item
		do
			Result := compact_list.item.value
		end

	index: INTEGER

	count: INTEGER

	compact_count: INTEGER
			--
		do
			Result := compact_list.count
		end

feature -- Status report

	extendible: BOOLEAN
			-- May new items be added? (Answer: yes.)
		do
			Result := true
		end

	prunable: BOOLEAN
			-- May items be removed? (Answer: yes.)
		do
			Result := False
		end

	full: BOOLEAN = False

feature -- Cursor movement

	start
			-- Move cursor to first position.
			-- (No effect if empty)
		do
			if not compact_list.is_empty then
				compact_list.start
				index := 1
				repeat_offset := 1
			end
		end

	finish
			-- Move cursor to last position.
			-- (No effect if empty)
		do
			if not compact_list.is_empty then
				index := count
				compact_list.finish
				repeat_offset := compact_list.item.count
			end
		end

	back
			--
		do
			if not compact_list.off then
				repeat_offset := repeat_offset - 1
				index := index - 1
				if repeat_offset = 0 then
					compact_list.back
					if not compact_list.before then
						repeat_offset := compact_list.item.count
					end
				end
			end
		end

	forth
			--
		do
			if not compact_list.off then
				repeat_offset := repeat_offset + 1
				index := index + 1
				if repeat_offset > compact_list.item.count then
					compact_list.forth
					if not compact_list.after then
						repeat_offset := 1
					end
				end
			end
		end

	go_i_th (i: INTEGER_32)
			--
		do
			if index = 0 or i = 1 then
				start
			end
			if i > 1 then
				Precursor (i)
			end
		end

	move (i: INTEGER)
			-- Move cursor `i' positions. The cursor
			-- may end up `off' if the absolute value of `i'
			-- is too big.
		local
			delta: INTEGER
		do
			if i > 0 then
				from
					delta := i
				until
					compact_list.after or else delta <= (compact_list.item.count - repeat_offset)
				loop
					delta := delta - (compact_list.item.count - repeat_offset + 1)
					index := index + (compact_list.item.count - repeat_offset + 1)
					compact_list.forth
					repeat_offset := 1
				end
				Precursor (delta)

			elseif i < 0 then
				from
					delta := i.abs
				until
					compact_list.before or else delta < repeat_offset
				loop
					delta := delta - repeat_offset
					index := index - repeat_offset
					compact_list.back
					if not compact_list.before then
						repeat_offset := compact_list.count
					end
				end
				Precursor (-delta)
				if index < 0 then
					index := 0
				end
			end
		end

feature -- Iteration

	repeated_numerics_do_all (action: PROCEDURE [ANY, TUPLE [EL_REPEATED_NUMERIC [G]]])
			--
		do
			compact_list.do_all (action)
		end

feature -- Element change

	extend (v: like item)
			-- Add `v' to end.
			-- Do not move cursor.
		do
			if not compact_list.is_empty and then v = compact_list.last.value and then
				not compact_list.last.maximum_reached
			then
				compact_list.last.increment
			else
				compact_list.extend (create {EL_REPEATED_NUMERIC [G]}.make (v))
			end
			count := count + 1
		end

	extend_repeated_numeric (repeated_numeric: EL_REPEATED_NUMERIC [G])
			--
		do
			compact_list.extend (repeated_numeric)
			count := count + repeated_numeric.count
		end

	wipe_out
			-- Remove all items.
		do
			compact_list.wipe_out
			count := 0
			repeat_offset := 0
			index := 0
		end

feature {NONE} -- Unused

	valid_cursor (p: CURSOR): BOOLEAN
			--
		do
		end

	cursor: CURSOR

	replace (v: like item)
			-- Replace current item by `v'.
		do
		end

	duplicate (n: INTEGER): like Current
			--
		do
		end

	go_to (p: CURSOR)
			--
		do
		end


feature {NONE} -- Implementation

	repeat_offset: INTEGER

	compact_list: ARRAYED_LIST [EL_REPEATED_NUMERIC [G]]

end
