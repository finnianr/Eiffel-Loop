note
	description: "[
		Implementation of [$source EL_IMMUTABLE_STRING_TABLE] for keys and virtual items of type
		[$source IMMUTABLE_STRING_32] and initialized by a manifest string of type [$source STRING_32]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-15 10:37:39 GMT (Saturday 15th July 2023)"
	revision: "2"

class
	EL_IMMUTABLE_STRING_32_TABLE

inherit
	EL_IMMUTABLE_STRING_TABLE [STRING_32, IMMUTABLE_STRING_32]

	EL_SHARED_IMMUTABLE_32_MANAGER

create
	make

feature {NONE} -- Implementation

	new_split_list: EL_SPLIT_IMMUTABLE_STRING_32_LIST
		do
			create Result.make_empty
		end

	new_shared (a_manifest: STRING_32): IMMUTABLE_STRING_32
		do
			Result := Immutable_32.new_substring (a_manifest.area, 0, a_manifest.count)
		end

	new_substring (start_index, end_index: INTEGER): IMMUTABLE_STRING_32
		do
			Result := manifest.shared_substring (start_index, end_index)
		end

end