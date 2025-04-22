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
	date: "2025-04-21 16:49:23 GMT (Monday 21st April 2025)"
	revision: "16"

deferred class
	EL_REFLECTIVE_STRING_TABLE

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_manifest_substring,
			foreign_naming as eiffel_naming,
			make_default as make_reflected
		export
			{NONE} all
		end

	EL_STRING_HANDLER

	EL_INTERVAL_ROUTINES_I

feature {NONE} -- Initialization

	make (table_text: READABLE_STRING_GENERAL)
		local
			utf_8_table: EL_IMMUTABLE_UTF_8_TABLE; sg: EL_STRING_GENERAL_ROUTINES
			compact_interval: INTEGER_64
		do
			make_reflected
			if table_text.is_string_8
				and then attached {READABLE_STRING_8} table_text as str_8
				and then sg.super_readable_8 (str_8).is_ascii
			then
				create utf_8_table.make_utf_8 ({EL_TABLE_FORMAT}.Indented_eiffel, str_8)
			else
				create utf_8_table.make ({EL_TABLE_FORMAT}.Indented_eiffel, table_text)
			end
			if attached utf_8_table as table then
				from table.start until table.after loop
					if field_table.has_immutable_key (table.key_for_iteration)
						and then attached {EL_REFLECTED_MANIFEST_SUBSTRING} field_table.found_item as substring_field
						and then attached substring_field.value (Current) as substring
					then
						compact_interval := table.interval_item_for_iteration
						substring.set_string (table.manifest, to_lower (compact_interval), to_upper (compact_interval))
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

	is_manifest_substring (field: EL_FIELD_TYPE_PROPERTIES): BOOLEAN
		do
			Result := field.is_manifest_substring
		end

feature {NONE} -- Deferred

	new_table_text: READABLE_STRING_GENERAL
		deferred
		end

feature {NONE} -- Type definitions

	ITEM_8: EL_MANIFEST_SUBSTRING_8
		require
			never_called: False
		once
			create Result.make_empty
		end

	ITEM_32: EL_MANIFEST_SUBSTRING_32
		require
			never_called: False
		once
			create Result.make_empty
		end

	ITEM_Z: EL_MANIFEST_SUB_ZSTRING
		require
			never_called: False
		once
			create Result.make_empty
		end

end