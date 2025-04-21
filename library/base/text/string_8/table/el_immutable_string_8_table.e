note
	description: "[
		Implementation of ${EL_IMMUTABLE_STRING_TABLE} for keys and virtual items of type
		${IMMUTABLE_STRING_8} and initialized by a manifest string of type ${STRING_8}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-21 9:44:09 GMT (Monday 21st April 2025)"
	revision: "20"

class
	EL_IMMUTABLE_STRING_8_TABLE

inherit
	EL_IMMUTABLE_STRING_TABLE [STRING_8, IMMUTABLE_STRING_8]
		rename
			has_key_x as has_key,
			extended_string as super_readable_8
		undefine
			bit_count
		end

	EL_IMMUTABLE_KEY_8_LOOKUP

	EL_STRING_8_BIT_COUNTABLE [STRING_8]

create
	make, make_comma_separated, make_assignments, make_empty, make_subset, make_reversed

feature -- Status query

	has_key_code (a_code: INTEGER_64): BOOLEAN
		do
			Result := has_key (Key_buffer.integer_string (a_code))
		end

feature -- Access

	unidented_item_for_iteration: STRING_8
		local
			interval: INTEGER_64
		do
			interval := interval_item_for_iteration
			Result := Manifest_item.new_from_immutable_8 (manifest, to_lower (interval), to_upper (interval), True, False)
		end

feature {NONE} -- Implementation

	immutable_interval (a_str: IMMUTABLE_STRING_8): INTEGER_64
		local
			index_lower, index_upper: INTEGER
		do
			if attached Character_area_8.get (a_str, $index_lower, $index_upper) as l_area then
				Result := compact_interval (index_lower + 1, index_upper + 1)
			end
		end

	new_list (iterable_list: ITERABLE [IMMUTABLE_STRING_8]): EL_STRING_8_LIST
		do
			create Result.make_from_general (iterable_list)
		end

	new_shared (a_manifest: STRING_8): IMMUTABLE_STRING_8
		do
			Result := Immutable_8.new_substring (a_manifest.area, 0, a_manifest.count)
		end

	new_split_list: EL_SPLIT_IMMUTABLE_STRING_8_LIST
		do
			create Result.make_empty
		end

	new_substring (str: IMMUTABLE_STRING_8; start_index, end_index: INTEGER): IMMUTABLE_STRING_8
		do
			Result := str.shared_substring (start_index, end_index)
		end

end