note
	description: "Cursor for `target' string sections split by separator of type **G**"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-15 12:13:18 GMT (Saturday 15th March 2025)"
	revision: "13"

deferred class
	EL_ITERABLE_SPLIT_CURSOR [S -> READABLE_STRING_GENERAL, G]

inherit
	ITERATION_CURSOR [S]
		rename
			item as item_copy
		end

	EL_LIST_ITEM_SUBSTRING_CONVERSION

feature {NONE} -- Initialization

	initialize
		do
		end

	make (a_target: like target; a_separator: like separator; left_adjust, right_adjust: BOOLEAN)
		do
			target := a_target; separator := a_separator
			left_adjusted := left_adjust; right_adjusted := right_adjust
			initialize
			forth
		end

feature -- Access

	cursor_index: INTEGER

	item: like target
		-- dynamic singular substring of `target' at current split position if the
		-- `target' conforms to `STRING_GENERAL' else the value of `item_copy'
		-- use `item_copy' if you intend to keep a reference to `item' beyond the scope of the
		-- client routine
		do
			if attached {STRING_GENERAL} target as l_target then
				if attached {STRING_GENERAL} internal_item as l_item then
					l_item.keep_head (0)
					l_item.append_substring (l_target, item_lower, item_upper)
					Result := internal_item
				else
					Result := item_copy
					internal_item := Result
				end
			else
				Result := item_copy
			end
		end

	item_copy: like target
		-- new substring of `target' at current split position
		do
			Result := target.substring (item_lower, item_upper)
		end

	item_count: INTEGER
		do
			Result := item_upper - item_lower + 1
		end

	item_index_of (uc: CHARACTER_32; start_index: INTEGER): INTEGER
		local
			i: INTEGER
		do
			if start_index <= item_count then
				from i := item_lower + start_index - 1 until i > item_upper or else Result > 0 loop
					if target [i] = uc then
						Result := i - item_lower + 1
					end
					i := i + 1
				end
			end
		end

	item_upper: INTEGER
		-- end index of `item' in `target' string

	item_lower: INTEGER
		-- start index of `item' in `target' string

feature -- Optimized operations

	append_item_to (general: STRING_GENERAL)
		-- equivalent to appending `item' to `general'
		do
			general.append_substring (target, item_lower, item_upper)
		end

	fill_with_item (general: STRING_GENERAL)
		-- equivalent to `general.replace_substring (1, general.count, item)' even
		-- though routine `replace_substring' on exists in descendants
		do
			general.keep_head (0)
			general.append_substring (target, item_lower, item_upper)
		end

	sink_item_to (sink: EL_DATA_SINKABLE)
		do
		end

feature -- Status query

	after: BOOLEAN
		-- Are there no more items to iterate over?

	is_last: BOOLEAN
		-- `True' if cursor is currently on the last `item'

	item_has (uc: CHARACTER_32): BOOLEAN
		local
			i: INTEGER
		do
			if attached target as l_target then
				from i := item_lower until i > item_upper or else Result loop
					Result := is_i_th_character (l_target, i, uc)
					i := i + 1
				end
			end
		end

	item_is_empty: BOOLEAN
		do
			Result := item_upper < item_lower
		end

	item_same_as (str: like target): BOOLEAN
		do
			if item_upper - item_lower + 1 = str.count then
				if str.count = 0 then
					Result := item_upper + 1 = item_lower
				else
					Result := same_characters (target, str, 1, str.count, item_lower)
				end
			end
		end

	item_same_caseless_as (str: like target): BOOLEAN
		do
			if item_upper - item_lower + 1 = str.count then
				if str.count = 0 then
					Result := item_upper + 1 = item_lower
				else
					Result := same_caseless_characters (target, str, 1, str.count, item_lower)
				end
			end
		end

	item_starts_with (str: like target): BOOLEAN
		do
			if str.count = 0 then
				Result := True
			elseif item_upper - item_lower + 1 >= str.count then
				Result := same_characters (target, str, 1, str.count, item_lower)
			end
		end

	left_adjusted: BOOLEAN

	right_adjusted: BOOLEAN

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
					item_lower := previous_separator_end + 1
					item_upper := separator_start - 1
				else
					item_lower := separator_end + 1
					item_upper := target.count
					is_last := True
				end
				if left_adjusted and then attached target as l_target then
					from until found_first or else item_lower > item_upper loop
						if is_i_th_white_space (l_target, item_lower) then
							item_lower := item_lower + 1
						else
							found_first := True
						end
					end
				end
				if right_adjusted and then attached target as l_target then
					found_first := False
					from until found_first or else item_upper < item_lower  loop
						if is_i_th_white_space (l_target, item_upper) then
							item_upper := item_upper - 1
						else
							found_first := True
						end
					end
				end
				cursor_index := cursor_index + 1
			end
		end

feature {NONE} -- Implementation

	is_i_th_white_space (a_target: like target; i: INTEGER): BOOLEAN
		-- `True' if i'th character of `a_target' is white space
		local
			c32: EL_CHARACTER_32_ROUTINES
		do
			Result := c32.is_space (a_target [i])
		end

	is_i_th_character (a_target: like target; i: INTEGER; uc: CHARACTER_32): BOOLEAN
		-- `True' if i'th character of `a_target' is equal to `uc'
		do
			Result := a_target [i] = uc
		end

 	same_caseless_characters (a_target, other: like target; start_pos, end_pos, index_pos: INTEGER): BOOLEAN
			-- Are characters of `other' within bounds `start_pos' and `end_pos'
			-- caseless identical to characters of current string starting at index `index_pos'.
		do
			Result := a_target.same_caseless_characters (other, start_pos, end_pos, index_pos)
		end

 	same_characters (a_target, other: like target; start_pos, end_pos, index_pos: INTEGER): BOOLEAN
			-- Are characters of `other' within bounds `start_pos' and `end_pos'
			-- identical to characters of current string starting at index `index_pos'.
		do
			Result := a_target.same_characters (other, start_pos, end_pos, index_pos)
		end

	set_separator_start
		deferred
		end

feature {NONE} -- Internal attributes

	internal_item: detachable like target

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