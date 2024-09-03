note
	description: "Internal reflection routines accessible via ${EL_MODULE_EIFFEL}"
	notes: "[
		The ${INTERNAL} class has a problem with routines that use the once function
		`reflected_object' because the call will retain a reference to the argument inside
		the once object. Calling `dynamic_type' for example will retain a reference to the
		object being queryed.
		
		This can be a problem in situations which require that the object be GC collected when
		all references are removed. The object could be associated with a Java VM object for example.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-03 12:07:10 GMT (Tuesday 3rd September 2024)"
	revision: "36"

class
	EL_INTERNAL

inherit
	INTERNAL
		redefine
			dynamic_type
		end

	SED_UTILITIES
		rename
			abstract_type as abstract_type_of_type
		export
			{ANY} abstract_type_of_type
		end

	EL_REFLECTION_CONSTANTS; EL_STRING_8_CONSTANTS

	EL_SHARED_CLASS_ID
		rename
			Class_id as Class_id_
		end

	EL_SHARED_FACTORIES

create
	make

feature {NONE} -- Initialization

	make
		do
			class_id := Class_id_
		end

feature -- Type status

	field_conforms_to_collection (basic_type, type_id: INTEGER): BOOLEAN
		-- True if `type_id' conforms to COLLECTION [X] where x is a string or an expanded type
		do
			if is_reference (basic_type) then
				Result := type_conforms_to (type_id, class_id.COLLECTION__ANY)
			end
		end

	field_conforms_to_date_time (basic_type, type_id: INTEGER): BOOLEAN
		do
			Result := is_reference (basic_type) and then field_conforms_to (type_id, class_id.DATE_TIME)
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

	is_storable_type (basic_type, type_id: INTEGER): BOOLEAN
		-- `True' if type is storable using `EL_STORABLE' interface
		local
			tuple_types: EL_TUPLE_TYPE_ARRAY
		do
			if basic_type = Reference_type then
				if type_conforms_to (type_id, class_id.TUPLE) then
					create tuple_types.make_from_static (type_id)
--					TUPLE items must be expanded or strings
					Result := across tuple_types as type all
						type.item.is_expanded
							or else String_reference_types.there_exists (agent type_conforms_to (type.item.type_id, ?))
					end
				else
					Result := Storable_reference_types.there_exists (agent type_conforms_to (type_id, ?))
				end
			else
				Result := True
			end
		end

	is_string_or_expanded_type (basic_type, type_id: INTEGER): BOOLEAN
		do
			inspect basic_type
				when Reference_type then
					Result := String_reference_types.there_exists (agent type_conforms_to (type_id, ?))

				when Pointer_type then
					-- Exclude pointer
			else
				Result := True
			end
		end

	is_table_type (basic_type, type_id: INTEGER): BOOLEAN
		do
			if basic_type = Reference_type then
				Result := type_conforms_to (type_id, ({HASH_TABLE [ANY, HASHABLE]}).type_id)
			end
		end

	is_type_convertable_from_string (basic_type, type_id: INTEGER): BOOLEAN
		-- True if field is either an expanded type (with the exception of POINTER) or conforms to one of following types
		-- 	STRING_GENERAL, EL_DATE_TIME, EL_MAKEABLE_FROM_STRING_GENERAL, BOOLEAN_REF, EL_PATH
		do
			inspect basic_type
				when Reference_type then
					Result := Reference_field_list.has_conforming (type_id)

				when Pointer_type then
					-- Exclude pointer
			else
				-- is expanded type
				Result := True
			end
		end

	is_type_in_set (type_id: INTEGER; set: SPECIAL [INTEGER]): BOOLEAN
		local
			i: INTEGER
		do
			from until i = set.count or Result loop
				Result := type_id = set [i]
				i := i + 1
			end
		end

	is_storable_collection_type (type_id: INTEGER): BOOLEAN
		local
			item_type_id: INTEGER
		do
			item_type_id := collection_item_type (type_id)
			Result := is_storable_type (abstract_type_of_type (item_type_id), item_type_id)
		end

feature -- Conformance checking

	is_bag_type (type_id: INTEGER): BOOLEAN
		do
			Result := field_conforms_to (type_id, class_id.BAG__ANY)
		end

	is_comparable_type (type_id: INTEGER): BOOLEAN
		do
			Result := field_conforms_to (type_id, class_id.COMPARABLE)
		end

	is_conforming_to (object: ANY; type_id: INTEGER): BOOLEAN
		do
			Result := field_conforms_to ({ISE_RUNTIME}.dynamic_type (object), type_id)
		end

	is_readable_string_32 (str: ANY): BOOLEAN
		do
			Result := is_type_in_set (dynamic_type (str), class_id.readable_string_32_types)
		end

feature -- Access

	abstract_type (object: ANY): INTEGER
		do
			Result := abstract_type_of_type ({ISE_RUNTIME}.dynamic_type (object))
		end

	collection_item_type (type_id: INTEGER): INTEGER
		require
			valid_id: is_collection_type (type_id)
		do
			if generic_count_of_type (type_id) > 0 then
				Result := generic_dynamic_type_of_type (type_id, 1)

			elseif type_conforms_to (type_id, class_id.ARRAYED_LIST__ANY)
				and then attached Arrayed_list_factory.new_item_from_type_id (type_id) as list
			then
				Result := list.area.generating_type.generic_parameter_type (1).type_id
			end
		end

	dynamic_type (object: separate ANY): INTEGER
		do
			Result := {ISE_RUNTIME}.dynamic_type (object)
		end

	new_object (type: TYPE [ANY]): detachable ANY
		do
			Result := new_instance_of (type.type_id)
		end

	reflected (a_object: ANY): EL_REFLECTED_REFERENCE_OBJECT
		do
			create Result.make (a_object)
		end

	type_from_string (class_type: READABLE_STRING_GENERAL): detachable TYPE [ANY]
		local
			type_id: INTEGER
		do
			type_id := dynamic_type_from_string (class_type)
			if type_id > 0 then
				Result := type_of_type (type_id)
			end
		end

feature -- Constants

	Basic_types: EL_ARRAYED_LIST [TYPE [ANY]]
		once
			create Result.make (Special_type_mapping.count)
			across Special_type_mapping as table loop
				Result.extend (type_of_type (table.key))
			end
		end

	Object_overhead: INTEGER = 32
		-- memory overhead for any object excluding all attributes

feature -- Contract Support

	is_collection_type (type_id: INTEGER): BOOLEAN
		do
			Result := type_conforms_to (type_id, class_id.COLLECTION__ANY)
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

feature {NONE} -- Internal attributes

	class_id: EL_CLASS_TYPE_ID_ENUM
end