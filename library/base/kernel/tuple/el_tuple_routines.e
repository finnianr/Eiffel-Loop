note
	description: "[
		Routines for populating tuple fields and converting to and from string types.
		Accessible via shared instance [$source EL_MODULE_TUPLE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-09 9:22:40 GMT (Sunday 9th May 2021)"
	revision: "19"

class
	EL_TUPLE_ROUTINES

inherit
	ANY

	EL_MODULE_EIFFEL

	EL_MODULE_CONVERT_STRING

create
	make

feature {NONE} -- Initialization

	make
		do
			create types_table.make (17, agent new_type_array)
		end

feature -- Access

	type_array (tuple: TUPLE): EL_TUPLE_TYPE_ARRAY
		do
			Result := types_table.item ({ISE_RUNTIME}.dynamic_type (tuple))
		end

feature -- Conversion

	to_string_32_list (tuple: TUPLE): EL_STRING_32_LIST
		do
			Result := tuple
		end

	to_string_8_list (tuple: TUPLE): EL_STRING_8_LIST
		do
			Result := tuple
		end

	to_zstring_list (tuple: TUPLE): EL_ZSTRING_LIST
		do
			Result := tuple
		end

feature -- Basic operations

	append_i_th (tuple: TUPLE; i: INTEGER; string: STRING_32)
		-- append i'th item of `tuple' to `string'
		require
			valid_index: tuple.valid_index (i)
		do
			inspect tuple.item_code (i)
				when {TUPLE}.Integer_8_code then
					string.append_integer_8 (tuple.integer_8_item (i))

				when {TUPLE}.Integer_16_code then
					string.append_integer_16 (tuple.integer_16_item (i))

				when {TUPLE}.Integer_32_code then
					string.append_integer (tuple.integer_32_item (i))

				when {TUPLE}.Integer_64_code then
					string.append_integer_64 (tuple.integer_64_item (i))

				when {TUPLE}.Natural_8_code then
					string.append_natural_8 (tuple.natural_8_item (i))

				when {TUPLE}.Natural_16_code then
					string.append_natural_16 (tuple.natural_16_item (i))

				when {TUPLE}.Natural_32_code then
					string.append_natural_32 (tuple.natural_32_item (i))

				when {TUPLE}.Natural_64_code then
					string.append_natural_64 (tuple.natural_64_item (i))

				when {TUPLE}.Real_32_code then
					string.append_real (tuple.real_32_item (i))

				when {TUPLE}.Real_64_code then
					string.append_double (tuple.real_64_item (i))

				when {TUPLE}.Reference_code then
					if attached tuple.reference_item (i) as ref_item then
						if attached {READABLE_STRING_GENERAL} ref_item as general then
							if attached {ZSTRING} general as zstr then
								zstr.append_to_string_32 (string)
							else
								string.append_string_general (general)
							end
						elseif attached {EL_PATH} ref_item as path then
							path.append_to_32 (string)
						end
					end
				end
		end

	fill (tuple: TUPLE; csv_list: READABLE_STRING_GENERAL)
		do
			fill_adjusted (tuple, csv_list, True)
		end

	fill_adjusted (tuple: TUPLE; csv_list: READABLE_STRING_GENERAL; left_adjusted: BOOLEAN)
		-- fill tuple with STRING items from comma-separated list `csv_list' of strings
		-- TUPLE may contain any of types STRING_8, STRING_32, ZSTRING
		-- items are left adjusted if `left_adjusted' is True
		do
			Convert_string.fill_tuple (tuple, csv_list, left_adjusted)
		end

	fill_default (tuple: TUPLE; default_value: ANY)
		local
			i: INTEGER; type_id: INTEGER
			tuple_types: EL_TUPLE_TYPE_ARRAY
		do
			type_id := {ISE_RUNTIME}.dynamic_type (default_value)
			tuple_types := type_array (tuple)
			from i := 1 until i > tuple.count loop
				if tuple.item_code (i) = {TUPLE}.Reference_code and then
					Eiffel.field_conforms_to (type_id, tuple_types [i].type_id)
				then
					tuple.put_reference (default_value, i)
				end
				i := i + 1
			end
		ensure
			filled: is_filled (tuple, 1, tuple.count)
		end

	fill_with_new (tuple: TUPLE; csv_field_list: STRING; a_new_item: FUNCTION [STRING, ANY]; start_index: INTEGER)
		-- fill tuple from `start_index' with factory function call `a_new_item (x)' where `x' is a field name
		-- in the comma separated field list `csv_field_list'
		require
			valid_start_index: start_index >= 1
			valid_list: csv_field_list.count > 0 and then start_index + csv_field_list.occurrences (',') <= tuple.count
			not_filled:	not is_filled (tuple, start_index, start_index + csv_field_list.occurrences (','))
		local
			result_type_id: INTEGER; list: EL_SPLIT_STRING_8_LIST; tuple_types: EL_TUPLE_TYPE_ARRAY
			index: INTEGER
		do
			result_type_id := a_new_item.generating_type.generic_parameter_type (2).type_id
			tuple_types := type_array (tuple)
			create list.make (csv_field_list, Comma)
			list.enable_left_adjust

			from list.start until (start_index + list.index - 1) > tuple.count or list.after loop
				index := start_index + list.index - 1
				if tuple.item_code (index) = {TUPLE}.Reference_code and then
					Eiffel.field_conforms_to (result_type_id, tuple_types [index].type_id)
					and then attached a_new_item (list.item (False)) as new
				then
					tuple.put_reference (new, index)
				end
				list.forth
			end
		ensure
			filled:is_filled (tuple, start_index, start_index + csv_field_list.occurrences (','))
		end

	read (tuple: TUPLE; reader: EL_MEMORY_READER_WRITER)
		local
			i: INTEGER
		do
			from i := 1 until i > tuple.count loop
				inspect tuple.item_code (i)
					when {TUPLE}.Character_8_code then
						tuple.put_character (reader.read_character_8, i)

					when {TUPLE}.Character_32_code then
						tuple.put_character_32 (reader.read_character_32, i)

					when {TUPLE}.Boolean_code then
						tuple.put_boolean (reader.read_boolean, i)

					when {TUPLE}.Integer_8_code then
						tuple.put_integer_8 (reader.read_integer_8, i)

					when {TUPLE}.Integer_16_code then
						tuple.put_integer_16 (reader.read_integer_16, i)

					when {TUPLE}.Integer_32_code then
						tuple.put_integer (reader.read_integer_32, i)

					when {TUPLE}.Integer_64_code then
						tuple.put_integer_64 (reader.read_integer_64, i)

					when {TUPLE}.Natural_8_code then
						tuple.put_natural_8 (reader.read_natural_8, i)

					when {TUPLE}.Natural_16_code then
						tuple.put_natural_16 (reader.read_natural_16, i)

					when {TUPLE}.Natural_32_code then
						tuple.put_natural_32 (reader.read_natural_32, i)

					when {TUPLE}.Natural_64_code then
						tuple.put_natural_64 (reader.read_natural_64, i)

					when {TUPLE}.Real_32_code then
						tuple.put_real_32 (reader.read_real_32, i)

					when {TUPLE}.Real_64_code then
						tuple.put_real_64 (reader.read_real_64, i)

					when {TUPLE}.Reference_code then
						if attached {STRING_GENERAL} tuple.reference_item (i) as str then
							if attached {ZSTRING} str then
								tuple.put_reference (reader.read_string, i)
							elseif attached {STRING} str then
								tuple.put_reference (reader.read_string_8, i)
							elseif attached {STRING_32} str then
								tuple.put_reference (reader.read_string_32, i)
							end
						end
				else
				end
				i := i + 1
			end
		end

	write (tuple: TUPLE; writeable: EL_WRITEABLE; delimiter: STRING)
		local
			i: INTEGER; has_delimiter: BOOLEAN
		do
			has_delimiter := delimiter.count > 0
			from i := 1 until i > tuple.count loop
				if i > 1 and then has_delimiter then
					writeable.write_string_8 (delimiter)
				end
				inspect tuple.item_code (i)
					when {TUPLE}.Character_8_code then
						writeable.write_character_8 (tuple.character_8_item (i))

					when {TUPLE}.Character_32_code then
						writeable.write_character_32 (tuple.character_32_item (i))

					when {TUPLE}.Boolean_code then
						writeable.write_boolean (tuple.boolean_item (i))

					when {TUPLE}.Integer_8_code then
						writeable.write_integer_8 (tuple.integer_8_item (i))

					when {TUPLE}.Integer_16_code then
						writeable.write_integer_16 (tuple.integer_16_item (i))

					when {TUPLE}.Integer_32_code then
						writeable.write_integer_32 (tuple.integer_32_item (i))

					when {TUPLE}.Integer_64_code then
						writeable.write_integer_64 (tuple.integer_64_item (i))

					when {TUPLE}.Natural_8_code then
						writeable.write_natural_8 (tuple.natural_8_item (i))

					when {TUPLE}.Natural_16_code then
						writeable.write_natural_16 (tuple.natural_16_item (i))

					when {TUPLE}.Natural_32_code then
						writeable.write_natural_32 (tuple.natural_32_item (i))

					when {TUPLE}.Natural_64_code then
						writeable.write_natural_64 (tuple.natural_64_item (i))

					when {TUPLE}.Real_32_code then
						writeable.write_real_32 (tuple.real_32_item (i))

					when {TUPLE}.Real_64_code then
						writeable.write_real_64 (tuple.real_64_item (i))

					when {TUPLE}.Reference_code then
						if attached {READABLE_STRING_GENERAL} tuple.reference_item (i) as str then
							writeable.write_string_general (str)

						elseif attached {EL_PATH} tuple.reference_item (i) as path then
							writeable.write_string (path.to_string)
						end
				else
				end
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	new_type_array (static_type: INTEGER): EL_TUPLE_TYPE_ARRAY
		do
			create Result.make_from_static (static_type)
		end

feature {NONE} -- Internal attributes

	types_table: EL_CACHE_TABLE [EL_TUPLE_TYPE_ARRAY, INTEGER]

feature -- Contract Support

	is_filled (tuple: TUPLE; start_index, end_index: INTEGER): BOOLEAN
		do
			Result := across start_index |..| end_index as i_th all
				tuple.is_reference_item (i_th.item) implies attached tuple.reference_item (i_th.item)
			end
		end

feature {NONE} -- Constants

	Comma: STRING = ","

end