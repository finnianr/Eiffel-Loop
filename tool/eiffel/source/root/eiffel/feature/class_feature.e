note
	description: "Class feature"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-06 12:20:54 GMT (Thursday 6th April 2023)"
	revision: "25"

deferred class
	CLASS_FEATURE

inherit
	ANY

	EL_ZSTRING_CONSTANTS

	EL_EIFFEL_KEYWORDS

	EL_MODULE_TUPLE

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

feature {NONE} -- Initialization

	make (first_line: ZSTRING)
		do
			make_machine
			create lines.make (5)
			lines.extend (first_line)
			update_name
			found_line := Empty_string
		end

	make_with_lines (a_lines: like lines)
		do
			make (a_lines.first)
			across a_lines as line loop
				if line.cursor_index > 1 then
					lines.extend (line.item)
				end
			end
			lines.start
			lines.put_auto_edit_comment_right ("new insertion", 3)
		end

feature -- Access

	found_line: ZSTRING

	lines: SOURCE_LINES

	name: ZSTRING

feature -- Status query

	found: BOOLEAN
		do
			Result := found_line /= Empty_string
		end

	string_count: INTEGER
		do
			Result := lines.count
		end

feature -- Basic operations

	adjust_manifest_tuple_tabs
		do
			do_with_lines (agent find_manifest_start, lines)
		end

	expand_shorthand
			-- expand shorthand notation
		deferred
		end

	search_substring (substring: ZSTRING)
		do
			lines.find_first_true (agent {ZSTRING}.has_substring (substring))
			if lines.exhausted then
				found_line := Empty_string
			else
				found_line := lines.item
			end
		end

feature -- Element change

	set_lines (a_lines: like lines)
		do
			lines.wipe_out
			a_lines.do_all (agent lines.extend)
			lines.indent (1)
			update_name
			found_line := Empty_string
			lines.start
			lines.put_auto_edit_comment_right ("replacement", 3)
		end

feature {NONE} -- Line states

	find_manifest_end (line: ZSTRING)
		do
			if line.ends_with (Manifest.array_end) then
				adjust_tuple_item_spacing (maximum_comma_index)
				state := agent find_manifest_start

			elseif attached new_manifest_tuple_info (line) as tuple_info
				and then tuple_info.comma_index > 0
			then
				Tuple_info_list.extend (tuple_info)
			end
		end

	find_manifest_start (line: ZSTRING)
		do
			if line.ends_with (Manifest.array_start) then
				Tuple_info_list.wipe_out
				state := agent find_manifest_end
			end
		end

feature {NONE} -- Implementation

	adjust_tuple_item_spacing (a_maximum_comma_index: INTEGER)
		local
			tab_column, index_column, intermediate_space_count, tab_insertion_count: INTEGER
			s: EL_ZSTRING_ROUTINES; tab_inserts, line: ZSTRING
		do
			if a_maximum_comma_index > 0 then
				from tab_column := comma_column (a_maximum_comma_index) + 2 until (tab_column - 1) \\ Spaces_per_tab = 0 loop
					tab_column := tab_column + 1
				end
				across Tuple_info_list as list loop
					if attached list.item as info and then info.comma_index > 0 then
						index_column := comma_column (info.comma_index) + 1
						tab_insertion_count := 0
						from until index_column + tab_insertion_count * Spaces_per_tab >= tab_column loop
							tab_insertion_count := tab_insertion_count + 1
						end
						line := lines [info.line_number]
						tab_inserts := s.n_character_string ('%T', tab_insertion_count)
						line.replace_substring (tab_inserts, info.comma_index + 1, info.item_index - 1)
					end
				end
			end
		end

	comma_column (comma_index: INTEGER): INTEGER
		do
			Result := comma_index - Manifest_tuple_indent + Manifest_tuple_indent * Spaces_per_tab
		end

	new_manifest_tuple_info (line: ZSTRING): like Tuple_info_list.item
		local
			index_end_quote, index_right_bracket, end_index, i: INTEGER
		do
			create Result
			if line.starts_with (Open_bracket_quote) then
				index_end_quote := line.index_of ('"', Open_bracket_quote.count + 1)
				end_index := line.count
				if line [end_index] = ',' then
					end_index := end_index - 1
				end
				index_right_bracket := line.last_index_of (']', end_index)
				if index_end_quote < index_right_bracket and then line [index_end_quote + 1] = ',' then
					Result.comma_index := index_end_quote + 1
					Result.line_number := line_number
					from i := Result.comma_index + 1 until not line.is_space_item (i) loop
						i := i + 1
					end
					Result.item_index := i
				end
			end
		end

	maximum_comma_index: INTEGER
		do
			across Tuple_info_list as list loop
				if list.item.comma_index > Result then
					Result := list.item.comma_index
				end
			end
		end

	update_name
		local
			list: like Split_list
		do
			list := Split_list
			list.fill (lines.first, ' ', {EL_SIDE}.Left)
			from list.start until list.after or else not list.item_same_as (Keyword.frozen_) loop
				list.forth
			end
			if not list.after then
				name := list.item_copy
			end
			name.prune_all_trailing (':')
		end

feature {NONE} -- Constants

	Manifest: TUPLE [array_start, array_end: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "(<<, >>)")
		end

	Manifest_tuple_indent: INTEGER = 4

	Open_bracket_quote: ZSTRING
		local
			s: EL_ZSTRING_ROUTINES
		once
			Result := s.n_character_string ('%T', Manifest_tuple_indent) + "[%""
		end

	Split_list: EL_SPLIT_ZSTRING_LIST
		once
			create Result.make_empty
		end

	Spaces_per_tab: INTEGER = 3

	Tuple_info_list: EL_ARRAYED_LIST [TUPLE [comma_index, item_index, line_number: INTEGER]]
		once
			create Result.make (10)
		end

	Tab_code: NATURAL = 9

end