note
	description: "Chain of strings conforming to ${STRING_GENERAL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-30 13:50:44 GMT (Sunday 30th March 2025)"
	revision: "59"

deferred class
	EL_STRING_CHAIN [S -> STRING_GENERAL create make end]

inherit
	EL_READABLE_STRING_CHAIN [S]

	HASHABLE

	EL_LINEAR_STRINGS [S]
		undefine
			first, find_first_equal, search, has, occurrences, off
		end

	EL_MODULE_ITERABLE; EL_MODULE_CONVERT_STRING

	EL_STRING_GENERAL_ROUTINES_I

feature {NONE} -- Initialization

	make_from_substrings (a_string: READABLE_STRING_GENERAL; a_start_index: INTEGER; count_list: ITERABLE [INTEGER])
		-- make from consecutive substrings in `a_string' with counts in `count_list' starting from `a_start_index'
		do
			make_empty
			append_substrings (a_string, a_start_index, count_list)
		end

	make_comma_split (a_string: READABLE_STRING_GENERAL)
		do
			make_adjusted_split (a_string, ',', {EL_SIDE}.Left)
		end

	make_with_lines (a_string: READABLE_STRING_GENERAL)
		do
			make_split (a_string, '%N')
		end

	make_adjusted_split (a_string: READABLE_STRING_GENERAL; delimiter: CHARACTER_32; adjustments: INTEGER)
		require
			valid_adjustments: valid_adjustments (adjustments)
		do
			make_empty
			append_split (a_string, delimiter, adjustments)
		end

	make_split (a_string: READABLE_STRING_GENERAL; delimiter: CHARACTER_32)
		do
			make_empty
			append_split (a_string, delimiter, 0)
		end

	make_word_split (a_string: READABLE_STRING_GENERAL)
		do
			make_split (a_string, ' ')
		end

feature -- Format items

	indent (tab_count: INTEGER)
			-- prepend `tab_count' tab character to each line
		require
			valid_tab_count: tab_count >= 0
		local
			l_tab_string: like tab_string
		do
			if tab_count > 0 then
				push_cursor
				l_tab_string := tab_string (tab_count)
				from start until after loop
					item.prepend (l_tab_string)
					forth
				end
				pop_cursor
			end
		ensure
			indented: tab_count > 0 implies is_indented
		end

	indent_item (tab_count: INTEGER)
			-- prepend one tab character to each line
		require
			not_off: not off
			valid_tab_count: tab_count >= 0
		do
			if tab_count > 0 then
				item.prepend (tab_string (tab_count))
			end
		ensure
			tab_count_extra: old item_indent + tab_count = item_indent
		end

	left_adjust
		-- left adjust all lines
		do
			push_cursor
			from start until after loop
				item.left_adjust
				forth
			end
			pop_cursor
		end

	right_pad (column_widths: ARRAY [INTEGER])
		do
			push_cursor
			from start until after or else index > column_widths.upper loop
				from until item_count >= column_widths [index] loop
					item.append_code (32)
				end
				forth
			end
			pop_cursor
		end

	right_adjust
		do
			push_cursor
			from start until after loop
				item.right_adjust
				forth
			end
			pop_cursor
		end

	unindent (tab_count: INTEGER)
		-- remove maximum of `tab_count' tab characters from the start of each line `item'
		require
			is_indented: is_indented
		local
			smaller_count: INTEGER
		do
			push_cursor
			from start until after loop
				smaller_count := tab_count.min (item_indent)
				if smaller_count > 0 then
					item.keep_tail (item.count - smaller_count)
				end
				forth
			end
			pop_cursor
		end

	wrap (line_width: INTEGER)
		local
			previous_item: S
		do
			push_cursor
			if not is_empty then
				from start; forth until after loop
					previous_item := i_th (index - 1)
					if (previous_item.count + item.count + 1) < line_width then
						previous_item.append_code (32)
						previous_item.append (item)
						remove
					else
						forth
					end
				end
			end
			pop_cursor
		end

feature -- Element change

	append_comma_separated (a_string: READABLE_STRING_GENERAL)
		do
			append_split (a_string, ',', {EL_SIDE}.Left)
		end

	append_split (a_string: READABLE_STRING_GENERAL; delimiter: CHARACTER_32; adjustments: INTEGER)
		require
			valid_adjustments: valid_adjustments (adjustments)
		do
			if attached Split_intervals as intervals then
				intervals.wipe_out
				intervals.fill (a_string, delimiter, adjustments)
				append_intervals (a_string, intervals)
			end
		end

	append_substrings (a_string: READABLE_STRING_GENERAL; a_start_index: INTEGER; count_list: ITERABLE [INTEGER])
		-- append consecutive substrings in `a_string' with counts in `count_list' starting from `a_start_index'
		local
			start_index, end_index: INTEGER
		do
			if a_string.valid_index (a_start_index) and then attached Split_intervals as intervals then
				intervals.wipe_out
				start_index := a_start_index
				across count_list as n loop
					end_index := start_index + n.item - 1
					if a_string.valid_index (end_index) then
						intervals.extend (start_index, end_index)
					end
					start_index := end_index + 1
				end
				append_intervals (a_string, intervals)
			end
		end

	append_tuple (tuple: TUPLE)
		local
			i: INTEGER; string: S
		do
			grow (count + tuple.count)
			from i := 1 until i > tuple.count loop
				if tuple.is_reference_item (i) and then attached tuple.reference_item (i) as any_ref then
					if attached {READABLE_STRING_GENERAL} any_ref as general then
						string := new_string (general)
					elseif attached {EL_PATH} any_ref as path then
						string := new_string (path.to_string)
					end
				else
					string := new_string (tuple.item (i).out)
				end
				extend (string)
				i := i + 1
			end
		end

	append_general (list: ITERABLE [READABLE_STRING_GENERAL])
		do
			grow (count + Iterable.count (list))
			across list as general loop
				if attached {S} general.item as str then
					extend (str)
				else
					extend (new_string (general.item))
				end
			end
		end

feature {NONE} -- Implementation

	append_intervals (a_string: READABLE_STRING_GENERAL; intervals: EL_SPLIT_INTERVALS)
		do
			grow (count + intervals.count)
			from intervals.start until intervals.after loop
				extend (new_string (a_string.substring (intervals.item_lower, intervals.item_upper)))
				intervals.forth
			end
		end

	new_string (general: READABLE_STRING_GENERAL): S
		do
			if attached {S} general as str then
				Result := str
			else
				create Result.make (general.count)
				if is_zstring (general) then
					as_zstring (general).append_to_general (Result)
				else
					Result.append (general)
				end
			end
		end

	tab_string (n: INTEGER): S
		local
			i: INTEGER
		do
			create Result.make (n)
			from i := 1 until i > n loop
				Result.append_code ({EL_ASCII}.Tab)
				i := i + 1
			end
		end

end