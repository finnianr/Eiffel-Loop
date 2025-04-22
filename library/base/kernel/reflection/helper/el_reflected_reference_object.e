note
	description: "Reflected reference object"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-22 12:37:39 GMT (Tuesday 22nd April 2025)"
	revision: "4"

class
	EL_REFLECTED_REFERENCE_OBJECT

inherit
	REFLECTED_REFERENCE_OBJECT

	EL_REFLECTION_HANDLER

create
	make

feature -- Factory

	new_index_table: HASH_TABLE [INTEGER, STRING]
		local
			i, count: INTEGER
		do
			count := field_count
			create Result.make (count)
			from i := 1 until i > count loop
				Result.extend (i, field_name (i))
				i := i + 1
			end
		end

feature -- Status query

	all_references_attached: BOOLEAN
		-- `True' if all reference fields are initialized
		local
			i, count: INTEGER
		do
			Result := True; count := field_count
			from i := 1 until not Result or i > count loop
				if field_type (i) = Reference_type then
					Result := Result and attached reference_field (i)
				end
				i := i + 1
			end
		end

feature -- Basic operations

	copy_fields_to (a_other: ANY; field_names: STRING)
		local
			indices_set, indices_set_other: EL_FIELD_INDICES_SET
			other: EL_REFLECTED_REFERENCE_OBJECT; i: INTEGER
		do
			create indices_set.make_from (enclosing_object, field_names)
			create indices_set_other.make_from (a_other, field_names)
			if indices_set.count = indices_set_other.count then
				create other.make (a_other)
				if attached indices_set.area as area and then attached indices_set_other.area as area_other then
					from until i = indices_set.count loop
						copy_i_th_field_to (other, area [i], area_other [i])
						i := i + 1
					end
				end
			end
		end

feature {NONE} -- Implementation

	copy_i_th_field_to (other: EL_REFLECTED_REFERENCE_OBJECT; i, other_i: INTEGER)
		local
			type: INTEGER
		do
			type := field_type (i)
			if type = other.field_type (other_i) then
				inspect type
					when Integer_8_type then
						other.set_integer_8_field (other_i, integer_8_field (i))

					when Integer_16_type then
						other.set_integer_16_field (other_i, integer_16_field (i))

					when Integer_32_type then
						other.set_integer_32_field (other_i, integer_32_field (i))

					when Integer_64_type then
						other.set_integer_64_field (other_i, integer_64_field (i))

					when Natural_8_type then
						other.set_natural_8_field (other_i, natural_8_field (i))

					when Natural_16_type then
						other.set_natural_16_field (other_i, natural_16_field (i))

					when Natural_32_type then
						other.set_natural_32_field (other_i, natural_32_field (i))

					when Natural_64_type then
						other.set_natural_64_field (other_i, natural_64_field (i))

					when Real_32_type then
						other.set_real_32_field (other_i, real_32_field (i))

					when Real_64_type then
						other.set_real_64_field (other_i, real_64_field (i))

					when Boolean_type then
						other.set_boolean_field (other_i, boolean_field (i))

					when Character_8_type then
						other.set_character_8_field (other_i, character_8_field (i))

					when Character_32_type then
						other.set_character_32_field (other_i, character_32_field (i))

					when Pointer_type then
						other.set_pointer_field (other_i, pointer_field (i))

					when Reference_type then
						other.set_reference_field (other_i, reference_field (i))
				else
				end
			end
		end

end