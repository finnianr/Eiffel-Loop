note
	description: "[
		Compact string table with items encoded as shared UTF-8 created from table manifest formatted as:
		
			key_1:
				line 1..
				line 2..
			key_2:
				line 1..
				line 2..
			..
			
		The keys must be lowercase Eiffel identifiers.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-16 16:37:48 GMT (Tuesday 16th January 2024)"
	revision: "8"

class
	EL_IMMUTABLE_UTF_8_TABLE

inherit
	EL_IMMUTABLE_STRING_8_TABLE
		rename
			make as make_utf_8,
			make_by_indented as make_by_indented_utf_8,
			make_by_assignment as make_by_assignment_utf_8,
			found_item as found_utf_8_item,
			item_for_iteration as utf_8_item_for_iteration,
			key_for_iteration as utf_8_key_for_iteration,
			has_immutable as has_immutable_utf_8,
			has_immutable_key as has_immutable_key_utf_8
		redefine
			new_cursor, has_key_8, has_8, has_general, has_key_general
		end

	EL_SHARED_STRING_8_BUFFER_SCOPES

create
	make, make_utf_8, make_by_assignment, make_by_assignment_utf_8,
	make_by_indented, make_by_indented_utf_8, make_empty, make_subset, make_reversed

feature {NONE} -- Initialization

	make (csv_manifest: READABLE_STRING_GENERAL)
		-- make with comma separated list with values on odd indices and keys on even indices
		do
			make_utf_8 (as_utf_8 (csv_manifest))
		end

	make_by_assignment (assignment_manifest: READABLE_STRING_GENERAL)
		do
			make_by_assignment_utf_8 (as_utf_8 (assignment_manifest))
		end

	make_by_indented (table_manifest: READABLE_STRING_GENERAL)
		-- make from manifest formatted as:
		-- 	key_1:
		--			line 1..
		--			line 2..
		-- 	key_2:
		--			line 1..
		--			line 2..
		-- 	..
		do
			make_by_indented_utf_8 (as_utf_8 (table_manifest))
		end

feature -- Access

	found_item: ZSTRING
		do
			Result := new_item (found_interval)
		end

	item_for_iteration: ZSTRING
		do
			create Result.make_from_utf_8 (utf_8_item_for_iteration)
		end

	key_for_iteration: ZSTRING
		do
			create Result.make_from_utf_8 (utf_8_key_for_iteration)
		end

	new_cursor: EL_IMMUTABLE_UTF_8_TABLE_CURSOR
		do
			create Result.make (Current)
			Result.start
		end

feature -- Status query

	has_8 (a_key: READABLE_STRING_8): BOOLEAN
		-- Is there an item in the table with key `a_key'?
		do
			Result := has_general (a_key)
		end

	has_general (a_key: READABLE_STRING_GENERAL): BOOLEAN
		do
			across String_8_scope as scope loop
				Result := has_immutable_utf_8 (Immutable_8.as_shared (scope.copied_utf_8_item (a_key)))
			end
		end

feature -- Set found_item

	has_key_8 (a_key: READABLE_STRING_8): BOOLEAN
		-- Is there an item in the table with key `a_key'?
		-- If so, set `found_item' to the found item.
		do
			Result := has_key_general (a_key)
		end

	has_key_general (a_key: READABLE_STRING_GENERAL): BOOLEAN
		do
			across String_8_scope as scope loop
				Result := has_immutable_key_utf_8 (Immutable_8.as_shared (scope.copied_utf_8_item (a_key)))
			end
		end

feature {EL_IMMUTABLE_UTF_8_TABLE_CURSOR} -- Implementation

	as_utf_8 (manifest_string: READABLE_STRING_GENERAL): STRING
		do
			across String_8_scope as scope loop
				Result := scope.copied_utf_8_item (manifest_string).twin
			end
		end

	new_item (interval: INTEGER_64): ZSTRING
		local
			start_index, end_index, interval_count: INTEGER_32; ir: EL_INTERVAL_ROUTINES
			split_on_tab_new_line: EL_SPLIT_IMMUTABLE_UTF_8_LIST
		do
			start_index := ir.to_lower (interval); end_index := ir.to_upper (interval)
			interval_count := end_index - start_index + 1

			if interval_count = 0 then
				create Result.make_empty
				
			elseif attached new_substring (start_index + has_indentation.to_integer, end_index) as substring then
				if substring.is_empty then
					create Result.make_empty

				elseif substring.has ('%N') then
					create split_on_tab_new_line.make_by_string (substring, New_line_tab)
					create Result.make (split_on_tab_new_line.character_count + split_on_tab_new_line.count - 1)
					if attached split_on_tab_new_line as list then
						from list.start until list.after loop
							if list.index > 1 then
								Result.append_character ('%N')
							end
							Result.append_utf_8 (list.item)
							list.forth
						end
					end

				else
					create Result.make_from_utf_8 (substring)
				end
			end
		end

feature {NONE} -- Constants

	New_line_tab: STRING = "%N%T"
end