note
	description: "Cursor for `target' string sections split by string or character separator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-26 12:51:59 GMT (Friday 26th November 2021)"
	revision: "1"

deferred class
	EL_ITERABLE_SPLIT_CURSOR [S -> READABLE_STRING_GENERAL create make end, G]

inherit
	ITERATION_CURSOR [S]

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
		-- shared substring of `target' at current split position
		-- use `item_copy' if you intend to keep the reference in a list
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

feature -- Basic operations

	append_item_to (general: STRING_GENERAL)
		do
			general.append (item)
		end

	fill_with_item (general: STRING_GENERAL)
		do
			general.keep_head (0)
			general.append (item)
		end

feature -- Status query

	after: BOOLEAN
		-- Are there no more items to iterate over?

	left_adjusted: BOOLEAN

	right_adjusted: BOOLEAN

	skip_empty: BOOLEAN

feature -- Cursor movement

	forth
		-- Move to next position.
		local
			previous_separator_end: INTEGER; found_first: BOOLEAN
		do
			if end_reached then
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
					end_reached := True
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
					if end_reached then
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

	end_reached: BOOLEAN

	internal_item: like target

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