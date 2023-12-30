note
	description: "[
		Routines for creating instances of factory classes. Accessible via [$source EL_MODULE_FACTORY].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-30 11:58:04 GMT (Saturday 30th December 2023)"
	revision: "2"

class
	EL_FACTORY_ROUTINES_IMP

inherit
	REFLECTOR
		export
			{NONE} all
			{ANY} type_conforms_to
		end

feature -- Access

	substituted_type_id (factory_type, target_type: TYPE [ANY]; conforming_target_id: INTEGER): INTEGER
		-- type id of `factory_type' with all occurrences of `target_type' substituted for
		-- type name of `conforming_target_id'
		require
			conforms_to_target: type_conforms_to (conforming_target_id, target_type.type_id)
		local
			intervals: EL_OCCURRENCE_INTERVALS; s_8: EL_STRING_8_ROUTINES
			class_type: STRING; conforming_name: IMMUTABLE_STRING_8
			lower, upper: INTEGER
		do
			conforming_name := type_of_type (conforming_target_id).name
			create intervals.make_by_string (factory_type.name, target_type.name)
			class_type := factory_type.name
			if attached intervals as list then
				from list.finish until list.before loop
					lower := list.item_lower; upper := list.item_upper
					if s_8.is_identifier_boundary (factory_type.name, lower, upper) then
						class_type.replace_substring (conforming_name, lower, upper)
					end
					list.back
				end
			end
			Result := dynamic_type_from_string (class_type)
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

end