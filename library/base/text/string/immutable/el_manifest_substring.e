note
	description: "[
		Substring text item of a shared UTF-8 encoded table manifest formatted as colon delimited keys
		as for example:

			key_1:
				line 1..
				line 2..
			key_2:
				line 1..
				line 2..
			..

	]"
	notes: "[
		Used to implement classes:
		
			${EL_REFLECTIVE_STRING_TABLE}
			${EL_IMMUTABLE_STRING_TABLE}
			${EL_HASH_TABLE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-21 9:56:16 GMT (Monday 21st April 2025)"
	revision: "10"

deferred class
	EL_MANIFEST_SUBSTRING [STRING_X -> STRING_GENERAL create make end, CHAR -> COMPARABLE]

inherit
	EL_MAKEABLE
		rename
			make as make_empty
		end

	EL_STRING_GENERAL_ROUTINES_I

	EL_TYPED_POINTER_ROUTINES_I

	EL_STRING_BIT_COUNTABLE [STRING_X]

feature {NONE} -- Initialization

	make_empty
		do
			utf_8_manifest := Empty_text
		end

feature -- Element change

	make, set_string (a_utf_8_manifest: IMMUTABLE_STRING_8; a_start_index, a_end_index: INTEGER)
		require
			valid_start_index: a_utf_8_manifest.count > 0 implies a_utf_8_manifest.valid_index (a_start_index)
			valid_end_index: a_end_index >= a_start_index implies a_utf_8_manifest.valid_index (a_end_index)
		do
			utf_8_manifest := a_utf_8_manifest; start_index := a_start_index; end_index := a_end_index
		end

	wipe_out
		do
			make_empty
		end

feature -- Access

	count: INTEGER
		-- count of characters omitting leading tab
		local
			utf_8: EL_UTF_8_CONVERTER
		do
			Result := utf_8.unicode_substring_count (utf_8_manifest, start_index + 1, end_index)
		-- subtract count of leading tabs by counting lines
			Result := Result - super_readable_8 (utf_8_manifest).occurrences_in_bounds ('%N', start_index + 1, end_index)
		end

	lines: EL_STRING_LIST [STRING_X]
		do
			create Result.make_with_lines (string)
		end

	start_plus_end_assignment_indices (line: READABLE_STRING_GENERAL; end_index_ptr: TYPED_POINTER [INTEGER]): INTEGER
		-- if `line' is "a := b" then `Result' is index of 'b' character
		-- and writes the index of 'a' character to `end_index_ptr'
		local
			assign_index, l_end_index: INTEGER
		do
			assign_index := line.substring_index (Assign_symbol, 1)

			if assign_index > 0 and line.valid_index (assign_index - 1) then
				if line [assign_index - 1] = ' ' then
					l_end_index := assign_index - 2
				else
					l_end_index := assign_index - 1
				end
			end
			if assign_index > 0 and line.valid_index (assign_index + 2) then
				if line [assign_index + 2] = ' ' then
					Result := assign_index + 3
				else
					Result := assign_index + 2
				end
			end
			put_integer_32 (l_end_index, end_index_ptr)
		end

	string, str: STRING_X
		-- substring of `utf_8_manifest' defined by `start_index' and `end_index'
		do
			Result := new_from_immutable_8 (utf_8_manifest, start_index, end_index, True, True)
		ensure
			valid_count: Result.count = count
		end

feature -- Contract Support

	valid_assignments (a_manifest: READABLE_STRING_GENERAL): BOOLEAN
		local
			l_start_index, l_end_index: INTEGER
		do
			Result := True
			across a_manifest.split ('%N') as list until not Result loop
				if attached list.item as line then
					l_start_index := start_plus_end_assignment_indices (line, $l_end_index)
					Result := l_end_index >= 1 and l_start_index <= line.count
				end
			end
		end

feature -- Factory

	new_from_immutable_8 (
		a_str: IMMUTABLE_STRING_8; a_start_index, a_end_index: INTEGER_32; unindent, utf_8_encoded: BOOLEAN

	): like str
		-- new string of type `STRING_X' consisting of decoded UTF-8 text

		--		`a_str.shared_substring (a_start_index, a_end_index)'

		-- if `unindent' is true, and character at `a_start_index' is a tab, then all lines
		-- are unindented by one tab.
		require
			valid_start_index: a_str.valid_index (a_start_index)
			valid_end_index: a_end_index >= a_start_index implies a_str.valid_index (a_end_index)
		do
			if a_end_index - a_start_index + 1 = 0 then
				create Result.make (0)

			elseif unindent and then a_str [a_start_index] = '%T' then
				if attached a_str.shared_substring (a_start_index + 1, a_end_index) as item_lines then
					if item_lines.has ('%N') and then attached Immutable_string_8_split_list [utf_8_encoded] as split_list then
						split_list.fill_by_string (item_lines, New_line_tab, 0)
						if split_list.count > 0 then
							create Result.make (split_list.unicode_count + split_list.count - 1)
							append_lines_to (Result, split_list)
						else
							create Result.make (0)
						end
					else
						Result := new_from_string_8 (item_lines, utf_8_encoded)
					end
				end
			else
				Result := new_from_string_8 (a_str.shared_substring (a_start_index, a_end_index), utf_8_encoded)
			end
		ensure
			calculated_correct_size: Result.count = Result.capacity
		end

feature {NONE} -- Implementation

	append_lines_to (a_str: STRING_X; line_list: EL_SPLIT_IMMUTABLE_STRING_8_LIST)
		deferred
		end

	append_string_8 (target: STRING_X; str_8: READABLE_STRING_8)
		do
			target.append (str_8)
		end

	new_from_string_8 (str_8: READABLE_STRING_8; utf_8_encoded: BOOLEAN): like str
		local
			u8: EL_UTF_8_CONVERTER
		do
			if utf_8_encoded then
				create Result.make (u8.unicode_count (str_8))
				super (Result).append_utf_8 (str_8)
			else
				create Result.make (str_8.count)
				append_string_8 (Result, str_8)
			end
		end

	super (a_str: STRING_X): EL_EXTENDED_STRING_GENERAL [CHAR]
		deferred
		end

feature {NONE} -- Internal attributes

	end_index: INTEGER

	start_index: INTEGER

	utf_8_manifest: IMMUTABLE_STRING_8
		-- shared manifest string with format

		-- 	key_1:
		--			line 1..
		--			line 2..
		-- 	key_2:
		--			line 1..
		--			line 2..
		--		..

feature {NONE} -- Constants

	Assign_symbol: STRING = ":="

	Empty_text: IMMUTABLE_STRING_8
		once
			create Result.make_empty
		end

	Immutable_string_8_split_list: EL_BOOLEAN_INDEXABLE [EL_SPLIT_IMMUTABLE_STRING_8_LIST]
		once
			create Result.make (
				create {EL_SPLIT_IMMUTABLE_STRING_8_LIST}.make_empty, -- False -> latin-1
				create {EL_SPLIT_IMMUTABLE_UTF_8_LIST}.make_empty		-- True  -> UTF-8
			)
		end

	New_line_tab: STRING = "%N%T"

end