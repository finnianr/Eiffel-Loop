note
	description: "Hash table conforming to ${EL_HASH_TABLE} [G, ${IMMUTABLE_STRING_8}]"
	descendants: "[
			EL_IMMUTABLE_KEY_8_TABLE [G]
				${EL_OBJECT_FIELDS_TABLE}
				${EL_FIELD_TABLE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-04 15:05:12 GMT (Thursday 4th April 2024)"
	revision: "4"

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