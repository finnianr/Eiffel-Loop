note
	description: "${INTEGER_16} enumeration with descriptive text specifing codes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-24 16:48:12 GMT (Thursday 24th April 2025)"
	revision: "4"

deferred class
	EL_ENUMERATION_INTEGER_16

inherit
	REFLECTOR_CONSTANTS
		export
			{NONE} all
		end

	EL_REFLECTION_HANDLER

	EL_INTERVAL_ROUTINES_I
		rename
			count as interval_count
		end

	EL_MODULE_CONVERT_STRING; EL_MODULE_EIFFEL

	EL_SHARED_IMMUTABLE_8_MANAGER

feature {NONE} -- Initialization

	make_with (table_text: READABLE_STRING_GENERAL)
		local
			interval: INTEGER_64; l_interval_table: HASH_TABLE [INTEGER_64, INTEGER_16]
			code: INTEGER_16; start_index, space_index: INTEGER; sg: EL_STRING_GENERAL_ROUTINES
			i: INTEGER
		do
			utf_8_text := Immutable_8.as_shared (sg.super_readable_general (table_text).to_utf_8)

			if attached new_utf_8_table as table and then attached Eiffel.reflected (Current) as l_current
				and then attached l_current.new_field_type_set (Integer_16_type) as field_set
			then
				count := field_set.count
				create l_interval_table.make (count)
				across field_set.area as index loop
					i := index.item
					if table.has_key (l_current.field_name (i)) then
						interval := table.found_interval
						start_index := to_lower (interval)
						space_index := utf_8_text.index_of (' ', start_index)
						if space_index > 0 and then attached Convert_string.integer_16 as integer_16
							and then integer_16.is_substring_convertible (utf_8_text, start_index + 1, space_index - 1)
						then
							code := integer_16.substring_as_type (utf_8_text, start_index + 1, space_index - 1)
							l_interval_table.put (interval, code)
							l_current.set_integer_16_field (i, code)
						end
					end
				end
			end
			create interval_table.make (l_interval_table)
		ensure
			all_fields_assigned: valid_description_keys
		end

	make
		do
			make_with (new_table_text)
		end

feature -- Access

	description (code: INTEGER_16): ZSTRING
		local
			interval: INTEGER_64
		do
			if interval_table.has_key (code) then
				interval := interval_table.found_item
				create Result.make_from_utf_8 (utf_8_text.substring (to_lower (interval) + 1, to_upper (interval)))
				Result.prune_all ('%T')
			else
				create Result.make_empty
			end
		end

	field_name (code: INTEGER_16): IMMUTABLE_STRING_8
		local
			interval: INTEGER_64; i, start_index, end_index: INTEGER
			break: BOOLEAN
		do
			if interval_table.has_key (code) and then attached utf_8_text as text then
				interval := interval_table.found_item
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
			else
				create Result.make_empty
			end
		end

	name (code: INTEGER_16): STRING
		do
			Result := field_name (code)
		end

feature -- Status query

	valid_description_keys: BOOLEAN
		do
			Result := count = interval_table.count
		end

feature -- Measurement

	count: INTEGER

feature {NONE} -- Field tests

	is_integer_16_field (field: EL_FIELD_TYPE_PROPERTIES): BOOLEAN
		do
			Result := field.abstract_type = {REFLECTOR_CONSTANTS}.Integer_16_type
		end

feature {NONE} -- Implementation

	new_utf_8_table: EL_IMMUTABLE_UTF_8_TABLE
		do
			create Result.make_utf_8 ({EL_TABLE_FORMAT}.Indented_eiffel, utf_8_text)
		end

feature {NONE} -- Deferred

	new_table_text: READABLE_STRING_GENERAL
		deferred
		end

feature {NONE} -- Internal attributes

	interval_table: EL_INTEGER_16_SPARSE_ARRAY [INTEGER_64]
		-- map code to description substring compact interval

	utf_8_text: IMMUTABLE_STRING_8
end