note
	description: "Basic interface to reflective object useful in parallel inheritance"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-23 12:18:23 GMT (Monday 23rd January 2023)"
	revision: "12"

deferred class
	EL_REFLECTIVE_I

inherit
	EL_MODULE_EIFFEL

	EL_SHARED_CLASS_ID

feature {NONE} -- Implementation

	new_field_info (name: STRING): detachable TUPLE [index, abstract_type, static_type: INTEGER]
		local
			l_current: REFLECTED_REFERENCE_OBJECT; i, count: INTEGER
		do
			create l_current.make (current_reflective)
			count := l_current.field_count
			from i := 1 until i > count or attached Result loop
				if l_current.field_name (i) ~ name then
					Result := [i, l_current.field_type (i), l_current.field_static_type (i)]
				else
					i := i + 1
				end
			end
		end

feature {NONE} -- Deferred

	current_reflective: EL_REFLECTIVE
		deferred
		end

	field_name_list: EL_STRING_LIST [STRING]
		deferred
		end

	field_table: EL_REFLECTED_FIELD_TABLE
		deferred
		end

feature -- Contract Support

	valid_field_names (names: STRING): BOOLEAN
		-- `True' if comma separated list of `names' are all valid field names
		local
			field_set: EL_FIELD_INDICES_SET
		do
			if names.is_empty then
				Result := True
			else
				create field_set.make_from_reflective (current_reflective, names)
				Result := field_set.is_valid
			end
		end

	valid_tuple_field_names (field_name, name_list: STRING): BOOLEAN
		local
			field_count: INTEGER
		do
			if attached new_field_info (field_name) as info
				and then {ISE_RUNTIME}.type_conforms_to (info.static_type, Class_id.TUPLE)
			then
				field_count := Eiffel.generic_count_of_type (info.static_type)
				Result := field_count = name_list.occurrences (',') + 1
			end
		end

	valid_table_field_names (table: EL_STRING_8_TABLE [ANY]): BOOLEAN
		local
			l_current: REFLECTED_REFERENCE_OBJECT; i, found_count, count: INTEGER
		do
			create l_current.make (current_reflective)
			count := l_current.field_count
			from i := 1 until i > count or attached Result loop
				if table.has (l_current.field_name (i)) then
					found_count := found_count + 1
				end
				i := i + 1
			end
			Result := found_count = table.count
		end

feature {NONE} -- Constants

	frozen Default_initial_values: EL_ARRAYED_LIST [FUNCTION [ANY]]
		-- array of functions returning a new value for result type
		once
			create Result.make_empty
		end

	frozen Default_representations: EL_STRING_8_TABLE [EL_FIELD_REPRESENTATION [ANY, ANY]]
		once
			create Result.make_size (0)
		end

	frozen Default_tuple_converters: EL_STRING_8_TABLE [
		FUNCTION [READABLE_STRING_GENERAL, EL_SPLIT_READABLE_STRING_LIST [READABLE_STRING_GENERAL]]
	]
		once
			create Result.make_size (0)
		end

	frozen Default_tuple_field_names: EL_STRING_8_TABLE [STRING]
		once
			create Result.make_size (0)
		end

	frozen Once_current_object: REFLECTED_REFERENCE_OBJECT
		once
			create Result.make (Current)
		end

end