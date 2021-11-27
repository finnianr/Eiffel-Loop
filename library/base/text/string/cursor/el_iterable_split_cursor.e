note
	description: "Cursor for `target' string sections split by separator of type **G**"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-27 19:03:08 GMT (Saturday 27th November 2021)"
	revision: "2"

deferred class
	EL_ITERABLE_SPLIT_CURSOR [S -> READABLE_STRING_GENERAL create make end, G]

inherit
	ITERATION_CURSOR [S]
		rename
			item as item_copy
		end

feature {NONE} -- Initialization

	make (a_target: like target; a_separator: like separator; left_adjust, right_adjust, a_skip_empty: BOOLEAN)
		do
			target := a_target; separator := a_separator
			left_adjusted := left_adjust; right_adjusted := right_adjust; skip_empty := a_skip_empty
			initialize
			forth
		end

	initialize
		do
		end

feature -- Access

	item: S
		-- dynamic singular substring of `target' at current split position if the
		-- `target' conforms to `STRING_GENERAL' else the value of `item_copy'
		-- use `item_copy' if you intend to keep a reference to `item' beyond the scope of the
		-- client routine
		do
			if attached {STRING_GENERAL} target as l_target then
				if attached {STRING_GENERAL} internal_item as l_item then
					l_item.keep_head (0)
					l_item.append_substring (l_target, item_start_index, item_end_index)
					Result := internal_item
				else
					Result := item_copy
					internal_item := Result
				end
			else
				Result := item_copy
			end
		end

	item_copy: S
		-- new substring of `target' at current split position
		do
			Result := target.substring (item_start_index, item_end_index)
		end

feature -- Optimized operations

	append_item_to (general: STRING_GENERAL)
		-- equivalent to appending `item' to `general'
		do
			general.append_substring (target, item_start_index, item_end_index)
		end

	fill_with_item (general: STRING_GENERAL)
		-- equivalent to `general.replace_substring (1, general.count, item)' even
		-- though routine `replace_substring' on exists in descendants
		do
			general.keep_head (0)
			general.append_substring (target, item_start_index, item_end_index)
		end

feature -- Status query

	after: BOOLEAN
		-- Are there no more items to iterate over?

	is_last: BOOLEAN
		-- `True' if cursor is currently on the last `item'

	item_starts_with (str: S): BOOLEAN
		do
			if item_end_index - item_start_index + 1 >= str.count then
				Result := target.same_characters (str, 1, str.count, item_start_index)
			end
		end

	item_has (uc: CHARACTER_32): BOOLEAN
		local
			i: INTEGER
		do
			from i := item_start_index until i > item_end_index or else Result loop
				Result := target [i] = uc
				i := i + 1
			end
		end

	left_adjusted: BOOLEAN

	right_adjusted: BOOLEAN

	skip_empty: BOOLEAN

feature -- Cursor movement

	forth
		-- Move cursor to next position.
		local
			previous_separator_end: INTEGER; found_first: BOOLEAN
		do
			if is_last then
				after := True
			else
				previous_separator_end := separator_end
				set_separator_start
				if separator_start > 0 then
					separator_end := separator_start + separator_count - 1
					item_start_index := previous_separator_end + 1
					item_end_index := separator_start - 1
				else
					item_start_index := separator_end + 1
					item_end_index := target.count
					is_last := True
				end
				if left_adjusted and then attached target as l_target then
					from until found_first or else item_start_index > item_end_index loop
						if is_white_space (l_target, item_start_index) then
							item_start_index := item_start_index + 1
						else
							found_first := True
						end
					end
				end
				if right_adjusted and then attached target as l_target then
					found_first := False
					from until found_first or else item_end_index < item_start_index  loop
						if is_white_space (l_target, item_end_index) then
							item_end_index := item_end_index - 1
						else
							found_first := True
						end
					end
				end
				if skip_empty and then item_end_index < item_start_index then
					if is_last then
						after := True
					else
						forth
					end
				end
			end
		end

feature {NONE} -- Implementation

	is_white_space (a_target: like target; i: INTEGER): BOOLEAN
		do
			Result := a_target [i].is_space
		end

	set_separator_start
		deferred
		end

feature {NONE} -- Internal attributes

	internal_item: detachable like target

	item_end_index: INTEGER

	item_start_index: INTEGER

	separator: G

	separator_count: INTEGER
		deferred
		end

	separator_end: INTEGER
		-- end index of separator

	separator_start: INTEGER
		-- start index of separator

	target: S

end