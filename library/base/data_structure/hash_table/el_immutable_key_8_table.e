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
	date: "2008-04-21 19:24:48 GMT (Monday 21st April 2008)"
	revision: "7"

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
	 default_create, make_assignments, make, make_equal, make_from_map_list, make_from_keys,
	 make_from_manifest_32, make_from_manifest_8

end