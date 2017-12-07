note
	description: "Object with fields settable from `ZSTRING' values using Eiffel reflection"
	notes: "[
		Override `new_default_values' to provide default values for attributes conforming to
		`EL_MAKEABLE_FROM_ZSTRING' or `EL_MAKEABLE_FROM_STRING_<X>', but make sure to include
		the Precursor values.
		
		It is permitted to have a trailing underscore to prevent clashes with Eiffel keywords.
		The field is settable with `set_field' by a name string that does not have a trailing underscore.
		
		To adapt foreign names that do not follow the Eiffel snake-case convention redefine `import_name'
		to return a routine in `EL_ATTRIBUTE_NAME_ROUTINES' prefixed with `from_'. To export Eiffel names
		redefine `export_name' to return a routine in `EL_ATTRIBUTE_NAME_ROUTINES' prefixed with `to_'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-06 12:44:08 GMT (Wednesday 6th December 2017)"
	revision: "3"

deferred class
	EL_REFLECTIVELY_SETTABLE [S -> STRING_GENERAL create make_empty end]

inherit
	EL_REFLECTION
		redefine
			Except_fields, is_equal
		end

	EL_ATTRIBUTE_NAME_TRANSLATEABLE
		undefine
			is_equal
		end

	STRING_HANDLER
		undefine
			is_equal
		end

	EL_MODULE_EIFFEL
		undefine
			is_equal
		end

feature {NONE} -- Initialization

	make_default
		do
			string_type_id := ({S}).type_id
			field_index_table := Field_index_table_by_type.item (Current)
			set_default_values
		end

	make_from_table (field_values: HASH_TABLE [S, STRING])
		do
			make_default
			across field_values as value loop
				set_field (value.key, value.item)
			end
		end

	make_from_zkey_table (field_values: HASH_TABLE [S, ZSTRING])
		-- make from table with keys of type `S'
		local
			name: STRING
		do
			make_default
			create name.make_empty
			across field_values as value loop
				name.wipe_out
				value.key.append_to_string_8 (name)
				set_field (name, value.item)
			end
		end

feature -- Access

	field_item (name: READABLE_STRING_GENERAL): S
		local
			table: like field_index_table
		do
			table := field_index_table
			table.search (name)
			if table.found then
				Result := field_item_from_index (table.found_item)
			else
				create Result.make_empty
			end
		end

feature -- Element change

	set_default_values
		local
			object: like current_object; i: INTEGER
			default_values: HASH_TABLE [ANY, INTEGER]
		do
			object := new_current_object (Current); default_values := Default_value_table_by_type.item (Current)
			across field_index_table as index loop
				i := index.item
				inspect object.field_type (i)
					when Reference_type then
						default_values.search (object.field_static_type (i))
						if default_values.found then
							object.set_reference_field (i, default_values.found_item)
						end
					when Integer_32_type then
						object.set_integer_32_field (i, 0)

					when Integer_64_type then
						object.set_integer_64_field (i, 0)

					when Natural_32_type then
						object.set_natural_32_field (i, 0)

					when Natural_64_type then
						object.set_natural_64_field (i, 0)

					when Real_32_type then
						object.set_real_32_field (i, 0)

					when Real_64_type then
						object.set_real_64_field (i, 0)

					when Boolean_type then
						object.set_boolean_field (i, False)
				else
				end
			end
			recycle (object)
		end

	set_field (name: READABLE_STRING_GENERAL; value: S)
		local
			table: like field_index_table
		do
			table := field_index_table
			table.search (name)
			if table.found then
				set_object_field (current_object, table.found_item, value)
			end
		end

	set_field_from_nvp (nvp, delimiter: S)
		-- Set field from name-value pair `nvp' delimited by `delimiter'. For eg. "var=value" or "var: value"
		require
			has_one_equal_sign: nvp.has_substring (delimiter)
		local
			pos_equals: INTEGER; name: STRING
		do
			pos_equals := nvp.substring_index (delimiter, 1)
			if pos_equals > 0 then
				name := nvp.substring (1, pos_equals - 1).to_string_8
				set_field (name, nvp.substring (pos_equals + delimiter.count, nvp.count))
			end
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		local
			object, other_object: REFLECTED_REFERENCE_OBJECT
			table: like field_index_table
		do
			object := new_current_object (Current); other_object := new_current_object (other)
			table := field_index_table
			Result := True
			from table.start until not Result or table.after loop
				Result := equal_fields (object, other_object, table.item_for_iteration)
				table.forth
			end
			recycle (object); recycle (other_object)
		end

feature {EL_REFLECTIVELY_SETTABLE} -- Factory

	new_default_values: EL_ARRAYED_LIST [ANY]
		do
			create Result.make_from_array (Default_string_values)
		end

	new_default_values_by_type: HASH_TABLE [ANY, INTEGER]
		local
			values: like new_default_values
		do
			values := new_default_values
			create Result.make (values.count)
			from values.start until values.after loop
				Result [Eiffel.dynamic_type (values.item)] := values.item
				values.forth
			end
		end

	new_field_index_table: EL_FIELD_INDEX_TABLE
		local
			object: like current_object; i, field_count: INTEGER
			excluded_indices: like new_field_indices_set
		do
			object := new_current_object (Current); field_count := object.field_count
			excluded_indices := Excluded_fields_by_type.item (Current)
			create Result.make (field_count - excluded_indices.count, import_name)
			from i := 1 until i > field_count loop
				excluded_indices.binary_search (i)
				if not excluded_indices.found then
					extend_field_table (Result, object, i)
				end
				i := i + 1
			end
			recycle (object)
		end

feature {NONE} -- Implementation

	extend_field_table (table: like new_field_index_table; object: like current_object; i: INTEGER)
		local
			name: STRING
		do
			name := object.field_name (i)
			name.prune_all_trailing ('_')
			table.extend (i, name)
		end

	field_item_from_index (index: INTEGER): S
		local
			object: like current_object
			field_type: INTEGER; value: STRING; reference_value: ANY
		do
			object := new_current_object (Current)
			field_type := object.field_type (index)
			if field_type = Reference_type then
				reference_value := object.reference_field (index)
				if attached {S} reference_value as str then
					Result := str
				elseif attached {READABLE_STRING_GENERAL} reference_value as general then
					create Result.make_empty
					Result.append (general)
				else
					create Result.make_empty
				end
			else
				value := String_pool.new_string
				inspect field_type
					when Integer_32_type then
						value.append_integer (object.integer_32_field (index))

					when Integer_64_type then
						value.append_integer_64 (object.integer_64_field (index))

					when Natural_32_type then
						value.append_natural_32 (object.natural_32_field (index))

					when Natural_64_type then
						value.append_natural_64 (object.natural_64_field (index))

					when Real_32_type then
						value.append_real (object.real_32_field (index))

					when Real_64_type then
						value.append_double (object.real_64_field (index))

					when Boolean_type then
						value.append_boolean (object.boolean_field (index))
				else
				end
				create Result.make_empty
				Result.append (value)
				String_pool.recycle (value)
			end
			recycle (object)
		end

	set_object_field (object: REFLECTED_REFERENCE_OBJECT; index: INTEGER; value: S)
		do
			inspect object.field_type (index)
				when Reference_type then
					set_object_reference_field (object, index, value)

				when Integer_32_type then
					object.set_integer_32_field (index, value.to_integer_32) -- INTEGER_32

				when Integer_64_type then
					object.set_integer_64_field (index, value.to_integer_64) -- INTEGER_64

				when Natural_32_type then
					object.set_natural_32_field (index, value.to_natural_32) -- NATURAL_32

				when Natural_64_type then
					object.set_natural_64_field (index, value.to_natural_64) -- NATURAL_64

				when Real_32_type then
					object.set_real_32_field (index, value.to_real_32)			-- REAL_32

				when Real_64_type then
					object.set_real_64_field (index, value.to_real_64)			-- REAL_64

				when Boolean_type then
					object.set_boolean_field (index, value.to_boolean)			-- BOOLEAN
			else
			end
		end

	set_object_reference_field (object: REFLECTED_REFERENCE_OBJECT; index: INTEGER; value: S)
		local
			l_type_id: INTEGER; default_values: HASH_TABLE [ANY, INTEGER]
			new_field: ANY
		do
			l_type_id := object.field_static_type (index)
			if l_type_id = String_z_type then
				object.set_reference_field (index, value)						-- ZSTRING

			elseif l_type_id = String_8_type then
				object.set_reference_field (index, value.to_string_8)		-- STRING_8

			elseif l_type_id = String_32_type then
				object.set_reference_field (index, value.to_string_32)	-- STRING_32

			else
				-- Check if the object is makeable from a string
				default_values := Default_value_table_by_type.item (Current)
				default_values.search (l_type_id)
				if default_values.found then
					-- We have to use twinning because calling `make' on an instance created
					-- with `Eiffel.new_instance' can lead to invariant failures. This happened
					-- for example, with a descendant of `ARRAYED_LIST'.

					new_field := default_values.found_item.twin
					if attached {EL_MAKEABLE_FROM_ZSTRING} new_field as target then
						if attached {ZSTRING} value as z_value then
							target.make (z_value)
						else
							target.make (create {ZSTRING}.make_from_general (value))
						end
					elseif attached {EL_MAKEABLE_FROM_STRING_8} new_field as target then
						target.make (value.to_string_8)
					elseif attached {EL_MAKEABLE_FROM_STRING_32} new_field as target then
						target.make (value.to_string_32)
					end
					object.set_reference_field (index, new_field)
				end
			end
		end

feature {EL_REFLECTION_HANDLER} -- Internal attributes

	field_index_table: like new_field_index_table

	string_type_id: INTEGER
		-- type_id of string {S}

feature {NONE} -- Constants

	Default_value_table_by_type: EL_FUNCTION_RESULT_TABLE [
		EL_REFLECTIVELY_SETTABLE [STRING_GENERAL], HASH_TABLE [ANY, INTEGER]
	]
		once
			create Result.make (11, agent {EL_REFLECTIVELY_SETTABLE [STRING_GENERAL]}.new_default_values_by_type)
		end

	Except_fields: STRING
		once
			Result := "field_index_table, string_type_id"
		end

	Field_index_table_by_type: EL_FUNCTION_RESULT_TABLE [
		EL_REFLECTIVELY_SETTABLE [STRING_GENERAL], EL_FIELD_INDEX_TABLE
	]
		once
			create Result.make (11, agent {EL_REFLECTIVELY_SETTABLE [STRING_GENERAL]}.new_field_index_table)
		end


end
