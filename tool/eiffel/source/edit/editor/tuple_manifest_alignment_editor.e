note
	description: "[
		Align the right columns of an array of name-value tuples in some [$source SOURCE_LINES] so the
		value item is left-justified.
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-22 15:00:13 GMT (Monday 22nd May 2023)"
	revision: "2"

class
	TUPLE_MANIFEST_ALIGNMENT_EDITOR

inherit
	EL_ARRAYED_LIST [TUPLE [comma_column, comma_index, item_index, line_number: INTEGER]]
		rename
			append as list_append,
			make as make_sized
		export
			{NONE} all
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		undefine
			copy, is_equal
		end

	EL_MODULE_TUPLE

create
	make

feature {NONE} -- Initialization

	make
		do
			make_machine
			make_sized (20)
			create lines.make (0)
		end

feature -- Basic operations

	edit (a_lines: SOURCE_LINES)
		do
			lines := a_lines
			do_with_lines (agent find_manifest_start, a_lines)
		end

feature {NONE} -- Line states

	find_manifest_end (line: ZSTRING)
		do
			if line.ends_with (Manifest.array_end) then
				adjust_tuple_item_spacing (maximum_comma_column)
				state := agent find_manifest_start

			elseif attached new_manifest_tuple_info (line) as tuple_info
				and then tuple_info.comma_index > 0
			then
				extend (tuple_info)
			end
		end

	find_manifest_start (line: ZSTRING)
		do
			if line.ends_with (Manifest.array_start) then
				wipe_out
				state := agent find_manifest_end
			end
		end

feature {NONE} -- Implementation

	adjust_tuple_item_spacing (a_maximum_comma_column: INTEGER)
		local
			target_column, comma_column, aligned_column, remainder_count: INTEGER
			space_insertion_count, tab_insertion_count: INTEGER
			s: EL_ZSTRING_ROUTINES; remainder_spaces, line, tabbed_space: ZSTRING
			info: like item
		do
			if a_maximum_comma_column > 0 then
				target_column := a_maximum_comma_column + 1

				across Current as list loop
					info := list.item
					space_insertion_count := 0; tab_insertion_count := 0
					if info.comma_index > 0 then
						comma_column := info.comma_column
						line := lines [info.line_number]

						aligned_column := tab_aligned_column (comma_column)
						if aligned_column > target_column then
							space_insertion_count := target_column - comma_column

						else
							if aligned_column > comma_column then
								tab_insertion_count := 1
							end
							remainder_count := target_column - aligned_column
							tab_insertion_count := tab_insertion_count + remainder_count // Spaces_per_tab
							space_insertion_count := remainder_count \\ Spaces_per_tab
						end

						tabbed_space := s.n_character_string ('%T', tab_insertion_count)
						remainder_spaces := s.n_character_string (' ', space_insertion_count)

						line.replace_substring (tabbed_space + remainder_spaces, info.comma_index + 1, info.item_index - 1)
					end
				end
			end
		end

	tab_aligned_column (column: INTEGER): INTEGER
		local
			remainder: INTEGER
		do
			remainder := column \\ Spaces_per_tab
			if remainder > 0 then
				Result := ((column // Spaces_per_tab) + 1) * Spaces_per_tab
			else
				Result := column
			end
		end

	maximum_comma_column: INTEGER
		local
			l_column: INTEGER
		do
			across Current as list loop
				l_column := list.item.comma_column
				if l_column > Result then
					Result := l_column
				end
			end
		end

	new_manifest_tuple_info (line: ZSTRING): like item
		local
			index_end_quote, index_right_bracket, end_index, i, tab_count: INTEGER
		do
			create Result
			tab_count := line.leading_occurrences ('%T')
			if starts_with_tuple_manifest_string (line, tab_count) then
				index_end_quote := line.index_of ('"', tab_count + 3)
				end_index := line.count
				if line [end_index] = ',' then
					end_index := end_index - 1
				end
				index_right_bracket := line.last_index_of (']', end_index)
				if index_end_quote < index_right_bracket and then line [index_end_quote + 1] = ',' then
					Result.comma_index := index_end_quote + 1
					Result.comma_column := Result.comma_index - tab_count + tab_count * Spaces_per_tab

					Result.line_number := line_number
					from i := Result.comma_index + 1 until not line.is_space_item (i) loop
						i := i + 1
					end
					Result.item_index := i
				end
			end
		end

	starts_with_tuple_manifest_string (line: ZSTRING; tab_count: INTEGER): BOOLEAN
		-- `True' if `line' matches something like: %T%T%T["id", ..],
		do
			if tab_count + 5 <= line.count then
				Result := line.same_substring (Manifest.tuple_start, tab_count + 1, False)
			end
		end

feature {NONE} -- Internal attributes

	lines: SOURCE_LINES

feature {NONE} -- Constants

	Manifest: TUPLE [array_start, array_end, tuple_start: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "(<<, >>), [%"")
		end

	Manifest_tuple_indent: INTEGER = 4

	Spaces_per_tab: INTEGER = 3

note
	notes: "[
		Unaligned tuple array:

			Getter_functions: EVOLICITY_GETTER_FUNCTION_TABLE
					--
				once
					create Result.make (<<
						["input_file_path", agent get_input_file_path],
						["output_file_path", agent get_output_file_path],
						["bit_rate", agent get_bit_rate],
						["mode", agent get_mode]
					>>)
				end

		Aligned tuple array:

			Getter_functions: EVOLICITY_GETTER_FUNCTION_TABLE
					--
				once
					create Result.make (<<
						["input_file_path",  agent get_input_file_path],
						["output_file_path", agent get_output_file_path],
						["bit_rate",			agent get_bit_rate],
						["mode",					agent get_mode]
					>>)
				end
	]"

end