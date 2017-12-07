note
	description: "Summary description for {EL_REFLECTION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-06 12:41:18 GMT (Wednesday 6th December 2017)"
	revision: "5"

class
	EL_REFLECTION

inherit
	EL_REFLECTOR_CONSTANTS

	EL_MODULE_STRING_8

feature {EL_REFLECTION} -- Factory

	new_except_field_indices: like new_field_indices_set
		do
			Result := new_field_indices_set (Except_fields)
		end

	new_field_indices_set (field_names: STRING): SORTABLE_ARRAY [INTEGER]
		local
			object: like current_object; field_list: EL_SPLIT_STRING_LIST [STRING]
			i, j, field_count: INTEGER
		do
			object := current_object; field_count := object.field_count
			create field_list.make (field_names, once ",")
			field_list.enable_left_adjust

			create Result.make_filled (0, 1, field_list.count)
			from i := 1 until i > field_count loop
				if field_list.has (object.field_name (i)) then
					j := j + 1
					Result [j] := i
				end
				i := i + 1
			end
			Result.sort
		ensure
			all_fields_found: not Result.has (0)
		end

feature {NONE} -- Implementation

	current_object: like Once_current_object
		do
			Result := Once_current_object; Result.set_object (Current)
		end

	equal_fields (object, other_object: REFLECTED_REFERENCE_OBJECT; index: INTEGER): BOOLEAN
		require
			objects_same_type: object.dynamic_type = other_object.dynamic_type
		do
			inspect object.field_type (index)
				when Reference_type then
					Result := equal_reference_fields (object, other_object, index)

				when Boolean_type then
					Result := object.boolean_field (index) = other_object.boolean_field (index)

				when Integer_8_type then
					Result := object.integer_8_field (index) = other_object.integer_8_field (index)

				when Integer_16_type then
					Result := object.integer_16_field (index) = other_object.integer_16_field (index)

				when Integer_32_type then
					Result := object.integer_32_field (index) = other_object.integer_32_field (index)

				when Integer_64_type then
					Result := object.integer_64_field (index) = other_object.integer_64_field (index)

				when Real_32_type then
					Result := object.real_32_field (index) = other_object.real_32_field (index)

				when Real_64_type then
					Result := object.real_64_field (index) = other_object.real_64_field (index)

				when Natural_8_type then
					Result := object.natural_8_field (index) = other_object.natural_8_field (index)

				when Natural_16_type then
					Result := object.natural_16_field (index) = other_object.natural_16_field (index)

				when Natural_32_type then
					Result := object.natural_32_field (index)  = other_object.natural_32_field (index)

				when Natural_64_type then
					Result := object.natural_64_field (index) = other_object.natural_64_field (index)
			else
			end
		end

	equal_reference_fields (object, other_object: REFLECTED_REFERENCE_OBJECT; index: INTEGER): BOOLEAN
		require
			object_is_reference: object.field_type (index) = Reference_type
			other_object_is_reference: other_object.field_type (index) = Reference_type
			objects_same_type: object.dynamic_type = other_object.dynamic_type
		do
			Result := object.reference_field (index).is_equal (other_object.reference_field (index))
		end

	new_current_object (instance: ANY): REFLECTED_REFERENCE_OBJECT
		local
			pool: like Object_pool
		do
			pool := Object_pool
			if pool.is_empty then
				create Result.make (instance)
			else
				Result := pool.item
				Result.set_object (instance)
				pool.remove
			end
		end

	recycle (object: like new_current_object)
		do
			object.set_object (0)
			Object_pool.put (object)
		end

feature {NONE} -- Constants

	Except_fields: STRING
		-- list of comma-separated fields to be excluded
		once
			create Result.make_empty
		ensure
			no_leading_comma: not Result.is_empty implies not (Result [1] = ',')
		end

	Excluded_fields_by_type: EL_FUNCTION_RESULT_TABLE [EL_REFLECTION, SORTABLE_ARRAY [INTEGER]]
		once
			create Result.make (19, agent {EL_REFLECTION}.new_except_field_indices)
		end

	Once_current_object: REFLECTED_REFERENCE_OBJECT
		once
			create Result.make (Current)
		end

	Object_pool: ARRAYED_STACK [REFLECTED_REFERENCE_OBJECT]
		once
			create Result.make (3)
		end

	String_pool: EL_STRING_POOL [STRING]
		once
			create Result.make (3)
		end
end
