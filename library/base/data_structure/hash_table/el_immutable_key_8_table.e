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
	date: "2025-04-29 7:35:15 GMT (Tuesday 29th April 2025)"
	revision: "9"

class
	EL_IMMUTABLE_KEY_8_TABLE [G]

inherit
	EL_HASH_TABLE [G, IMMUTABLE_STRING_8]
		rename
			append_tuples as append_immutable_tuples,
			has as has_immutable,
			has_key as has_immutable_key,
			make_assignments as make_immutable_assignments,
			MANIFEST_ARRAY as IMMUTABLE_MANIFEST_ARRAY
		end

	EL_IMMUTABLE_KEY_8_LOOKUP

create
	 default_create, make_assignments, make, make_equal, make_one,
	 make_from_map_list, make_from_keys, make_from_manifest_32, make_from_manifest_8

feature {NONE} -- Initialization

	make_assignments (array: ARRAY [like name_and_value])
		do
			make_equal (array.count)
			across array as a loop
				if attached a.item as pair then
					extend (pair.value, Immutable_8.as_shared (pair.name))
				end
			end
		end

feature -- Element change

	append_tuples (array: ARRAY [like name_and_value])
		local
			new_count: INTEGER
		do
			new_count := count + array.count
			if new_count > capacity then
				accommodate (new_count)
			end
			across array as a loop
				if attached a.item as pair then
					force (pair.value, Immutable_8.as_shared (pair.name))
				end
			end
		end

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

feature {NONE} -- Implementation

	name_and_value: TUPLE [name: STRING; value: G]
		do
			create Result
		end

end