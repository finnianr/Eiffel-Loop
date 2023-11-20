note
	description: "[
		An arrayed list abstraction of objects of type **R**, that are representations of a seed object of
		type **N**. Only the seed objects are actually stored and the representations are created on the fly
		during iteration. More often that not, the seed object will conform to a [$source NUMERIC type].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-20 19:01:16 GMT (Monday 20th November 2023)"
	revision: "1"

deferred class
	EL_ARRAYED_REPRESENTATION_LIST [R, N]

inherit
	EL_ARRAYED_LIST [R]
		export
			{NONE} all
			{ANY} forth, start, after, is_empty, extendible, lower, index, off, readable, valid_index
		redefine
			count, capacity, first, last, force, is_inserted, extend, item, make, upper, new_cursor
		end

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			create seed_area.make_empty (n)
			create area_v2.make_empty (0)
			index := 0
		end

feature -- Seed items

	first_seed: like seed_item
		require
			valid_cursor_pos: not off
		do
			Result := seed_area.item (0)
		end

	last_seed: like seed_item
		require
			valid_cursor_pos: not off
		do
			Result := seed_area.item (count - 1)
		end

	seed_item: N
		-- current seed item
		do
			Result := seed_area.item (index - 1)
		end

feature -- Items

	first: like item
			-- Item at first position
		do
			Result := to_representation (seed_area.item (0))
		end

	item: R
		-- current item
		do
			Result := to_representation (seed_area.item (index - 1))
		end

	last: like first
			-- Item at last position
		do
			Result := to_representation (seed_area.item (count - 1))
		end

feature -- Access

	new_cursor: EL_ARRAYED_REPRESENTATION_LIST_ITERATION_CURSOR [R, N]
			-- <Precursor>
		do
			create Result.make (Current)
		end

	seed_area: SPECIAL [N]

feature -- Measurement

	capacity: INTEGER
		do
			Result := seed_area.capacity
		end

	count: INTEGER
			-- Number of items.
		do
			Result := seed_area.count
		end

	upper: INTEGER
			-- Maximum index.
			-- Use `count' instead.
		do
			Result := seed_area.count
		end

feature -- Status query

	is_inserted (v: R): BOOLEAN
			-- Has `v' been inserted at the end by the most recent `put' or
			-- `extend'?
		do
			if not is_empty then
				Result := (to_seed (v) = last_seed) or else (not off and then (to_seed (v) = seed_item))
			end
		end

feature -- Element change

	extend_seed (v: like seed_item)
			-- Add `v' to end.
			-- Do not move cursor.
		local
			i: INTEGER; l_area: like seed_area
		do
			i := count + 1
			l_area := seed_area
			if i > l_area.capacity then
				l_area := l_area.aliased_resized_area (i + additional_space)
				seed_area := l_area
			end
			l_area.extend (v)
		end

	force, extend (v: like item)
			-- Add `v' to end.
			-- Do not move cursor.
		do
			extend_seed (to_seed (v))
		end

feature -- Conversion

	to_representation (seed: N): R
		deferred
		end

	to_seed (representation: R): N
		deferred
		end

end