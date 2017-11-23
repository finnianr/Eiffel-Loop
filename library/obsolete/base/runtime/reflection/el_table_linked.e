note
	description: "[
		Object linked to table with key names matching class field names. The object is
		initializeable from the string values of the table.
		
		Currently supported field types are:
			REAL_32
			INTEGER
			STRING
			ZSTRING
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:58 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_TABLE_LINKED

inherit
	EL_STRING_CONSTANTS

	EL_REFLECTION

feature {NONE} -- Initialization

	make (field_values: EL_ZSTRING_HASH_TABLE [ZSTRING])
		local
			i, field_count: INTEGER
			field_name, value: ZSTRING
			object: REFLECTED_REFERENCE_OBJECT
		do
			object := current_object
			create field_name.make_empty
			field_count := object.field_count

			from i := 1 until i > field_count loop
				field_name.wipe_out; field_name.append_string_general (object.field_name (i))
				field_values.search (field_name)
				if field_values.found then
					value := field_values.found_item
				else
					value := Empty_string
				end
				set_field (i, object, value)
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	set_field (field: INTEGER; object: REFLECTED_REFERENCE_OBJECT; value: ZSTRING)
		local
			type_id: INTEGER
		do
			inspect object.field_type (field)
				when Integer_32_type then
					object.set_integer_32_field (field, value.to_integer_32) -- INTEGER_32

				when Integer_64_type then
					object.set_integer_64_field (field, value.to_integer_64) -- INTEGER_64

				when Natural_32_type then
					object.set_natural_32_field (field, value.to_natural_32) -- NATURAL_32

				when Natural_64_type then
					object.set_natural_64_field (field, value.to_natural_64) -- NATURAL_64

				when Real_32_type then
					object.set_real_32_field (field, value.to_real_32)			-- REAL_32

				when Real_64_type then
					object.set_real_64_field (field, value.to_real_64)			-- REAL_64

				when Boolean_type then
					object.set_boolean_field (field, value.to_boolean)			-- BOOLEAN

			else
				type_id := object.field_static_type (field)
				if type_id = String_z_type then
					object.set_reference_field (field, value)						-- ZSTRING

				elseif type_id = String_8_type then
					object.set_reference_field (field, value.to_string_8)		-- STRING_8

				elseif type_id = String_32_type then
					object.set_reference_field (field, value.to_string_32)	-- STRING_32
				end
			end
		end

end
