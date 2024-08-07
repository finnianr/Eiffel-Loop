note
	description: "[
		A table mapping keys conforming to type ${IMMUTABLE_STRING_GENERAL} to virtual
		items of the same type. The table with all the keys and items have a shared character area
		found in the ''manifest'' string field. The text items are virtual because they are
		created on demand from a compact interval of type ${INTEGER_64}.
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-09 16:18:19 GMT (Friday 9th August 2024)"
	revision: "25"

deferred class
	EL_IMMUTABLE_STRING_TABLE [GENERAL -> STRING_GENERAL create make end, IMMUTABLE -> IMMUTABLE_STRING_GENERAL]

inherit
	HASH_TABLE [INTEGER_64, IMMUTABLE]
		rename
			found_item as found_interval,
			has as has_immutable,
			has_key as has_immutable_key,
			item as interval_item,
			item_for_iteration as interval_item_for_iteration,
			make as make_size
		redefine
			new_cursor
		end

	EL_STRING_BIT_COUNTABLE [GENERAL]

	STRING_HANDLER undefine copy, is_equal end

	EL_INTERVAL_ROUTINES
		rename
			count as interval_count,
			compact as compact_interval
		export
			{NONE} all
		undefine
			copy, is_equal
		end

	EL_READABLE_STRING_GENERAL_ROUTINES_IMP
		rename
			occurrences as text_occurrences,
			shared_cursor as shared_cursor_general,
			valid_assignments as valid_assignments_general
		export
			{NONE} all
		end

feature {NONE} -- Initialization

	make (a_manifest: GENERAL)
		-- 	key_1:
		--			line 1..
		--			line 2..
		-- 	key_2:
		--			line 1..
		--			line 2..
		--		..

		require
			valid_manifest: valid_indented (a_manifest)
		local
			interval: INTEGER_64; colon_index, start_index: INTEGER
			name, line: IMMUTABLE
		do
			manifest := new_shared (a_manifest)
			if format = 0 then
				format := Fm_indented
			end
			name := new_substring (1, 0)
			if attached new_split_list as list then
				list.fill (manifest, '%N', 0)
				make_equal (a_manifest.occurrences (':'))
				from list.start until list.after loop
					line := list.item
					if line.count = 0 or else line [1] = '%T' then
						if has_immutable_key (name) then
							interval := found_interval
							if interval.to_boolean then
								interval := compact_interval (to_lower (interval), list.item_upper)
							else
								interval := compact_interval (list.item_lower, list.item_upper)
							end
							force (interval, name)
						end
					else
						colon_index := line.last_index_of (':', line.count)
						if colon_index > 0 then
							start_index := list.item_lower
							name := new_substring (start_index, start_index + colon_index - 2)
							if is_field_map implies string.is_eiffel_lower (name) then
								extend (0, name)
							end
						end
					end
					list.forth
				end
			end
		end

	make_assignments (a_manifest: GENERAL)
		-- make from manifest formatted as:
		-- 	key_1 := x
		-- 	key_2 := y
		-- 	key_3 := z
		-- 	..

		-- All quotes are interpreted literally as characters occurring in the key or value
		require
			valid_manifest: valid_assignments (a_manifest)
		local
			start_index, end_index, offset: INTEGER; interval: INTEGER_64
		do
			manifest := new_shared (a_manifest)
			if attached new_split_list as list then
				list.fill (manifest, '%N', 0)
				make_equal (list.count // 2)
				from list.start until list.after loop
					start_index := string.start_plus_end_assignment_indices (list.item, $end_index)
					if end_index > 0 and start_index > 0 then
						offset := list.item_lower - 1
						interval := compact_interval (start_index + offset, list.item_upper)
						extend (interval, new_substring (1 + offset, end_index + offset))
					end
					list.forth
				end
			end
		end

	make_comma_separated (a_manifest: GENERAL)
		-- make with comma separated list with values on odd indices and keys on even indices
		-- as for example:

		-- 	key_1, item_1,
		-- 	key_2, item_2,
		-- 	key_3, item_3,
		-- 	..

		-- All quotes are interpreted literally as characters occurring in the key or value
		require
			valid_manifest: valid_comma_separated (a_manifest)
		local
			last_interval: INTEGER_64
		do
			format := Fm_comma_separated
			manifest := new_shared (a_manifest)
			if attached new_split_list as list then
				list.fill (manifest, ',', {EL_SIDE}.Left)
				make_equal (list.count // 2)

				from list.start until list.after loop
					if list.index \\ 2 = 1 then
						last_interval := compact_interval (list.item_lower, list.item_upper)
					else
						extend (last_interval, list.item)
					end
					list.forth
				end
			end
		end

	make_empty
		do
			make_equal (0)
		end

	make_field_map (a_manifest: GENERAL)
		-- make using indented format where each key is an Eiffel lower case identifier
		do
			format := Fm_indented_eiffel
			make (a_manifest)
		end

	make_reversed (other: like Current)
		-- make with keys and items of `other' swapped
		do
			make_size (other.count)
			manifest := other.manifest; format := other.format
			from other.start until other.after loop
				extend (immutable_interval (other.key_for_iteration), other.item_for_iteration)
				other.forth
			end
		ensure
			definition: across Current as table all table.key ~ other.item (table.item) end
		end

	make_subset (other: like Current; excluded_set: EL_HASH_SET [IMMUTABLE])
		do
			manifest := other.manifest
			make_equal (other.count - excluded_set.count)
			from other.start until other.after loop
				if not excluded_set.has (other.key_for_iteration) then
					extend (other.interval_item_for_iteration, other.key_for_iteration)
				end
				other.forth
			end
		end

feature -- Status query

	has_key_general (a_key: READABLE_STRING_GENERAL): BOOLEAN
		deferred
		end

	has_key_x (a_key: READABLE_STRING_GENERAL): BOOLEAN
		deferred
		end

	is_field_map: BOOLEAN
		-- do keys represent Eiffel attribute fields
		do
			Result := format = Fm_indented_eiffel
		end

feature -- Access

	format: NATURAL_8
		-- format of manifest

	found_count: INTEGER
		do
			Result := interval_count (found_interval)
		end

	found_item: IMMUTABLE
		do
			Result := new_item_substring (found_interval)
		end

	found_item_lines: like new_split_list
		do
			Result := new_split_list
			Result.fill (found_item, '%N', 0)
			Result.unindent
		end

	item (key: IMMUTABLE): IMMUTABLE
		do
			Result := new_item_substring (interval_item (key))
		end

	item_for_iteration: IMMUTABLE
		do
			Result := new_item_substring (interval_item_for_iteration)
		end

feature -- Factory

	new_cursor: EL_IMMUTABLE_STRING_TABLE_CURSOR [IMMUTABLE]
			-- <Precursor>
		do
			create Result.make (Current)
			Result.start
		end

feature -- Contract Support

	valid_assignments (a_manifest: GENERAL): BOOLEAN
		-- `True' if each line contains a ":=" substring with optional
		-- whitespace padding either side
		do
			Result := string.valid_assignments (a_manifest)
		end

	valid_comma_separated (a_manifest: GENERAL): BOOLEAN
		-- `True' if each line has 2 commas and ends with a comma
		-- except for the last line which only has one comma
		local
			line_list: EL_SPLIT_STRING_LIST [GENERAL]; str: GENERAL
		do
			if a_manifest.has ('%N') then
				create line_list.make (a_manifest, '%N')
				Result := True
				across line_list as list until not Result loop
					str := list.item
					if list.is_last then
						Result := str.occurrences (',') = 1

					else
						Result := str.occurrences (',') = 2 and then str [str.count] = ','
					end
				end
			else
				Result := (a_manifest.occurrences (',') + 1) \\ 2 = 0
			end
		end

	valid_indented (a_manifest: GENERAL): BOOLEAN
		-- `True' if each line is either tab-indented or a name key ending with ':'
		local
			line_list: EL_SPLIT_STRING_LIST [GENERAL]; line: GENERAL
			is_first_line_name: BOOLEAN; colon_index: INTEGER
		do
			Result := True
			if a_manifest.count > 0 then
				create line_list.make (a_manifest, '%N')
				across line_list as list until not Result loop
					line := list.item
					if line.count > 0 and then line [1] /= '%T' then
						colon_index := line.last_index_of (':', line.count)
						if colon_index > 0 and then attached line.substring (1, colon_index - 1) as name then
							Result := is_field_map implies string.is_eiffel_lower (name)
							if Result and then list.cursor_index = 1 then
								is_first_line_name := True
							end
						end
					end
				end
				Result := Result and is_first_line_name
			end
		end

feature {EL_IMMUTABLE_STRING_TABLE_CURSOR} -- Implementation

	immutable_interval (str: IMMUTABLE): INTEGER_64
		do
			if attached shared_cursor (str) as c then
				Result := compact_interval (c.area_first_index + 1, c.area_last_index + 1)
			end
		ensure
			reversible: new_item_substring (Result) ~ str
		end

	new_item_substring (interval: INTEGER_64): IMMUTABLE
		do
			Result := new_substring (to_lower (interval), to_upper (interval))
		end

feature {NONE} -- Deferred

	new_shared (a_manifest: GENERAL): IMMUTABLE
		deferred
		end

	new_split_list: EL_SPLIT_READABLE_STRING_LIST [IMMUTABLE]
		deferred
		ensure
			even_count: Result.count \\ 2 = 0
		end

	new_substring (start_index, end_index: INTEGER): IMMUTABLE
		deferred
		end

	shared_cursor (str: READABLE_STRING_GENERAL): EL_STRING_ITERATION_CURSOR
		deferred
		end

	string: EL_STRING_X_ROUTINES [GENERAL, READABLE_STRING_GENERAL, COMPARABLE]
		deferred
		end

feature {STRING_HANDLER} -- Internal attributes

	manifest: IMMUTABLE;

feature {NONE} -- Formats

	Fm_assignment: NATURAL_8 = 1

	Fm_comma_separated: NATURAL_8 = 2

	Fm_indented: NATURAL_8 = 3

	Fm_indented_eiffel: NATURAL_8 = 4

	Fm_indented_code: NATURAL_8 = 4

note
	notes: "[
		The ''manifest'' string can be formatted in three ways

		1. Colon delimited keys followed by item lines as for example:

			key_1:
				line 1..
				line 2..
			key_2:
				line 1..
				line 2..
			..

		2. By Eiffel style assignment as though the keys are variables, but without quotes:

			key_1 := <item_1>
			key_2 := <item_2>
			key_3 := <item_3>

		3. By comma delimiters with each line containing two commas.

			key_1, <item_1>,
			key_2, <item_2>,
			key_3, <item_3>,
	]"

end