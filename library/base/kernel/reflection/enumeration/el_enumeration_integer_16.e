note
	description: "${INTEGER_16} enumeration with descriptive text specifing codes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-23 16:39:51 GMT (Wednesday 23rd April 2025)"
	revision: "2"

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

	EL_STRING_HANDLER

	EL_INTERVAL_ROUTINES_I

feature {NONE} -- Initialization

	make (table_text: READABLE_STRING_GENERAL)
		local
			utf_8_table: EL_IMMUTABLE_UTF_8_TABLE; sg: EL_STRING_GENERAL_ROUTINES
			compact_interval: INTEGER_64
		do
			make_reflected
			if attached sg.super_readable_general (new_table_text).to_utf_8 as utf_8_text then
				create utf_8_table.make_utf_8 ({EL_TABLE_FORMAT}.Indented_eiffel, utf_8_text)
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

	is_integer_16_field (field: EL_FIELD_TYPE_PROPERTIES): BOOLEAN
		do
			Result := field.abstract_type = {REFLECTOR_CONSTANTS}.Integer_16_type
		end

feature {NONE} -- Deferred

	new_table_text: READABLE_STRING_GENERAL
		deferred
		end

end