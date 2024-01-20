note
	description: "[
		Cache table of dynamic type id for a factory type derived from a composite key containing
		a general factory type and a type conforming to generic argument of factory type.
	]"
	instructions: "[
		**Example Usage** 
		
		Given factory of type `{EL_MAKEABLE_FACTORY [EL_MAKEABLE]}' and target type
		
			EL_MAKEABLE*
				COLUMN_VECTOR_COMPLEX_64
				
		calling `item' with a composite ${NATURAL_64} key defined as :
			
			(factory_type.type_id.to_natural_64 |<< 32) | target_type.type_id.to_natural_64
			
		returns a type id for `{EL_MAKEABLE_FACTORY [COLUMN_VECTOR_COMPLEX_64]}'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "3"

class
	EL_FACTORY_TYPE_ID_TABLE

inherit
	EL_CACHE_TABLE [INTEGER, NATURAL_64]
		redefine
			hash_code_of
		end

	REFLECTOR
		export
			{NONE} all
		undefine
			copy, is_equal
		end

create
	make

feature {NONE} -- Implementation

	hash_code_of (key: NATURAL_64): INTEGER
		-- a better hash code then {NATURAL_64}.hash_code
		local
			l_31_bit_value: NATURAL_64
		do
			l_31_bit_value := (key |>> 17).bit_xor (key) & Max_31_bits
			Result := l_31_bit_value.to_integer_32
		end

	new_item (key: NATURAL_64): INTEGER
		require else
			valid_factory_type: valid_factory_type (key)
		local
			left_pos, right_pos, factory_id, target_id: INTEGER
		do
			factory_id := (key |>> 32).to_integer_32
			target_id := key.to_integer_32

			if attached {ISE_RUNTIME}.generating_type_of_type (factory_id) as factory_name
				and then attached {ISE_RUNTIME}.generating_type_of_type (target_id) as target_name
			then
				left_pos := factory_name.index_of ('[', 1)
				if left_pos > 0 then
					right_pos := factory_name.index_of (']', left_pos + 1)
					if right_pos > 0 then
						factory_name.replace_substring (target_name, left_pos + 1, right_pos - 1)
						Result := dynamic_type_from_string (factory_name)
					end
				end
			end
		end

	valid_factory_type (key: NATURAL_64): BOOLEAN
		local
			factory_type, type: TYPE [ANY]
		do
			factory_type := type_of_type ((key |>> 32).to_integer_32)
			type :=  type_of_type (key.to_integer_32)
			Result := factory_type.generic_parameter_count = 1
				and then field_conforms_to (type.type_id, factory_type.generic_parameter_type (1).type_id)
		end

feature {NONE} -- Constants

	Max_31_bits: NATURAL_64 = 0x7FFFFFFF
end