note
	description: "${INTEGER_16} enumeration with descriptive text specifing codes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-23 19:12:54 GMT (Wednesday 23rd April 2025)"
	revision: "3"

deferred class
	EL_ENUMERATION_INTEGER_16

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_integer_16_field,
			foreign_naming as eiffel_naming,
			make_default as make_reflected
		export
			{NONE} all
		end

	EL_MODULE_CONVERT_STRING

	EL_STRING_HANDLER

	EL_INTERVAL_ROUTINES_I

feature {NONE} -- Initialization

	make (table_text: READABLE_STRING_GENERAL)
		local
			utf_8_table: EL_IMMUTABLE_UTF_8_TABLE; sg: EL_STRING_GENERAL_ROUTINES
			interval: INTEGER_64; l_interval_table: HASH_TABLE [INTEGER_64, INTEGER_16]
			code: INTEGER_16; start_index, space_index: INTEGER
		do
			make_reflected
			utf_8_text := sg.super_readable_general (new_table_text).to_utf_8
			create utf_8_table.make_utf_8 ({EL_TABLE_FORMAT}.Indented_eiffel, utf_8_text)
			create l_interval_table.make (field_list.count)

			if attached utf_8_table as table then
				from table.start until table.after loop
					if field_table.has_immutable_key (table.key_for_iteration)
						and then attached field_table.found_item as field
					then
						interval := table.interval_item_for_iteration
						start_index := to_lower (interval)
						space_index := utf_8_text.index_of (' ', start_index)
						if space_index > 0 and then attached Convert_string.integer_16 as integer_16
							and then integer_16.is_substring_convertible (utf_8_text, start_index + 1, space_index - 1)
						then
							code := integer_16.substring_as_type (utf_8_text, start_index + 1, space_index - 1)
							l_interval_table.put (interval, code)
							field.set_from_integer (Current, code.to_integer_32)
						end
					end
					table.forth
				end
			end
			create interval_table.make (l_interval_table)
		ensure
			all_fields_assigned: field_list.count = interval_table.count
		end

	make_default
		do
			make (new_table_text)
		end

feature -- Access

	description (value: INTEGER_16): ZSTRING
		local
			interval: INTEGER_64
		do
			if interval_table.has_key (value) then
				interval := interval_table.found_item
				create Result.make_from_utf_8 (utf_8_text.substring (to_lower (interval) + 1, to_upper (interval)))
				Result.prune_all ('%T')
			else
				create Result.make_empty
			end
		end

feature {NONE} -- Field tests

	is_integer_16_field (field: EL_FIELD_TYPE_PROPERTIES): BOOLEAN
		do
			Result := field.abstract_type = {REFLECTOR_CONSTANTS}.Integer_16_type
		end

feature {NONE} -- Deferred

	new_table_text: READABLE_STRING_GENERAL
		deferred
		end

feature {NONE} -- Internal attributes

	interval_table: EL_INTEGER_16_SPARSE_ARRAY [INTEGER_64]
		-- map code to description substring compact interval

	utf_8_text: STRING
end