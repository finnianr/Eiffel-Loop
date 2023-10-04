note
	description: "[
		Implementation of [$source EL_IMMUTABLE_STRING_TABLE] for keys and virtual items of type
		[$source IMMUTABLE_STRING_8] and initialized by a manifest string of type [$source STRING_8]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-14 9:16:25 GMT (Monday 14th August 2023)"
	revision: "8"

class
	EL_IMMUTABLE_STRING_8_TABLE

inherit
	EL_IMMUTABLE_STRING_TABLE [STRING_8, IMMUTABLE_STRING_8]
		rename
			has_key_x as has_key_8,
			string as string_8
		undefine
			bit_count
		end

	EL_IMMUTABLE_KEY_8_LOOKUP

	EL_STRING_8_BIT_COUNTABLE [STRING_8]

	EL_MODULE_STRING_8

create
	make, make_by_assignment, make_by_indented, make_empty, make_subset

feature {NONE} -- Implementation

	new_split_list: EL_SPLIT_IMMUTABLE_STRING_8_LIST
		do
			create Result.make_empty
		end

	new_shared (a_manifest: STRING_8): IMMUTABLE_STRING_8
		do
			Result := Immutable_8.new_substring (a_manifest.area, 0, a_manifest.count)
		end

	new_substring (start_index, end_index: INTEGER): IMMUTABLE_STRING_8
		do
			Result := manifest.shared_substring (start_index, end_index)
		end

end
