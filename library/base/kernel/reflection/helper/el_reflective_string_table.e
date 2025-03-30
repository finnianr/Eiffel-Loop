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
	date: "2025-03-30 14:12:28 GMT (Sunday 30th March 2025)"
	revision: "12"

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

	EL_READABLE_STRING_GENERAL_ROUTINES_I
		export
			{NONE} all
		end

feature {NONE} -- Initialization

	make (table_text: READABLE_STRING_GENERAL)
		local
			utf_8_table: EL_IMMUTABLE_UTF_8_TABLE; ir: EL_INTERVAL_ROUTINES
			start_index, end_index: INTEGER_32; compact_interval: INTEGER_64
			s: EL_STRING_8_ROUTINES
		do
			make_reflected
			if attached {STRING_8} table_text as str_8 and then s.is_ascii_string_8 (str_8) then
				create utf_8_table.make_utf_8 ({EL_TABLE_FORMAT}.Indented_eiffel, str_8)
			else
				create utf_8_table.make ({EL_TABLE_FORMAT}.Indented_eiffel, table_text)
			end

			if attached utf_8_table as table then
				from table.start until table.after loop
					if field_table.has_immutable_key (table.key_for_iteration)
						and then attached {EL_REFLECTED_SUBSTRING} field_table.found_item as substring_field
						and then attached substring_field.value (Current) as substring
					then
						compact_interval := table.interval_item_for_iteration
						start_index := ir.to_lower (compact_interval); end_index := ir.to_upper (compact_interval)
						substring.set_string (table.manifest, start_index, end_index)
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
			Result := field.conforms_to (Class_id.EL_SUBSTRING__STRING_GENERAL)
		end

feature {NONE} -- Deferred

	new_table_text: READABLE_STRING_GENERAL
		deferred
		end

end