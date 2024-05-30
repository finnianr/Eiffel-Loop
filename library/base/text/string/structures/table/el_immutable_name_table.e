note
	description: "Readonly table of names for an array of numeric constants"
	notes: "[
		The names are of type ${IMMUTABLE_STRING_8} using shared character data from a single
		${SPECIAL [CHARACTER]} array.
		
		If the table is initialized with a ${READABLE_STRING_GENERAL} name list, then
		the name items maybe either UTF-8 or Latin-1 encoded
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-30 10:24:16 GMT (Thursday 30th May 2024)"
	revision: "6"

class
	EL_IMMUTABLE_NAME_TABLE [N -> {NUMERIC, HASHABLE}]

inherit
	EL_HASH_TABLE [IMMUTABLE_STRING_8, N]
		rename
			make as make_from_tuples,
			current_keys as valid_keys,
			item as item_8 alias "[]",
			found_item as found_item_8
		export
			{NONE} put, force, extend
		redefine
			valid_keys
		end

	EL_SHARED_STRING_8_CURSOR

	STRING_HANDLER
		undefine
			copy, default_create, is_equal
		end

create
	make, make_general

feature {NONE} -- Initialization

	make (a_valid_keys: ARRAY [N]; a_name_list: READABLE_STRING_8)
		require
			name_count_matches: a_valid_keys.count = a_name_list.occurrences (',') + 1
		local
			split_list: EL_SPLIT_IMMUTABLE_STRING_8_LIST
		do
			make_size (a_valid_keys.count)
			valid_keys := a_valid_keys
			if a_name_list.is_immutable and then attached {like item_8} a_name_list as immutable then
				create split_list.make_adjusted (immutable, ',', {EL_SIDE}.Left)
			else
				create split_list.make_shared_adjusted (a_name_list.as_string_8, ',', {EL_SIDE}.Left)
			end
			name_list_8 := split_list.target_string

			if attached split_list as list then
				from list.start until list.after or not a_valid_keys.valid_index (list.index) loop
					put (list.item, a_valid_keys [list.index])
					check
						unique_keys: inserted
					end
					list.forth
				end
			end
		ensure
			full: count = valid_keys.count
		end

	make_general (a_valid_keys: ARRAY [N]; a_name_list: READABLE_STRING_GENERAL)
		local
			c: UTF_CONVERTER
		do
			if a_name_list.is_string_8 and then attached {READABLE_STRING_8} a_name_list as str_8 then
				make (a_valid_keys, str_8)

			elseif a_name_list.is_valid_as_string_8 then
				make (a_valid_keys, a_name_list.to_string_8)

			else
			-- Convert to UTF-8
				make (a_valid_keys, c.string_32_to_utf_8_string_8 (a_name_list.to_string_32))
				is_utf_8 := True
			end
		end

feature -- Status query

	is_utf_8: BOOLEAN
		-- `True' if `item_8', `found_item_8' and `name_list_8' are UTF-8 encoded
		-- otherwise the encoding is Latin-1

feature -- Access

	found_item: ZSTRING
		do
			Result := to_zstring (found_item_8)
		end

	found_item_32: STRING_32
		do
			Result := to_string_32 (found_item_8)
		end

	item (key: N): ZSTRING
		do
			Result := to_zstring (item_8 (key))
		end

	item_32 (key: N): STRING_32
		do
			Result := to_string_32 (item_8 (key))
		end

	name_list: ZSTRING
		do
			Result := to_zstring (name_list_8)
		end

	name_list_32: STRING_32
		do
			Result := to_string_32 (name_list_8)
		end

	name_list_8: IMMUTABLE_STRING_8
		-- raw name list which maybe encoded as either Latin-1 or UTF-8

	valid_keys: ARRAY [N]

feature {NONE} -- Implementation

	to_zstring (immutable_str_8: like item_8): ZSTRING
		do
			if attached immutable_str_8 as str_8 then
				if is_utf_8 then
					create Result.make_from_utf_8 (str_8)
				else
					create Result.make_from_general (str_8)
				end
			else
				create Result.make_empty
			end

		end

	to_string_32 (immutable_str_8: like item_8): STRING_32
		local
			utf_8: EL_UTF_8_CONVERTER
		do
			if attached immutable_str_8 as str_8 then
				if is_utf_8 then
					Result := utf_8.to_string_32 (str_8)
				else
					Result := str_8.to_string_32
				end
			else
				create Result.make_empty
			end
		end

end