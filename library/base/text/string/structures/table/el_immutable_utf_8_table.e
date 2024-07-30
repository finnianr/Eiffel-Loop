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
	date: "2024-07-30 13:54:56 GMT (Tuesday 30th July 2024)"
	revision: "9"

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
			ir: EL_INTERVAL_ROUTINES; s: EL_ZSTRING_ROUTINES
		do
			Result := s.new_from_utf_8_lines (manifest, ir.to_lower (interval), ir.to_upper (interval), has_indentation)
		end

end