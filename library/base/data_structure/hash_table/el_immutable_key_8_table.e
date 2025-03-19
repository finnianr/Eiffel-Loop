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
	date: "2025-03-15 11:10:37 GMT (Saturday 15th March 2025)"
	revision: "8"

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

feature -- Element change

	put_8 (new: G; key: READABLE_STRING_8)
			-- Insert `new' with `key' if there is no other item
			-- associated with the same key.
			-- Set `inserted' if and only if an insertion has
			-- been made (i.e. `key' was not present).
			-- If so, set `position' to the insertion position.
			-- If not, set `conflict'.
			-- In either case, set `found_item' to the item
			-- now associated with `key' (previous item if
			-- there was one, `new' otherwise).
		do
			put (new, Immutable_8.as_shared (key))
		end

end