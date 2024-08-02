note
	description: "[
		String lookup table that stores all item text and lookup keys as a single UTF-8 encoded
		string manifest of type ${IMMUTABLE_STRING_8}.

		The three possible formats of the string manifest is described in the notes for class
		${EL_IMMUTABLE_STRING_TABLE}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-02 16:42:43 GMT (Friday 2nd August 2024)"
	revision: "11"

class
	EL_IMMUTABLE_UTF_8_TABLE

inherit
	EL_IMMUTABLE_STRING_8_TABLE
		rename
			make as make_utf_8,
			make_comma_separated as make_comma_separated_utf_8,
			make_field_map as make_field_map_utf_8,
			make_assignments as make_assignments_utf_8,
			found_item as found_utf_8_item,
			item_for_iteration as utf_8_item_for_iteration,
			key_for_iteration as utf_8_key_for_iteration,
			has_immutable as has_immutable_utf_8,
			has_immutable_key as has_immutable_key_utf_8
		redefine
			new_cursor, has_key_8, has_8, has_general, has_key_general
		end

create
	make, make_assignments, make_comma_separated, make_field_map,
	make_empty, make_subset, make_reversed,
-- UTF-8
	make_utf_8, make_field_map_utf_8, make_comma_separated_utf_8, make_assignments_utf_8

feature {NONE} -- Initialization

	make (indented_manifest: READABLE_STRING_GENERAL)
		-- make using indented formatted as for example:
		-- 	key_1:
		--			line 1..
		--			line 2..
		-- 	key_2:
		--			line 1..
		--			line 2..
		--		..
		do
			make_utf_8 (as_utf_8 (indented_manifest))
		end

	make_assignments (assignment_manifest: READABLE_STRING_GENERAL)
		-- make from manifest formatted as:
		-- 	key_1 := x
		-- 	key_2 := y
		-- 	key_3 := z
		-- 	..
		do
			make_assignments_utf_8 (as_utf_8 (assignment_manifest))
		end

	make_comma_separated (csv_manifest: READABLE_STRING_GENERAL)
		-- make with comma separated list with values on odd indices and keys on even indices
		do
			make_comma_separated_utf_8 (as_utf_8 (csv_manifest))
		end

	make_field_map (table_manifest: READABLE_STRING_GENERAL)
		-- make using indented format where each key is an Eiffel lower case identifier
		do
			make_field_map_utf_8 (as_utf_8 (table_manifest))
		end

feature -- Access

	found_item: ZSTRING
		do
			Result := new_item (found_interval)
		end

	item_for_iteration: ZSTRING
		do
			Result := new_item (interval_item_for_iteration)
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
			if shared_cursor_8 (a_key).all_ascii then
				Result := Precursor (a_key)
			end
			Result := has_general (a_key)
		end

	has_general (a_key: READABLE_STRING_GENERAL): BOOLEAN
		do
			if attached Key_buffer.copied_general_as_utf_8 (a_key) as key then
				Result := has_immutable_utf_8 (Immutable_8.as_shared (key))
			end
		end

feature -- Set found_item

	has_key_8 (a_key: READABLE_STRING_8): BOOLEAN
		-- Is there an item in the table with key `a_key'?
		-- If so, set `found_item' to the found item.
		do
			if shared_cursor_8 (a_key).all_ascii then
				Result := Precursor (a_key)
			else
				Result := has_key_general (a_key)
			end
		end

	has_key_general (a_key: READABLE_STRING_GENERAL): BOOLEAN
		do
			if attached Key_buffer.copied_general_as_utf_8 (a_key) as key then
				Result := has_immutable_key_utf_8 (Immutable_8.as_shared (key))
			end
		end

feature {EL_IMMUTABLE_UTF_8_TABLE_CURSOR} -- Implementation

	as_utf_8 (manifest_string: READABLE_STRING_GENERAL): STRING
		do
			create Result.make (manifest_string.count)
			shared_cursor_general (manifest_string).append_to_utf_8 (Result)
		end

	new_item (interval: INTEGER_64): ZSTRING
		local
			s: EL_ZSTRING_ROUTINES; start_index, end_index: INTEGER_32
		do
			start_index := to_lower (interval); end_index := to_upper (interval)
			inspect format
				when Fm_indented, Fm_indented_eiffel then
					Result := s.new_from_utf_8_lines (manifest, start_index, end_index)
			else
				create Result.make (end_index - start_index + 1)
				Result.append_utf_8 (manifest.shared_substring (start_index, end_index))
			end
		end

end