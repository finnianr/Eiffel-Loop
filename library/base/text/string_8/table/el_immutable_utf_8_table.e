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
	date: "2025-04-05 13:21:51 GMT (Saturday 5th April 2025)"
	revision: "22"

class
	EL_IMMUTABLE_UTF_8_TABLE

inherit
	EL_IMMUTABLE_STRING_8_TABLE
		rename
			make as make_encoded,
			make_comma_separated as make_comma_separated_encoded,
			make_assignments as make_assignments_encoded,
			found_item as found_utf_8_item,
			item_for_iteration as utf_8_item_for_iteration,
			unidented_item_for_iteration as unidented_utf_8_item_for_iteration
		redefine
			copy_attributes, new_cursor, has_key, has, has_general, has_key_general
		end

create
	make, make_assignments, make_comma_separated, make_indented_eiffel,
	make_empty, make_subset, make_reversed,
-- UTF-8
	make_utf_8, make_comma_separated_utf_8, make_assignments_utf_8, make_indented_eiffel_utf_8

convert
	make_indented_eiffel ({STRING_8, STRING_32, ZSTRING})

feature {NONE} -- Initialization

	make (a_format: NATURAL_8; indented_manifest: READABLE_STRING_GENERAL)
		-- make using indented formatted as for example:
		-- 	key_1:
		--			line 1..
		--			line 2..
		-- 	key_2:
		--			line 1..
		--			line 2..
		--		..
		do
			if is_latin_1 (indented_manifest) then
				make_encoded (a_format, as_latin_1 (indented_manifest))
			else
				make_utf_8 (a_format, as_utf_8 (indented_manifest))
			end
		end

	make_utf_8 (a_format: NATURAL_8; indented_utf_8_manifest: READABLE_STRING_8)
		do
			is_utf_8_encoded := True
			make_encoded (a_format, indented_utf_8_manifest)
		end

	make_assignments (assignment_manifest: READABLE_STRING_GENERAL)
		-- make from manifest formatted as:
		-- 	key_1 := x
		-- 	key_2 := y
		-- 	key_3 := z
		-- 	..
		do
			if is_latin_1 (assignment_manifest) then
				make_assignments_encoded (as_latin_1 (assignment_manifest))
			else
				make_assignments_utf_8 (as_utf_8 (assignment_manifest))
			end
		end

	make_assignments_utf_8 (assignment_utf_8_manifest: READABLE_STRING_8)
		do
			is_utf_8_encoded := True
			make_assignments_encoded (assignment_utf_8_manifest)
		end

	make_comma_separated (csv_manifest: READABLE_STRING_GENERAL)
		-- make with comma separated list with values on odd indices and keys on even indices
		do
			if is_latin_1 (csv_manifest) then
				make_comma_separated_encoded (as_latin_1 (csv_manifest))
			else
				make_comma_separated_utf_8 (as_utf_8 (csv_manifest))
			end
		end

	make_comma_separated_utf_8 (csv_utf_8_manifest: READABLE_STRING_8)
		do
			is_utf_8_encoded := True
			make_comma_separated_encoded (csv_utf_8_manifest)
		end

	make_indented_eiffel (indented_manifest: READABLE_STRING_GENERAL)
		-- make using indented formatted as for example:
		-- 	key_1:
		--			line 1..
		--			line 2..
		-- 	key_2:
		--			line 1..
		--			line 2..
		--		..
		do
			if is_latin_1 (indented_manifest) then
				make_encoded ({EL_TABLE_FORMAT}.Indented_eiffel, as_latin_1 (indented_manifest))
			else
				make_indented_eiffel_utf_8 (as_utf_8 (indented_manifest))
			end
		end

	make_indented_eiffel_utf_8 (indented_manifest_utf_8: READABLE_STRING_8)
		do
			make_utf_8 ({EL_TABLE_FORMAT}.Indented_eiffel, indented_manifest_utf_8)
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

	new_cursor: EL_IMMUTABLE_UTF_8_TABLE_CURSOR
		do
			create Result.make (Current)
			Result.start
		end

	zkey_for_iteration: ZSTRING
		do
			if is_utf_8_encoded then
				create Result.make_from_utf_8 (key_for_iteration)
			else
				create Result.make_from_general (key_for_iteration)
			end
		end

feature -- Status query

	has (a_key: READABLE_STRING_8): BOOLEAN
		-- Is there an item in the table with key `a_key'?
		require else
			valid_key_8: valid_key_8 (a_key)
		do
			inspect format
				when {EL_TABLE_FORMAT}.indented_code, {EL_TABLE_FORMAT}.indented_eiffel then
					Result := Precursor (a_key)
			else
				if is_utf_8_encoded then
					if super_readable_8 (a_key).all_ascii then
						Result := Precursor (a_key)
					else
						Result := Precursor (utf_8_key (a_key))
					end
				else
					Result := Precursor (a_key)
				end
			end
		end

	has_general (a_key: READABLE_STRING_GENERAL): BOOLEAN
		do
			inspect format
				when {EL_TABLE_FORMAT}.indented_code, {EL_TABLE_FORMAT}.indented_eiffel then
					Result := Precursor (a_key)
			else
				if is_utf_8_encoded then
					if a_key.is_string_8 and then attached {READABLE_STRING_8} a_key as key_8
						and then super_readable_8 (key_8).all_ascii
					then
						Result := has_immutable (key_8)
					else
						Result := has_immutable (utf_8_key (a_key))
					end
				else
					Result := Precursor (a_key)
				end
			end
		end

	is_utf_8_encoded: BOOLEAN

feature -- Set found_item

	has_key (a_key: READABLE_STRING_8): BOOLEAN
		-- Is there an item in the table with key `a_key'?
		-- If so, set `found_item' to the found item.
		require else
			valid_key_8: valid_key_8 (a_key)
		do
			inspect format
				when {EL_TABLE_FORMAT}.indented_code, {EL_TABLE_FORMAT}.indented_eiffel then
					Result := Precursor (a_key)
			else
				if is_utf_8_encoded then
					if super_readable_8 (a_key).all_ascii then
						Result := Precursor (a_key)
					else
						Result := Precursor (utf_8_key (a_key))
					end
				else
					Result := Precursor (a_key)
				end
			end
		end

	has_key_general (a_key: READABLE_STRING_GENERAL): BOOLEAN
		do
			inspect format
				when {EL_TABLE_FORMAT}.indented_code, {EL_TABLE_FORMAT}.indented_eiffel then
					Result := Precursor (a_key)
			else
				if is_utf_8_encoded then
					if a_key.is_string_8 and then attached {READABLE_STRING_8} a_key as key_8
						and then super_readable_8 (key_8).all_ascii
					then
						Result := has_immutable_key (key_8)
					else
						Result := has_immutable_key (utf_8_key (a_key))
					end
				else
					Result := Precursor (a_key)
				end
			end
		end

	valid_key_8 (a_key: READABLE_STRING_8): BOOLEAN
		local
			utf_8: EL_UTF_8_CONVERTER
		do
			Result := is_utf_8_encoded implies utf_8.is_valid_string_8 (a_key)
		end

feature -- Conversion

	to_table: EL_ZSTRING_TABLE
		do
			create Result.make_from_table (Current)
		end

feature {EL_IMMUTABLE_UTF_8_TABLE_CURSOR} -- Implementation

	as_latin_1 (manifest_string: READABLE_STRING_GENERAL): READABLE_STRING_8
		do
			if manifest_string.is_immutable and then manifest_string.is_string_8
				and then attached {IMMUTABLE_STRING_8} manifest_string as str_8
			then
				Result := str_8
			else
				Result := manifest_string.as_string_8
			end
		end

	as_utf_8 (manifest_string: READABLE_STRING_GENERAL): STRING
		do
			create Result.make (manifest_string.count)
			super_readable_general (manifest_string).append_to_utf_8 (Result)
		end

	copy_attributes (other: like Current)
		do
			Precursor (other); is_utf_8_encoded := other.is_utf_8_encoded
		end

	is_latin_1 (manifest_string: READABLE_STRING_GENERAL): BOOLEAN
		do
			if manifest_string.is_string_8 then
				Result := True
			else
				Result := manifest_string.is_valid_as_string_8
			end
		end

	new_item (interval: INTEGER_64): ZSTRING
		local
			s: EL_ZSTRING_ROUTINES; start_index, end_index: INTEGER_32
		do
			start_index := to_lower (interval); end_index := to_upper (interval)
			inspect format
				when {EL_TABLE_FORMAT}.indented, {EL_TABLE_FORMAT}.indented_eiffel then
				-- multiple lines
					Result := s.new_from_immutable_8 (manifest, start_index, end_index, True, is_utf_8_encoded)
			else
				create Result.make (end_index - start_index + 1)
				if is_utf_8_encoded then
					Result.append_utf_8 (manifest.shared_substring (start_index, end_index))
				else
					Result.append_substring_general (manifest, start_index, end_index)
				end
			end
		end

	 utf_8_key (a_key: READABLE_STRING_GENERAL): IMMUTABLE_STRING_8
	 	do
			if attached Key_buffer.copied_general_as_utf_8 (a_key) as key then
				Result := Immutable_8.as_shared (key)
			end
	 	end

end