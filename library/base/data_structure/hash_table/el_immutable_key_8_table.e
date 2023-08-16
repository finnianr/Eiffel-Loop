note
	description: "Hash table conforming to [$source EL_HASH_TABLE [G, IMMUTABLE_STRING_8]]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-14 10:47:05 GMT (Monday 14th August 2023)"
	revision: "1"

class
	EL_IMMUTABLE_KEY_8_TABLE [G]

inherit
	EL_HASH_TABLE [G, IMMUTABLE_STRING_8]
		rename
			has as has_immutable,
			has_key as has_immutable_key
		end

	EL_IMMUTABLE_KEY_8_LOOKUP

create
	 default_create, make, make_size, make_equal, make_from_map_list, make_from_values,
	 make_from_manifest_32, make_from_manifest_8

end