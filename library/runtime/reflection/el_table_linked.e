note
	description: "[
		Object linked to table with key names matching class field names. The object is
		initializeable from the string values of the table.
		Currently supported field types are:
			REAL_32
			INTEGER
			STRING
			ASTRING
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_TABLE_LINKED

inherit
	EL_STRING_CONSTANTS

	EL_REFLECTOR_CONSTANTS

feature {NONE} -- Initialization

	make (field_values: EL_ASTRING_HASH_TABLE [ASTRING])
		local
			i, field_count: INTEGER
			field_name, value: ASTRING
			current_object: REFLECTED_REFERENCE_OBJECT
		do
			current_object := Once_current_object; current_object.set_object (Current)
			create field_name.make_empty
			field_count := current_object.field_count

			from i := 1 until i > field_count loop
				field_name.wipe_out; field_name.append_string (current_object.field_name (i))
				field_values.search (field_name)
				if field_values.found then
					value := field_values.found_item
				else
					value := Empty_string
				end
				set_field (i, current_object, value)
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	set_field (field: INTEGER; current_object: REFLECTED_REFERENCE_OBJECT; value: ASTRING)
		local
			type_id: INTEGER
		do
			type_id := current_object.field_type (field)
			inspect type_id
				when integer_type then
					current_object.set_integer_32_field (field, value.to_integer) 		-- INTEGER

				when real_type then
					current_object.set_real_32_field (field, value.to_real_32)			-- REAL

			else
				type_id := current_object.field_static_type (field)
				if type_id = Astring_type then
					current_object.set_reference_field (field, value)						-- ASTRING

				elseif type_id = String_8_type then
					current_object.set_reference_field (field, value.to_latin1)			-- STRING_8
					
				elseif type_id = String_32_type then
					current_object.set_reference_field (field, value.to_latin1)			-- STRING_32
				end
			end
		end

end
