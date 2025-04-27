note
	description: "${INTEGER_16} enumeration with descriptive text specifing codes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-27 16:00:47 GMT (Sunday 27th April 2025)"
	revision: "6"

deferred class
	EL_ENUMERATION_INTEGER_16

inherit
	EL_ENUMERATION_TEXT [INTEGER_16]

	REFLECTOR_CONSTANTS
		export
			{NONE} all
		end

	EL_REFLECTION_HANDLER

	EL_MODULE_EIFFEL

	EL_SHARED_STRING_8_BUFFER_POOL

feature {NONE} -- Initialization

	make_with (table_text: READABLE_STRING_GENERAL)
		local
			i, index, i_upper: INTEGER; name_list: EL_STRING_8_LIST
		do
			set_utf_8_text (table_text)

			if attached Eiffel.reflected (Current) as l_current
				and then attached l_current.new_field_type_set (Integer_16_type) as field_set
			then
				count := field_set.count
				create name_list.make (count)
				i_upper := count - 1
				from i := 0 until i > i_upper loop
					index := field_set [i]
					name_list.extend (l_current.field_name (index))
					i := i + 1
				end
				create interval_table.make (new_interval_table (name_list))
				if attached interval_table.key_list as code_list then
					from i := 0 until i > i_upper loop
						index := field_set [i]
						l_current.set_integer_16_field (index, code_list [i + 1])
						i := i + 1
					end
				end
			end
			initialize
		ensure
			all_fields_assigned: valid_description_keys
		end

	make
		do
			make_with (new_table_text)
		end

	initialize
		do
		end

feature -- Access

	as_list: EL_ARRAYED_LIST [INTEGER_16]
		do
			Result := interval_table.key_list
			Result.sort (True)
		end

	field_name (code: INTEGER_16): IMMUTABLE_STRING_8
		do
			if interval_table.has_key (code) then
				Result := field_name_for_interval (interval_table.found_item, utf_8_text)
			else
				create Result.make_empty
			end
		end

	found_value: INTEGER_16
		do
			Result := internal_found_value.to_integer_16
		end

	name (code: INTEGER_16): STRING
		do
			if attached name_translater as translater then
				Result := translater.exported (field_name (code))
			else
				Result := field_name (code)
			end
		end

	value (a_name: like name): INTEGER_16
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

	valid_description_keys: BOOLEAN
		do
			Result := count = interval_table.count
		end

	valid_name (a_name: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := internal_has_field_name (to_field_name (a_name), False)
		end

feature -- Measurement

	count: INTEGER

feature {NONE} -- Implementation

	code_value (a_converter: like converter; start_index, end_index: INTEGER): INTEGER_16
		do
			 Result := a_converter.substring_as_type (utf_8_text, start_index, end_index)
		end

	converter: EL_READABLE_STRING_GENERAL_TO_NUMERIC [INTEGER_16]
		do
			Result := Convert_string.integer_16
		end

	default_translater: detachable EL_NAME_TRANSLATER
		-- rename `name_translater' to `default_translater' for `name' to return copy of `field_name'
		do
		end

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

	internal_has_field_name (a_name: like field_name; set_found_value: BOOLEAN): BOOLEAN
		do
			if attached utf_8_text as text then
				across interval_table as table until Result loop
					if field_name_for_interval (table.item, text) ~ a_name then
						if set_found_value then
							internal_found_value := table.key.to_integer_32
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

	new_table_text: READABLE_STRING_GENERAL
		deferred
		end

	name_translater: detachable EL_NAME_TRANSLATER
		-- implement in descendant to make `name' an exported version of `field_name'
		deferred
		end

feature {NONE} -- Internal attributes

	interval_table: EL_INTEGER_16_SPARSE_ARRAY [INTEGER_64]
		-- map code to description substring compact interval

	internal_found_value: INTEGER
end