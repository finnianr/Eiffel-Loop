note
	description: "Internal reflection routines accessible via [$source EL_MODULE_EIFFEL]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-14 12:04:07 GMT (Thursday 14th May 2020)"
	revision: "11"

class
	EL_INTERNAL

inherit
	INTERNAL

	SED_UTILITIES
		export
			{ANY} abstract_type
		end

	EL_REFLECTION_CONSTANTS

	EL_SHARED_CLASS_ID

feature -- Type queries

	field_conforms_to_collection (basic_type, type_id: INTEGER): BOOLEAN
		-- True if `type_id' conforms to COLLECTION [X] where x is a string or an expanded type
		do
			if is_reference (basic_type) then
				Result := String_collection_type_table.has_conforming (type_id)
								or else Numeric_collection_type_table.has_conforming (type_id)
								or else Other_collection_type_table.has_conforming (type_id)
			end
		end

	field_conforms_to_date_time (basic_type, type_id: INTEGER): BOOLEAN
		do
			Result := is_reference (basic_type) and then field_conforms_to (type_id, Class_id.DATE_TIME)
		end

	field_conforms_to_one_of (basic_type, type_id: INTEGER; types: ARRAY [INTEGER]): BOOLEAN
		-- True if `type_id' conforms to one of `types'
		do
			Result := is_reference (basic_type) and then conforms_to_one_of (type_id, types)
		end

	is_reference (basic_type: INTEGER): BOOLEAN
		do
			Result := basic_type = Reference_type
		end

	is_storable_type (basic_type, type_id: INTEGER_32): BOOLEAN
		do
			inspect basic_type
				when Reference_type then
					Result := String_type_table.type_array.has (type_id) or else Storable_type_table.has_conforming (type_id)
				when Pointer_type then
					Result := False
			else
				Result := True
			end
		end

	is_string_or_expanded_type (basic_type, type_id: INTEGER): BOOLEAN
		do
			inspect basic_type
				when Reference_type then
					Result := String_type_table.type_array.has (type_id)
				when Pointer_type then
			else
				Result := True
			end
		end

	is_type_convertable_from_string (basic_type, type_id: INTEGER): BOOLEAN
		-- True if field is either an expanded type (with the exception of POINTER) or conforms to one of following types
		-- 	STRING_GENERAL, EL_DATE_TIME, EL_MAKEABLE_FROM_STRING_GENERAL, BOOLEAN_REF, EL_PATH
		do
			inspect basic_type
				when Reference_type then
					Result := String_type_table.type_array.has (type_id)
									or else String_convertable_type_table.has_conforming (type_id)
									or else Makeable_from_string_type_table.has_conforming (type_id)

				when Pointer_type then
					-- Exclude pointer
			else
				-- is expanded type
				Result := True
			end
		end

feature -- Access

	new_object (type: TYPE [ANY]): detachable ANY
		do
			Result := new_instance_of (type.type_id)
		end

	new_factory_instance (factory_type, type: TYPE [ANY]): detachable ANY
		require
			valid_factory_type: valid_factory_type (factory_type, type)
		local
			type_id: INTEGER
		do
			if Factory_type_id_table.has_key (type) then
				type_id := Factory_type_id_table.found_item
			else
				type_id := new_factory_type_id (factory_type, type)
				Factory_type_id_table.extend (type_id, type)
			end
			if type_id > 0 and then attached new_instance_of (type_id) as new then
				Result := new
			end
		end

	reflected (a_object: ANY): EL_REFLECTED_REFERENCE_OBJECT
		do
			create Result.make (a_object)
		end

	type_from_string (class_type: STRING): TYPE [ANY]
		local
			type_id: INTEGER
		do
			type_id := dynamic_type_from_string (class_type)
			if type_id > 0 then
				Result := type_of_type (type_id)
			end
		end

feature -- Contract Support

	valid_factory_type (factory_type, type: TYPE [ANY]): BOOLEAN
		do
			Result := factory_type.generic_parameter_count = 1
				and then field_conforms_to (type.type_id, factory_type.generic_parameter_type (1).type_id)
		end

feature {NONE} -- Implementation

	conforms_to_one_of (type_id: INTEGER; types: ARRAY [INTEGER]): BOOLEAN
		-- True if `type_id' conforms to one of `types'
		local
			i: INTEGER
		do
			from i := 1 until Result or i > types.count loop
				Result := field_conforms_to (type_id, types [i])
				i := i + 1
			end
		end

	new_template (type: TYPE [ANY]): STRING_8
		do
			Result := type.name
		end

	new_factory_type_id (factory_type, type: TYPE [ANY]): INTEGER
		require
			valid_factory_type: valid_factory_type (factory_type, type)
		local
			l_type_name: STRING; left_pos, right_pos: INTEGER
		do
			l_type_name := Factory_template_table.item (factory_type).twin
			left_pos := l_type_name.index_of ('[', 1)
			if left_pos > 0 then
				right_pos := l_type_name.index_of (']', left_pos + 1)
			end
			if left_pos > 0 and right_pos > 0 then
				l_type_name.replace_substring (type.name, left_pos + 1, right_pos - 1)
				Result := dynamic_type_from_string (l_type_name)
			end
		end

feature {NONE} -- Constants

	Factory_type_id_table: HASH_TABLE [INTEGER, TYPE [ANY]]
		once
			create Result.make (17)
		end

	Factory_template_table: EL_CACHE_TABLE [STRING_8, TYPE [ANY]]
		once
			create Result.make (17, agent new_template)
		end
end
