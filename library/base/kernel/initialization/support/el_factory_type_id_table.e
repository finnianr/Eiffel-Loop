note
	description: "[
		Cache table of dynamic type id for a factory type derived from a composite key containing
		a general factory type and a type conforming to generic argument of factory type.
	]"
	instructions: "[
		**Example Usage** 
		
		Given factory of type ${EL_MAKEABLE_FACTORY [EL_MAKEABLE]} and target type
		
			EL_MAKEABLE*
				${COLUMN_VECTOR_COMPLEX_64}
				
		calling `item' with a composite ${NATURAL_64} key defined as :
			
			(factory_type.type_id.to_natural_64 |<< 32) | target_type.type_id.to_natural_64
			
		returns a type id for ${EL_MAKEABLE_FACTORY [COLUMN_VECTOR_COMPLEX_64]}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 14:35:47 GMT (Sunday 22nd September 2024)"
	revision: "7"

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
			copy, default_create, is_equal
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
			interval: INTEGER_64; factory_id, target_id: INTEGER
			s: EL_STRING_8_ROUTINES; ir: EL_INTERVAL_ROUTINES
		do
			factory_id := (key |>> 32).to_integer_32
			target_id := key.to_integer_32

			if attached {ISE_RUNTIME}.generating_type_of_type (factory_id) as factory_name
				and then attached {ISE_RUNTIME}.generating_type_of_type (target_id) as target_name
			then
				interval := s.between_interval (factory_name, '[', ']')
				if interval > 0 then
					factory_name.replace_substring (target_name, ir.to_lower (interval), ir.to_upper (interval))
					Result := dynamic_type_from_string (factory_name)
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