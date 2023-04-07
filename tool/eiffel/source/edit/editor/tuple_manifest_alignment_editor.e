note
	description: "[
		Edit the alignment of an array of tuples in some [$source SOURCE_LINES] so the named item
		in right column is left-justified
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-07 13:43:12 GMT (Friday 7th April 2023)"
	revision: "1"

class
	TUPLE_MANIFEST_ALIGNMENT_EDITOR

inherit
	EL_ARRAYED_LIST [TUPLE [comma_index, item_index, line_number: INTEGER]]
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
				adjust_tuple_item_spacing (maximum_comma_index)
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

	adjust_tuple_item_spacing (a_maximum_comma_index: INTEGER)
		local
			target_column, comma_column, tab_insertion_count, i: INTEGER
			intermediate_space_count, remainder_space_count: INTEGER
			s: EL_ZSTRING_ROUTINES; white_space, line: ZSTRING
			info: like item
		do
			if a_maximum_comma_index > 0 then
				target_column := column (a_maximum_comma_index) + 1

				across Current as list loop
					info := list.item
					if info.comma_index > 0 then
						comma_column := column (info.comma_index)
						from
							i := 0
						until
							(comma_column + i) \\ Spaces_per_tab = 0 or (comma_column + i) > target_column
						loop
							i := i + 1
						end
						if i = 0 then
							tab_insertion_count := 0
						else
							tab_insertion_count := 1
						end
						intermediate_space_count := target_column - (comma_column + i)
						tab_insertion_count := tab_insertion_count + intermediate_space_count // Spaces_per_tab
						remainder_space_count := intermediate_space_count \\ Spaces_per_tab
						line := lines [info.line_number]
						create white_space.make_filled (' ', tab_insertion_count + remainder_space_count)
						if tab_insertion_count > 0 then
							white_space.replace_substring (s.n_character_string ('%T', tab_insertion_count), 1, tab_insertion_count)
						end
						line.replace_substring (white_space, info.comma_index + 1, info.item_index - 1)
					end
				end
			end
		end

	column (a_index: INTEGER): INTEGER
		do
			Result := a_index - Manifest_tuple_indent + Manifest_tuple_indent * Spaces_per_tab
		end

	maximum_comma_index: INTEGER
		do
			across Current as list loop
				if list.item.comma_index > Result then
					Result := list.item.comma_index
				end
			end
		end

	new_manifest_tuple_info (line: ZSTRING): like item
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

feature {NONE} -- Internal attributes

	lines: SOURCE_LINES

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

	Spaces_per_tab: INTEGER = 3

note
	notes: "[
		Example:

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

		when aligned:

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