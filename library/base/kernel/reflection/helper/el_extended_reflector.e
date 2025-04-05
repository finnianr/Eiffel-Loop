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
	date: "2025-04-05 10:09:50 GMT (Saturday 5th April 2025)"
	revision: "47"

class
	EL_EXTENDED_REFLECTOR

inherit
	EL_REFLECTOR

	EL_TYPE_UTILITIES
		export
			{ANY} abstract_type_of_type
		end

	EL_REFLECTION_CONSTANTS; EL_TYPE_CATEGORY_CONSTANTS

	EL_SHARED_CLASS_ID
		rename
			Class_id as Shared_class_id
		end

	EL_SHARED_FACTORIES

create
	make

feature {NONE} -- Initialization

	make
		do
			class_id := Shared_class_id
		end

feature -- Measurement

	natural_width (n: ANY; type_id: INTEGER): INTEGER
		require
			correct_type_id: same_type_as (n, type_id)
			is_natural_type: is_type_in_set (type_id, class_id.natural_types)
		local
			math: EL_INTEGER_MATH
		do
			inspect abstract_type_of_type_plus (type_id)
				when Natural_8_type then
					if attached {NATURAL_8_REF} n as n_8 then
						Result := math.natural_digit_count (n_8.item)
					end

				when Natural_16_type then
					if attached {NATURAL_16_REF} n as n_16 then
						Result := math.natural_digit_count (n_16.item)
					end

				when Natural_32_type then
					if attached {NATURAL_32_REF} n as n_32 then
						Result := math.natural_digit_count (n_32.item)
					end

				when Natural_64_type then
					if attached {NATURAL_64_REF} n as n_64 then
						Result := math.natural_digit_count (n_64.item)
					end
			else
				Result := n.out.count
			end
		end

	string_width (object: ANY): INTEGER
		local
			math: EL_INTEGER_MATH
		do
			inspect class_id.object_type_category (object)
				when C_readable_string_8 then
					if attached {READABLE_STRING_8} object as str_8 then
						Result := str_8.count
					end

				when C_readable_string_32 then
					if attached {READABLE_STRING_32} object as str_32 then
						Result := str_32.count
					end

				when C_el_path then
					if attached {EL_PATH} object as path then
						Result := path.count
					end

				when C_el_path_steps then
					if attached {EL_PATH_STEPS} object as steps then
						Result := steps.count
					end

				when C_path then
					if attached {PATH} object as path then
						Result := path.name.count
					end

				when C_type_any then
					if attached {TYPE [ANY]} object as type then
						Result := type.name.count
					end

				when C_integer then
					Result := math.string_size (to_integer_64 (object, dynamic_type (object)))

				when C_natural then
					Result := natural_width (object, dynamic_type (object))
			else
				Result := object.out.count
			end
		end

feature -- Conversion

	to_integer_64 (n: ANY; type_id: INTEGER): INTEGER_64
		require
			correct_type_id: same_type_as (n, type_id)
			is_natural_or_integer_type: is_type_in_set (type_id, class_id.whole_number_types)
		do
			inspect abstract_type_of_type_plus (type_id)
				when Natural_8_type then
					if attached {NATURAL_8_REF} n as n_8 then
						Result := n_8.to_integer_64
					end

				when Natural_16_type then
					if attached {NATURAL_16_REF} n as n_16 then
						Result := n_16.to_integer_64
					end

				when Natural_32_type then
					if attached {NATURAL_32_REF} n as n_32 then
						Result := n_32.to_integer_64
					end

				when Natural_64_type then
					if attached {NATURAL_64_REF} n as n_64 then
						Result := n_64.to_integer_64
					end

				when Integer_8_type then
					if attached {INTEGER_8_REF} n as i_8 then
						Result := i_8.to_integer_64
					end

				when Integer_16_type then
					if attached {INTEGER_16_REF} n as i_16 then
						Result := i_16.to_integer_64
					end

				when Integer_32_type then
					if attached {INTEGER_32_REF} n as i_32 then
						Result := i_32.to_integer_64
					end

				when Integer_64_type then
					if attached {INTEGER_64_REF} n as i_64 then
						Result := i_64.item
					end
			else
			end
		end

	to_real_64 (n: ANY; type_id: INTEGER): REAL_64
		require
			correct_type_id: same_type_as (n, type_id)
			numeric_type: type_conforms_to (type_id, class_id.NUMERIC)
		do
			inspect abstract_type_of_type_plus (type_id)
				when Natural_8_type then
					if attached {NATURAL_8_REF} n as n_8 then
						Result := n_8.to_real_64
					end

				when Natural_16_type then
					if attached {NATURAL_16_REF} n as n_16 then
						Result := n_16.to_real_64
					end

				when Natural_32_type then
					if attached {NATURAL_32_REF} n as n_32 then
						Result := n_32.to_real_64
					end

				when Natural_64_type then
					if attached {NATURAL_64_REF} n as n_64 then
						Result := n_64.to_real_64
					end

				when Integer_8_type then
					if attached {INTEGER_8_REF} n as i_8 then
						Result := i_8.to_double
					end

				when Integer_16_type then
					if attached {INTEGER_16_REF} n as i_16 then
						Result := i_16.to_double
					end

				when Integer_32_type then
					if attached {INTEGER_32_REF} n as i_32 then
						Result := i_32.to_double
					end

				when Integer_64_type then
					if attached {INTEGER_64_REF} n as i_64 then
						Result := i_64.to_double
					end

				when Real_32_type then
					if attached {REAL_32_REF} n as r_32 then
						Result := r_32.to_double
					end

				when Real_64_type then
					if attached {REAL_64_REF} n as r_64 then
						Result := r_64.item
					end
			else
			end
		end

feature -- Type status

	field_conforms_to_collection (basic_type, type_id: INTEGER): BOOLEAN
		-- True if `type_id' conforms to COLLECTION [X] where x is a string or an expanded type
		do
			inspect basic_type
				when Reference_type then
					Result := type_conforms_to (type_id, class_id.COLLECTION__ANY)
			else
			end
		end

	field_conforms_to_date_time (basic_type, type_id: INTEGER): BOOLEAN
		do
			inspect basic_type
				when Reference_type then
					Result := field_conforms_to (type_id, class_id.DATE_TIME)
			else
			end
		end

	field_conforms_to_one_of (basic_type, type_id: INTEGER; types: ARRAY [INTEGER]): BOOLEAN
		-- True if `type_id' conforms to one of `types'
		do
			inspect basic_type
				when Reference_type then
					Result := conforms_to_one_of (type_id, types)
			else
			end
		end

	is_expanded_or_reference (expanded_id, type_id: INTEGER): BOOLEAN
		require
			is_expanded: type_of_type (expanded_id).is_expanded
		do
			Result := expanded_id = type_id or else expanded_id - 1 = type_id
		end

	is_generic (type_id: INTEGER): BOOLEAN
		do
		-- quick test
			if eif_generic_parameter_count (type_id) > 0  then
				Result := True
			else
		-- slow test
				Result := type_of_type (type_id).generic_parameter_count > 0
			end
		end

	is_real_type (type_id: INTEGER): BOOLEAN
		do
			Result := is_type_in_set (type_id, class_id.real_types)
		end

	is_storable_collection_type (type_id: INTEGER): BOOLEAN
		local
			item_type_id: INTEGER
		do
			item_type_id := collection_item_type (type_id)
			Result := is_storable_type (abstract_type_of_type (item_type_id), item_type_id)
		end

	is_storable_type (basic_type, type_id: INTEGER): BOOLEAN
		-- `True' if type is storable using `EL_STORABLE' interface
		local
			tuple_types: EL_TUPLE_TYPE_ARRAY
		do
			inspect basic_type
				when Reference_type then
					if type_conforms_to (type_id, class_id.TUPLE) then
						create tuple_types.make_from_static (type_id)
					-- TUPLE items must be expanded or strings
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
			inspect basic_type
				when Reference_type then
					Result := type_conforms_to (type_id, ({HASH_TABLE [ANY, HASHABLE]}).type_id)
			else
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

	class_id: EL_CLASS_TYPE_ID_ENUM

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

	reflected (a_object: ANY): EL_REFLECTED_REFERENCE_OBJECT
		do
			create Result.make (a_object)
		end

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

end