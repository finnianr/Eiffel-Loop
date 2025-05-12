note
	description: "Chain of strings conforming to ${READABLE_STRING_GENERAL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-12 8:34:42 GMT (Monday 12th May 2025)"
	revision: "2"

deferred class
	EL_READABLE_STRING_CHAIN [S -> READABLE_STRING_GENERAL create make end]

inherit
	EL_CHAIN [S]
		rename
			joined as joined_chain
		end

	PART_COMPARATOR [S]
		undefine
			copy, is_equal
		end

feature {NONE} -- Initialization

	make (n: INTEGER)
		deferred
		end

	make_empty
		deferred
		end

	make_from (container: CONTAINER [S])
		do
			if attached as_structure (container) as structure then
				make_from_special (structure.to_special)
			else
				make_empty
			end
		end

	make_from_special (a_area: SPECIAL [S])
		deferred
		end

feature -- Measurement

	item_count: INTEGER
		do
			Result := item.count
		end

	item_indent: INTEGER
		local
			i: INTEGER; done: BOOLEAN
		do
			from i := 1 until done or i > item.count loop
				if item [i] = '%T' then
					Result := Result + 1
				else
					done := True
				end
				i := i + 1
			end
		end

	longest_count: INTEGER
		-- count of longest string
		do
			push_cursor
			from start until after loop
				Result := Result.max (item.count)
				forth
			end
			pop_cursor
		end

feature -- Access

	first_or_empty: S
		do
			if count > 0 then
				Result := first
			else
				create Result.make (0)
			end
		end

	last_or_empty: S
		do
			if count > 0 then
				Result := last
			else
				create Result.make (0)
			end
		end

feature -- Status query

	is_indented: BOOLEAN
		-- `True' if all non-empty lines start with a tab character
		 do
		 	Result := across Current as str all
		 		str.item.count > 0 implies str.item.starts_with (tabulation)
		 	end
		 end

	same_items (a_list: ITERABLE [S]): BOOLEAN
		local
			l_cursor: ITERATION_CURSOR [S]
		do
			push_cursor
			if Iterable.count (a_list) = count then
				Result := True
				from start; l_cursor := a_list.new_cursor until after or not Result loop
					Result := item ~ l_cursor.item
					forth; l_cursor.forth
				end
			end
			pop_cursor
		end

feature -- Basic operations

	sort (in_ascending_order: BOOLEAN)
		local
			quick: QUICK_SORTER [S]
		do
			create quick.make (Current)

			if in_ascending_order then
				quick.sort (Current)
			else
				quick.reverse_sort (Current)
			end
		end

feature -- Element change

	set_first_and_last (a_first, a_last: S)
		do
			if count = 0 then
				extend (a_first); extend (a_last)
			else
				put_i_th (a_first, 1)
				if count = 1 then
					extend (a_last)
				else
					put_i_th (a_last, count)
				end
			end
		ensure
			set: first = a_first and last = a_last
		end

feature -- Removal

	prune_all_empty
			-- Remove empty items
		do
			from start until after loop
				if item.is_empty then
					remove
				else
					forth
				end
			end
		end

	unique_sort
		-- ascending sort removing duplicates
		local
			previous: like item
		do
			sort (True)
			from start until after loop
				if index = 1 then
					previous := item
					forth

				elseif item ~ previous then
					remove
				else
					previous := item
					forth
				end
			end
		end

feature -- Resizing

	grow (i: INTEGER)
			-- Change the capacity to at least `i'.
		deferred
		end

feature -- Contract Support

	valid_adjustments (bitmap: INTEGER): BOOLEAN
		do
			Result := 0 <= bitmap and then bitmap <= {EL_SIDE}.Both
		end

feature {NONE} -- Implementation

	less_than (u, v: S): BOOLEAN
		do
			Result := u.is_less (v)
		end

feature {NONE} -- Deferred

	tabulation: STRING
		deferred
		end
end