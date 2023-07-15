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
	date: "2023-07-15 9:33:58 GMT (Saturday 15th July 2023)"
	revision: "2"

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
				make_equal (list.count // 2)
				list.fill (manifest, ',', {EL_SIDE}.Left)
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