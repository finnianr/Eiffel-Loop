note
	description: "[
		Routines for creating instances of factory classes. Accessible via ${EL_MODULE_FACTORY}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-15 6:36:23 GMT (Tuesday 15th April 2025)"
	revision: "9"

class
	EL_FACTORY_ROUTINES_IMP

inherit
	REFLECTOR
		export
			{NONE} all
			{ANY} type_conforms_to
		end

	EL_TYPE_UTILITIES
		export
			{NONE} all
		end

feature -- Access

	parameterized_type_id (base_type: TYPE [ANY]; parameter_types: ARRAY [TYPE [ANY]]): INTEGER
		require
			same_parameter_count: parameter_count (base_type) = parameter_types.count
		local
			base_type_template, substituted_type_list: STRING_8; start_index, end_index, i: INTEGER
			interval_list: EL_SPLIT_INTERVALS
		do
			if attached type_parameters (base_type) as type_list and then type_list.count > 0 then
				substituted_type_list := type_list
				create interval_list.make (type_list, ',')
				if attached interval_list as list then
					i := parameter_types.count
					from list.finish until list.before or i = 0 loop
						start_index := list.item_lower + (i > 1).to_integer
						end_index := list.item_upper
						if attached parameter_types [i].name as name then
							substituted_type_list.replace_substring (name, start_index, end_index)
						end
						i := i - 1
						list.back
					end
				end
				base_type_template := base_type.name
				start_index := base_type_template.count - type_list.count
				end_index := base_type_template.count - 1
				base_type_template.replace_substring (substituted_type_list, start_index, end_index)
				Result := dynamic_type_from_string (base_type_template)
			end
		end

	substituted_type_id (factory_type, target_type: TYPE [ANY]; conforming_target_id: INTEGER): INTEGER
		-- type id of `factory_type' with all occurrences of `target_type' substituted for
		-- type name of `conforming_target_id'
		require
			conforms_to_target: type_conforms_to (conforming_target_id, target_type.type_id)
		local
			intervals: EL_OCCURRENCE_INTERVALS; class_type: STRING; conforming_name: IMMUTABLE_STRING_8
			lower, upper: INTEGER; sg: EL_STRING_GENERAL_ROUTINES
		do
			conforming_name := type_of_type (conforming_target_id).name
			create intervals.make_by_string (factory_type.name, target_type.name)
			class_type := factory_type.name
			if attached intervals as list then
				from list.finish until list.before loop
					lower := list.item_lower; upper := list.item_upper
					if sg.super_readable_8 (factory_type.name).is_identifier_boundary (lower, upper) then
						class_type.replace_substring (conforming_name, lower, upper)
					end
					list.back
				end
			end
			Result := dynamic_type_from_string (class_type)
		end

	type_hash_key (base_type: TYPE [ANY]; parameter_types: ARRAY [TYPE [ANY]]): NATURAL_64
		-- combine `base_type' and `parameter_types' into 64-bit hash key digest
		local
			type_array: SPECIAL [INTEGER]; math: EL_INTEGER_MATH; i, count: INTEGER
		do
			count := parameter_types.count
			if count > Type_array_table.count then
				create type_array.make_empty (count)
			else
				type_array := Type_array_table [count - 1]
				type_array.wipe_out
			end
			from i := 1 until i > count loop
				type_array.extend (parameter_types [i].type_id)
				i := i + 1
			end
			Result := math.hash_key (base_type.type_id, type_array)
		end

feature -- Factory

	new (factory_type: TYPE [ANY]; conforming_target_id: INTEGER): detachable ANY
		require
			valid_factory_type: valid_factory_type (factory_type, conforming_target_id)
		local
			factory_id: INTEGER
		do
			factory_id := Factory_type_id_table.item (
				factory_lookup_key (factory_type.type_id, conforming_target_id)
			)
			if factory_id > 0 and then attached new_instance_of (factory_id) as factory then
				Result := factory
			end
		end

feature -- Contract Support

	parameter_count (base_type: TYPE [ANY]): INTEGER
		do
			if attached type_parameters (base_type) as list and then list.count > 0 then
				Result := list.occurrences (',') + 1
			end
		end

	valid_factory_type (factory_type: TYPE [ANY]; conforming_target_id: INTEGER): BOOLEAN
		do
			Result := factory_type.generic_parameter_count = 1
				and then field_conforms_to (conforming_target_id, factory_type.generic_parameter_type (1).type_id)
		end

feature {NONE} -- Implementation

	factory_lookup_key (factory_id, conforming_target_id: INTEGER): NATURAL_64
		-- lookup key for `EL_FACTORY_TYPE_ID_TABLE'
		do
			Result := (factory_id.to_natural_64 |<< 32) | conforming_target_id.to_natural_64
		end

feature {NONE} -- Constants

	Factory_type_id_table: EL_FACTORY_TYPE_ID_TABLE
		once
			create Result.make (17)
		end

	Type_array_table: SPECIAL [SPECIAL [INTEGER]]
		-- table of ascending sizes of integer arrays
		local
			array: SPECIAL [INTEGER]
		once
			create Result.make_empty (5)
			from until Result.count = Result.capacity loop
				create array.make_filled (0, Result.count + 1)
				Result.extend (array)
			end
		end

end