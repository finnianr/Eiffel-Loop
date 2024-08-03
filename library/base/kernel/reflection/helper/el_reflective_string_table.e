note
	description: "[
		Map text fields conforming to ${EL_SUBSTRING [STRING_GENERAL]} to a value in a
		single manifest string formatted as follows:

			key_1:
				Value One Line 1
				Value One Line 2
				..
			key_2:
				Value Two
				etc

	]"
	descendants: "[
			EL_REFLECTIVE_STRING_TABLE*
				${HTTP_STATUS_TABLE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-03 13:00:20 GMT (Saturday 3rd August 2024)"
	revision: "5"

deferred class
	EL_REFLECTIVE_STRING_TABLE

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_substring_field,
			foreign_naming as eiffel_naming,
			make_default as make_reflected
		export
			{NONE} all
		end

	STRING_HANDLER undefine is_equal end

feature {NONE} -- Initialization

	make (table_text: READABLE_STRING_GENERAL)
		local
			utf_8_table: EL_IMMUTABLE_UTF_8_TABLE; ir: EL_INTERVAL_ROUTINES
			start_index, end_index: INTEGER_32; compact_interval: INTEGER_64
			s: EL_STRING_8_ROUTINES
		do
			make_reflected
			if attached {STRING_8} table_text as str_8 and then s.is_ascii_string_8 (str_8) then
				create utf_8_table.make_field_map_utf_8 (str_8)
			else
				create utf_8_table.make_field_map (table_text)
			end

			if attached utf_8_table as table then
				from table.start until table.after loop
					if field_table.has_key_8 (table.utf_8_key_for_iteration)
						and then attached field_table.found_item as field
						and then attached {EL_SUBSTRING [STRING_GENERAL]} field.value (Current) as field_value
					then
						compact_interval := table.interval_item_for_iteration
						start_index := ir.to_lower (compact_interval); end_index := ir.to_upper (compact_interval)
						field_value.set_string (table.manifest, start_index, end_index)
					end
					table.forth
				end
			end
		end

	make_default
		do
			make (new_table_text)
		end

feature {NONE} -- Field tests

	is_substring_field (field: EL_FIELD_TYPE_PROPERTIES): BOOLEAN
		do
			Result := field.conforms_to (EL_SUB_type)
		end

feature {NONE} -- Deferred

	new_table_text: READABLE_STRING_GENERAL
		deferred
		end

feature {NONE} -- Constants

	EL_SUB_type: INTEGER
		once
			Result := ({EL_SUBSTRING [STRING_GENERAL]}).type_id
		end
end