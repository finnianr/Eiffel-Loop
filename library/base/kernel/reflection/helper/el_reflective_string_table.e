note
	description: "[
		Map text fields conforming to ${EL_SUB [READABLE_STRING_GENERAL]} to a value in a
		single manifest string formatted as follows:

			key_1:
				Value One Line 1
				Value One Line 2
				..
			key_2:
				Value Two
				etc

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-22 15:53:48 GMT (Monday 22nd July 2024)"
	revision: "2"

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
		redefine
			new_instance_functions
		end

	EL_SHARED_STRING_8_BUFFER_SCOPES -- new_instance_functions

feature {NONE} -- Initialization

	make (a_table_text: READABLE_STRING_GENERAL)
		local
			key_value_map_list: EL_TABLE_INTERVAL_MAP_LIST; ir: EL_INTERVAL_ROUTINES
			start_index, end_index: INTEGER_32; compact_interval: INTEGER_64
		do
			table_text := a_table_text
			make_reflected
			create key_value_map_list.make (a_table_text)

			across String_8_scope as scope loop
				if attached field_table as table and then attached scope.best_item (40) as name
					and then attached key_value_map_list as list
				then
					from list.start until list.after loop
						start_index := ir.to_lower (list.item_key); end_index := ir.to_upper (list.item_key)
						name.wipe_out
						name.append_substring_general (a_table_text, start_index, end_index)
						if field_table.has_key_8 (name)
							and then attached field_table.found_item as field
							and then attached {EL_SUB [STRING_GENERAL]} field.value (Current) as field_value
						then
							compact_interval := list.item_value
							start_index := ir.to_lower (compact_interval); end_index := ir.to_upper (compact_interval)
							field_value.set_string (a_table_text, start_index, end_index)
						end
						list.forth
					end
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

	new_instance_functions: like Default_initial_values
		-- array of functions returning a new value for result type
		do
			create Result.make_from_array (<<
				agent: EL_SUB [STRING_8] do create Result.make_empty end,
				agent: EL_SUB [STRING_32] do create Result.make_empty end,
				agent: EL_SUB [ZSTRING] do create Result.make_empty end
			>>)
		end

feature {NONE} -- Deferred

	new_table_text: READABLE_STRING_GENERAL
		deferred
		end

feature {NONE} -- Internal attributes

	table_text: READABLE_STRING_GENERAL

feature {NONE} -- Constants

	EL_SUB_type: INTEGER
		once
			Result := ({EL_SUB [STRING_GENERAL]}).type_id
		end
end