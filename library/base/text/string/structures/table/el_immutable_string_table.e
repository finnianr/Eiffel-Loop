note
	description: "[
		A table mapping keys conforming to type [$source IMMUTABLE_STRING_GENERAL] to virtual
		items of the same type. The table with all the keys and items uses a shared character area.
		The looked up items are virtual because they are created on demand from a compact interval of type
		[$source INTEGER_64].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-15 16:55:20 GMT (Saturday 15th July 2023)"
	revision: "4"

deferred class
	EL_IMMUTABLE_STRING_TABLE [GENERAL -> STRING_GENERAL create make end, IMMUTABLE -> IMMUTABLE_STRING_GENERAL]

inherit
	HASH_TABLE [INTEGER_64, IMMUTABLE]
		rename
			found_item as found_interval,
			item as interval_item,
			item_for_iteration as interval_item_for_iteration,
			make as make_size
		export
			{NONE} found_interval, interval_item, interval_item_for_iteration
		redefine
			new_cursor
		end

feature {NONE} -- Initialization

	make (a_manifest: GENERAL)
		require
			valid_manifest: valid_manifest (a_manifest)
		local
			ir: EL_INTERVAL_ROUTINES; last_interval: INTEGER_64
		do
			manifest := new_shared (a_manifest)
			if attached new_split_list as list then
				list.fill (manifest, ',', {EL_SIDE}.Left)
				make_equal (list.count // 2)

				from list.start until list.after loop
					if list.index \\ 2 = 1 then
						last_interval := ir.compact (list.item_start_index, list.item_end_index)
					else
						extend (last_interval, list.item)
					end
					list.forth
				end
			end
		end

	make_by_assignment (a_manifest: GENERAL)
		require
			valid_manifest: valid_manifest_assignments (a_manifest)
		local
			start_index, end_index, offset: INTEGER; rs: EL_READABLE_STRING_GENERAL_ROUTINES
			ir: EL_INTERVAL_ROUTINES; interval: INTEGER_64
		do
			manifest := new_shared (a_manifest)
			if attached new_split_list as list then
				list.fill (manifest, '%N', 0)
				make_equal (list.count // 2)
				from list.start until list.after loop
					start_index := rs.start_plus_end_assignment_indices (list.item, $end_index)
					if end_index > 0 and start_index > 0 then
						offset := list.item_start_index - 1
						interval := ir.compact (start_index + offset, list.item_end_index)
						extend (interval, new_substring (1 + offset, end_index + offset))
					end
					list.forth
				end
			end
		end

feature -- Status query

	has_key_general (a_key: READABLE_STRING_GENERAL): BOOLEAN
		do
			if attached {IMMUTABLE} a_key as key then
				Result := has_key (key)

			elseif attached {GENERAL} a_key as key then
				Result := has_key (new_shared (key))

			elseif manifest.is_string_8 and then attached {GENERAL} a_key.to_string_8 as key then
				Result := has_key (new_shared (key))

			elseif manifest.is_string_32 and then attached {GENERAL} a_key.to_string_32 as key then
				Result := has_key (new_shared (key))
			end
		end

feature -- Access

	found_item: IMMUTABLE
		do
			Result := new_item_substring (found_interval)
		end

	item (key: IMMUTABLE): IMMUTABLE
		do
			Result := new_item_substring (interval_item (key))
		end

	item_for_iteration: IMMUTABLE
		do
			Result := new_item_substring (interval_item_for_iteration)
		end

	new_cursor: EL_IMMUTABLE_STRING_TABLE_CURSOR [IMMUTABLE]
			-- <Precursor>
		do
			create Result.make (Current)
			Result.start
		end

feature -- Contract Support

	valid_manifest (a_manifest: GENERAL): BOOLEAN
		-- `True' if each line has 2 commas and ends with a comma
		-- except for the last line which only has one comma
		local
			line_list: EL_SPLIT_STRING_LIST [GENERAL]; str: GENERAL
		do
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
		end

	valid_manifest_assignments (a_manifest: GENERAL): BOOLEAN
		-- `True' if each line contains a ":=" substring with optional
		-- whitespace padding either side
		local
			rs: EL_READABLE_STRING_GENERAL_ROUTINES
		do
			Result := rs.valid_assignments (a_manifest)
		end

feature {EL_IMMUTABLE_STRING_TABLE_CURSOR} -- Implementation

	new_item_substring (interval: INTEGER_64): IMMUTABLE
		local
			ir: EL_INTERVAL_ROUTINES
		do
			Result := new_substring (ir.to_lower (interval), ir.to_upper (interval))
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

feature {NONE} -- Internal attributes

	manifest: IMMUTABLE

end