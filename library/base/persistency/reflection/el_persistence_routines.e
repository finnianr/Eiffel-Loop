note
	description: "Summary description for {EL_PERSISTENCE_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-01-25 9:50:02 GMT (Wednesday 25th January 2017)"
	revision: "1"

class
	EL_PERSISTENCE_ROUTINES

inherit
	EL_REFLECTION

	EL_STRING_CONSTANTS

feature {NONE} -- Implementation

	set_fields_of_type (type: TYPE [ANY]; word_separator: CHARACTER; new_object: FUNCTION [STRING, ANY])
		require
			reference_type: not type.is_expanded
			type_same_as_function_result_type: new_object.generating_type.generic_parameter_type (2) ~ type
		local
			object: like current_object; i, field_count: INTEGER
			field_names: like current_field_names
		do
			object := current_object
			field_count := object.field_count
			field_names := current_field_names (word_separator)
			from i := 1 until i > field_count loop
				if object.field_static_type (i) = type.type_id then
					object.set_reference_field (i, new_object (field_names [i]))
				end
				i := i + 1
			end
		end

	fill_field_table (table: EL_FIELD_VALUE_TABLE [ANY]; except_fields: ARRAY [STRING]; word_separator: CHARACTER)
		local
			object: like current_object; i, field_count, type_id: INTEGER
			field_names: like current_field_names; excluded_indices: like new_field_indices_set
			is_expanded_type: BOOLEAN
		do
			object := current_object
			field_count := object.field_count
			field_names := current_field_names (word_separator)
			excluded_indices := Excluded_fields_by_type.item ({like Current}, agent new_field_indices_set (except_fields))
			if table.value_type.is_expanded then
				type_id := table.value_type_id
				is_expanded_type := True
			else
				type_id := table.value_type.type_id
			end
			from i := 1 until i > field_count loop
				excluded_indices.binary_search (i)
				if not excluded_indices.found then
					if is_expanded_type then
						if object.field_type (i) = type_id then
							table.set_value (field_names [i], object, i)
						end
					else
						if object.field_static_type (i) = type_id then
							table.set_value (field_names [i], object, i)
						end
					end
				end
				i := i + 1
			end
		end

	current_field_names (word_separator: CHARACTER): like new_field_names
		do
			if word_separator = '_' then
				Result := Field_names_by_type.item ({like Current}, agent new_field_names)
			else
				Result := Adapted_field_names_by_type.item ({like Current}, agent new_adapted_field_names (word_separator))
			end
		end

	new_adapted_field_names (word_separator: CHARACTER): ARRAY [STRING]
		-- Adapt field name with a different word separator
		do
			Result := new_field_names
			Result.do_all (agent String_8.replace_character (?, '_', word_separator))
		end

	new_field_names: ARRAY [STRING]
		local
			object: like current_object; i, field_count: INTEGER
		do
			object := current_object; field_count := object.field_count

			create Result.make_filled (Empty_string_8, 1, field_count)
			from i := 1 until i > field_count loop
				Result [i] := object.field_name (i)
				i := i + 1
			end
		end

feature {NONE} -- Constants

	Excluded_fields_by_type: EL_TYPE_TABLE [SORTABLE_ARRAY [INTEGER]]
		once
			create Result.make_equal (19)
		end

	Field_names_by_type: EL_TYPE_TABLE [ARRAY [STRING]]
		once
			create Result.make_equal (19)
		end

	Adapted_field_names_by_type: EL_TYPE_TABLE [ARRAY [STRING]]
		once
			create Result.make_equal (19)
		end

end
