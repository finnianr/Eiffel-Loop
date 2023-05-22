note
	description: "[
		Eiffel source line containing manifest tuple for intialializing a table as for example:
		
			["input_file_path", agent get_input_file_path]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-22 18:02:01 GMT (Monday 22nd May 2023)"
	revision: "1"

class
	MANIFEST_TUPLE_LINE

create
	make

feature {NONE} -- Initialization

	make (line: ZSTRING)
		local
			index_end_quote, index_right_bracket, end_index, i, tab_count: INTEGER
		do
			tab_count := line.leading_occurrences ('%T')
			text := line
			if starts_with_tuple_manifest_string (line, tab_count) then
				index_end_quote := line.index_of ('"', tab_count + 3)
				end_index := line.count
				if line [end_index] = ',' then
					end_index := end_index - 1
				end
				index_right_bracket := line.last_index_of (']', end_index)
				if index_end_quote < index_right_bracket and then line [index_end_quote + 1] = ',' then
					comma_index := index_end_quote + 1
					comma_column := comma_index - tab_count + tab_count * Spaces_per_tab
					from i := comma_index + 1 until not line.is_space_item (i) loop
						i := i + 1
					end
					item_index := i
				end
			end
		end

feature -- Measurement

	comma_column: INTEGER
		-- column index of comma when tabs are expanded

	comma_index: INTEGER

	item_index: INTEGER

feature -- Access

	text: ZSTRING
		-- source line text

feature -- Element change

	align (target_column: INTEGER)
		-- edit `text' to align tuple value items on `target_column'
		-- with tabs expanded to `Spaces_per_tab' spaces
		local
			aligned_column, remainder_count, space_insertion_count, tab_insertion_count: INTEGER
			s: EL_ZSTRING_ROUTINES; remainder_spaces, tabbed_space: ZSTRING
		do
			if comma_index > 0 then
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

				text.replace_substring (tabbed_space + remainder_spaces, comma_index + 1, item_index - 1)
			end
		end

feature {NONE} -- Implementation

	starts_with_tuple_manifest_string (line: ZSTRING; tab_count: INTEGER): BOOLEAN
		-- `True' if `line' matches something like: %T%T%T["id", ..],
		do
			if tab_count + 5 <= line.count then
				Result := line.same_substring (Tuple_start, tab_count + 1, False)
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

feature {NONE} -- Constants

	Spaces_per_tab: INTEGER = 3

	Tuple_start: ZSTRING
		once
			Result := "[%""
		end

end