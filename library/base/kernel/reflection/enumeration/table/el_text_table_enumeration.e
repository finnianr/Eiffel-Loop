note
	description: "Enumeration based on a table of text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 17:09:28 GMT (Monday 28th April 2025)"
	revision: "1"

deferred class
	EL_TEXT_TABLE_ENUMERATION [N -> HASHABLE]

inherit
	EL_ENUMERATION_TEXT [N]
		rename
			new_interval_table as new_interval_hash_table
		end

	EL_MODULE_EIFFEL

	EL_SHARED_STRING_8_BUFFER_POOL

feature {NONE} -- Initialization

	initialize
		do
		end

	make
		do
			make_with (new_table_text)
		end

	make_with (table_text: READABLE_STRING_GENERAL)
		local
			field_list: EL_FIELD_LIST
		do
			set_utf_8_text (table_text)

			create field_list.make_abstract (Current, Eiffel.abstract_type_of_type (({N}).type_id))
			count := field_list.count
			interval_table := new_interval_table (new_interval_hash_table (field_list))
			across interval_table.key_list as list loop
				field_list [list.cursor_index].set_from_integer (Current, as_integer (list.item))
			end
			initialize
		ensure
			all_fields_assigned: valid_table_keys
		end

feature -- Access

	as_list: EL_ARRAYED_LIST [N]
		do
			Result := interval_table.key_list
			Result.sort (True)
		end

	field_name (a_value: N): IMMUTABLE_STRING_8
		do
			if interval_table.has_key (a_value) then
				Result := field_name_for_interval (interval_table.found_item, utf_8_text)
			else
				create Result.make_empty
			end
		end

	found_value: N
		do
			Result := as_enum (internal_found_value)
		end

	name (a_value: N): STRING
		do
			if attached name_translater as translater then
				Result := translater.exported (field_name (a_value))
			else
				Result := field_name (a_value)
			end
		end

	value (a_name: like name): N
		-- enumuration value from exported `a_name'
		-- Eg. all uppercase "AUD" for `EL_CURRENCY_ENUM' returns value for field `aud: NATURAL_8'
		require
			valid_name: valid_name (a_name)
		do
			if has_name (a_name) then
				Result := found_value
			else
				check
					value_found: False
				end
			end
		end

feature -- Measurement

	count: INTEGER

feature -- Status query

	has_field_name (a_name: like field_name): BOOLEAN
		-- `True' if `Current' has a field name `field_name'
		-- Sets `found_value' to code value if found.
		-- Eg. all lowercase "aud" for `EL_CURRENCY_ENUM' sets value for field `aud: NATURAL_8'
		do
			Result := internal_has_field_name (a_name, True)
		end

	has_name (a_name: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `Current' has translated `a_name'
		-- Sets `found_value' to code value if found.
		-- Eg. all uppercase "AUD" for `EL_CURRENCY_ENUM' sets value for field `aud: NATURAL_8'
		do
			Result := internal_has_field_name (to_field_name (a_name), True)
		end

	valid_name (a_name: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := internal_has_field_name (to_field_name (a_name), False)
		end

feature {NONE} -- Implementation

	field_name_for_interval (interval: INTEGER_64; text: like utf_8_text): IMMUTABLE_STRING_8
		local
			i, start_index, end_index: INTEGER; break: BOOLEAN
		do
			end_index := to_lower (interval) - 3
			from i := end_index - 1 until i = 0 or break loop
				if text [i] = '%N' then
					start_index := i; break := True
				else
					i := i - 1
				end
			end
			start_index := start_index + 1
			Result := text.shared_substring (start_index, end_index)
		end

	default_translater: detachable EL_NAME_TRANSLATER
		-- rename `name_translater' to `default_translater' for `name' to return copy of `field_name'
		do
		end

	internal_has_field_name (a_name: like field_name; set_found_value: BOOLEAN): BOOLEAN
		do
			if attached utf_8_text as text then
				across interval_table as table until Result loop
					if field_name_for_interval (table.item, text) ~ a_name then
						if set_found_value then
							internal_found_value := as_integer (table.key)
						end
						Result := True
					end
				end
			end
		end

	to_field_name (a_name: READABLE_STRING_GENERAL): like field_name
		do
			if attached String_8_pool.borrowed_item as borrowed then
				Result := Immutable_8.as_shared (name_translater.imported (borrowed.to_same (a_name)))
				borrowed.return
			end
		end

feature {NONE} -- Deferred

	name_translater: detachable EL_NAME_TRANSLATER
		-- implement in descendant to make `name' an exported version of `field_name'
		deferred
		end

	new_interval_table (hash_table: HASH_TABLE [INTEGER_64, N]): EL_SPARSE_ARRAY_TABLE [INTEGER_64, N]
		deferred
		end

	new_table_text: READABLE_STRING_GENERAL
		deferred
		end

feature {NONE} -- Internal attributes

	internal_found_value: INTEGER

	interval_table: like new_interval_table
		-- map code to description substring compact interval

end