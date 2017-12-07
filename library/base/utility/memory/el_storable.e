note
	description: "[
		Object that can read and write itself to a memory buffer of type `EL_MEMORY_READER_WRITER'.
	]"
	instructions: "See end of page"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-02 14:08:19 GMT (Saturday 2nd December 2017)"
	revision: "7"

deferred class
	EL_STORABLE

inherit
	EL_REFLECTIVELY_SETTABLE [ZSTRING]
		export
			{EL_MEMORY_READER_WRITER} make_default, generating_type
		redefine
			is_equal, Except_fields, equal_reference_fields
		end

	EL_MODULE_LIO
		undefine
			is_equal
		end

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32
		undefine
			is_equal
		end

feature -- Basic operations

	read (a_reader: EL_MEMORY_READER_WRITER)
		do
			if a_reader.is_default_data_version then
				read_default (a_reader)
			else
				read_version (a_reader, a_reader.data_version)
			end
		end

	write (a_writer: EL_MEMORY_READER_WRITER)
		local
			object: REFLECTED_REFERENCE_OBJECT
			i, field_count: INTEGER; storable_fields: ARRAY [INTEGER]
		do
			object := new_current_object (Current)
			storable_fields := Once_storable_fields.item (Current)
			field_count := storable_fields.count
			from i := 1 until i > field_count loop
				write_field (storable_fields [i], object, a_writer)
				i := i + 1
			end
			recycle (object)
		ensure
			reversable: a_writer.is_default_data_version implies is_reversible (a_writer, old a_writer.count)
		end

feature -- Status query

	is_deleted: BOOLEAN

feature {EL_STORABLE_HANDLER} -- Status change

	delete
			-- mark item as deleted
		do
			is_deleted := True
		end

	undelete
		do
			is_deleted := False
		end

feature -- Basic operations

	print_field_data
		do
			print_filtered_field_data (Print_field_data_exclusions)
		end

	print_field_info
		local
			object: REFLECTED_REFERENCE_OBJECT; i, field_count, line_length, length: INTEGER
			storable_fields: ARRAY [INTEGER]
			number, name: STRING
		do
			object := new_current_object (Current)
			storable_fields := Once_storable_fields.item (Current)
			field_count := storable_fields.count

			from i := 1 until i > field_count loop
				number := i.out; name := object.field_name (storable_fields [i])
				length := number.count + name.count + 2
				if i = 1 then
					length := length - number.count
					number.prepend (generator + " fields: ")
					length := length + number.count
				else
					lio.put_string (", ")
					if line_length + length > Info_line_length then
						lio.put_new_line
						line_length := 0
					end
				end
				lio.put_labeled_string (number, name)
				line_length := line_length + length
				i := i + 1
			end
			lio.put_new_line
			recycle (object)
		end

	print_filtered_field_data (exclusions: ARRAY [INTEGER])
		local
			object: REFLECTED_REFERENCE_OBJECT; i, field_count, line_length, length: INTEGER
			storable_fields: ARRAY [INTEGER]
			name: STRING; value: ZSTRING
		do
			object := new_current_object (Current)
			storable_fields := Once_storable_fields.item (Current)
			field_count := storable_fields.count

			from i := 1 until i > field_count loop
				if not exclusions.has (i) then
					name := object.field_name (storable_fields [i])
					value := field_item_from_index (storable_fields [i])
					length := name.count + value.count + 2
					if line_length > 0 then
						lio.put_string (", ")
						if line_length + length > Info_line_length then
							lio.put_new_line
							line_length := 0
						end
					end
					lio.put_labeled_string (name, value)
					line_length := line_length + length
				end
				i := i + 1
			end
			lio.put_new_line
			recycle (object)
		end

feature -- Element change

	read_default (a_reader: EL_MEMORY_READER_WRITER)
			-- Read default (current) version of data
		local
			object: REFLECTED_REFERENCE_OBJECT; i, field_count: INTEGER
			storable_fields: ARRAY [INTEGER]
		do
			object := new_current_object (Current)
			storable_fields := Once_storable_fields.item (Current)
			field_count := storable_fields.count
			from i := 1 until i > field_count loop
				read_field (storable_fields [i], object, a_reader)
				i := i + 1
			end
			recycle (object)
		end

feature {EL_STORABLE} -- Implementation

	adjust_field_order (fields: ARRAY [INTEGER])
		do
		end

	do_swaps (fields: ARRAY [INTEGER]; tuple_list: ARRAY [TUPLE [i, j: INTEGER]])
		-- do each swap for tuples `i' and `j'
		local
			swap_fields: PROCEDURE [INTEGER, INTEGER]
		do
			swap_fields := agent swap (fields, ?, ?)
			tuple_list.do_all (agent swap_fields.call)
		end

	read_default_version (a_reader: EL_MEMORY_READER_WRITER; version: NATURAL)
			-- Read version compatible with default version
		do
			read_default (a_reader)
		end

	read_version (a_reader: EL_MEMORY_READER_WRITER; version: NATURAL)
			-- Read version compatible with software version
		deferred
		end

	swap (fields: ARRAY [INTEGER]; i, j: INTEGER)
		-- swap order of fields `i' and `j'
		local
			n: INTEGER
		do
			n := fields [j]
			fields [j] := fields [i]
			fields [i] := n
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		local
			object, other_object: REFLECTED_REFERENCE_OBJECT
			i, count: INTEGER; area: SPECIAL [INTEGER]; fields: ARRAY [INTEGER]
		do
			object := new_current_object (Current); other_object := new_current_object (other)
			fields := Once_storable_fields.item (Current)
			count := fields.count; area := fields.area
			from Result := True; i := 0 until not Result or i = count loop
				Result := equal_fields (object, other_object, area [i])
				i := i + 1
			end
			recycle (object); recycle (other_object)
		end

feature {NONE} -- Contract Support

	is_reversible (a_writer: EL_MEMORY_READER_WRITER; from_count: INTEGER): BOOLEAN
		do
			Result := is_equal (read_twin (a_writer, from_count))
		end

	read_twin (a_writer: EL_MEMORY_READER_WRITER; from_count: INTEGER): like Current
		local
			reader: EL_MEMORY_READER_WRITER
		do
			create reader.make_with_buffer (a_writer.buffer); reader.set_count (from_count)
			Result := new_twin; Result.read (reader)
		end

feature {NONE} -- Read operations

	read_field (field: INTEGER; object: REFLECTED_REFERENCE_OBJECT; a_reader: EL_MEMORY_READER_WRITER)
		require
			valid_field: not Excluded_fields_by_type.item (Current).has (field) and then is_storable (field, object)
		do
			inspect object.field_type (field)
				when Reference_type then
					read_reference_field (field, object, a_reader)

				when Boolean_type then
					object.set_boolean_field (field, a_reader.read_boolean)		 	-- BOOLEAN

				when Integer_8_type then
					object.set_integer_8_field (field, a_reader.read_integer_8) 		-- INTEGER_8

				when Integer_16_type then
					object.set_integer_16_field (field, a_reader.read_integer_16) 	-- INTEGER_16

				when Integer_32_type then
					object.set_integer_32_field (field, a_reader.read_integer_32) 	-- INTEGER_32

				when Integer_64_type then
					object.set_integer_64_field (field, a_reader.read_integer_64) 	-- INTEGER_64

				when Real_type then
					object.set_real_32_field (field, a_reader.read_real_32)			-- REAL

				when Real_64_type then
					object.set_real_64_field (field, a_reader.read_real_64)			-- REAL_64

				when Natural_8_type then
					object.set_natural_8_field (field, a_reader.read_natural_8) 	-- NATURAL_8

				when Natural_16_type then
					object.set_natural_16_field (field, a_reader.read_natural_16) 	-- NATURAL_16

				when Natural_32_type then
					object.set_natural_32_field (field, a_reader.read_natural_32) 	-- NATURAL_32

				when Natural_64_type then
					object.set_natural_64_field (field, a_reader.read_natural_64) 	-- NATURAL_64
			else
			end
		end

	read_reference_field (field: INTEGER; object: REFLECTED_REFERENCE_OBJECT; a_reader: EL_MEMORY_READER_WRITER)
		local
			type_id: INTEGER; reference_item: ANY
		do
			type_id := object.field_static_type (field)

			-- Cannot use inspect becase String_z_type is once function
			if type_id = String_8_type then
				object.set_reference_field (field, a_reader.read_string_8)	-- STRING_8

			elseif type_id = String_32_type then
				object.set_reference_field (field, a_reader.read_string_32)	-- STRING_32

			elseif type_id = String_z_type then
				object.set_reference_field (field, read_string (a_reader))	-- ZSTRING

			else
				reference_item := object.reference_field (field)
				if attached {EL_STORABLE} reference_item as readable then
					readable.read (a_reader)														-- EL_STORABLE

				elseif attached {TUPLE} reference_item as tuple then
					read_tuple (tuple, a_reader)													-- TUPLE
				end
			end
		end

	read_string (a_reader: EL_MEMORY_READER_WRITER): ZSTRING
		do
			Result := a_reader.read_string
		end

	read_tuple (tuple: TUPLE; a_reader: EL_MEMORY_READER_WRITER)
		local
			i: INTEGER; reference_item: ANY
		do
			from i := 1 until i > tuple.count loop
				inspect tuple.item_code (i)
					when {TUPLE}.Boolean_code then
						tuple.put_boolean (a_reader.read_boolean, i)						-- BOOLEAN

					when {TUPLE}.Integer_16_code then
						tuple.put_integer_16 (a_reader.read_integer_16, i)				-- INTEGER_16

					when {TUPLE}.Integer_32_code then
						tuple.put_integer (a_reader.read_integer_32, i)					-- INTEGER_32

					when {TUPLE}.Integer_64_code then
						tuple.put_integer_64 (a_reader.read_integer_64, i)				-- INTEGER_64

					when {TUPLE}.Natural_16_code then
						tuple.put_natural_16 (a_reader.read_natural_16, i)				-- NATURAL_16

					when {TUPLE}.Natural_32_code then
						tuple.put_natural_32 (a_reader.read_natural_32, i)				-- NATURAL_32

					when {TUPLE}.Natural_64_code then
						tuple.put_natural_64 (a_reader.read_natural_64, i)				-- NATURAL_64

					when {TUPLE}.Reference_code then
						reference_item := tuple.reference_item (i)
						if attached {ZSTRING} reference_item then
							tuple.put_reference (read_string (a_reader), i)				-- ZSTRING
						elseif attached {STRING} reference_item then
							tuple.put_reference (a_reader.read_string_8, i)				-- STRING_8
						elseif attached {STRING_32} reference_item then
							tuple.put_reference (a_reader.read_string_32, i)			-- STRING_32
						end
				else
				end
				i := i + 1
			end
		end

feature {NONE} -- Write operations

	write_field (field: INTEGER; object: REFLECTED_REFERENCE_OBJECT; a_writer: EL_MEMORY_READER_WRITER)
		require
			valid_field: not Excluded_fields_by_type.item (Current).has (field) and then is_storable (field, object)
		do
			inspect object.field_type (field)
				when Reference_type then
					write_reference_field (object.reference_field (field), a_writer)

				when Boolean_type then
					a_writer.write_boolean (object.boolean_field (field)) 				-- BOOLEAN

				when Integer_8_type then
					a_writer.write_integer_8 (object.integer_8_field (field))			-- INTEGER_8

				when Integer_16_type then
					a_writer.write_integer_16 (object.integer_16_field (field)) 		-- INTEGER_16

				when Integer_32_type then
					a_writer.write_integer_32 (object.integer_32_field (field)) 		-- INTEGER_32

				when Integer_64_type then
					a_writer.write_integer_64 (object.integer_64_field (field)) 		-- INTEGER_64

				when Real_32_type then
					a_writer.write_real_32 (object.real_32_field (field)) 				-- REAL_32

				when Real_64_type then
					a_writer.write_real_64 (object.real_64_field (field)) 				-- REAL_64

				when Natural_8_type then
					a_writer.write_natural_8 (object.natural_8_field (field)) 			-- NATURAL_8

				when Natural_16_type then
					a_writer.write_natural_16 (object.natural_16_field (field)) 		-- NATURAL_16

				when Natural_32_type then
					a_writer.write_natural_32 (object.natural_32_field (field)) 		-- NATURAL_32

				when Natural_64_type then
					a_writer.write_natural_64 (object.natural_64_field (field)) 		-- NATURAL_64

			else
			end
		end

	write_reference_field (item: ANY; a_writer: EL_MEMORY_READER_WRITER)
		do
			if attached {STRING_GENERAL} item as str then
				if attached {ZSTRING} str as str_z then
					a_writer.write_string (str_z)					-- ZSTRING

				elseif attached {STRING_8} str as str_8 then
					a_writer.write_string_8 (str_8)				-- STRING_8

				elseif attached {STRING_32} str as str_32 then
					a_writer.write_string_32 (str_32)			-- STRING_32
				end
			elseif attached {EL_STORABLE} item as writeable then
				writeable.write (a_writer)							-- EL_MEMORY_READ_WRITEABLE

			elseif attached {TUPLE} item as tuple then
				write_tuple (tuple, a_writer)						-- TUPLE
			end
		end

	write_tuple (tuple: TUPLE; a_writer: EL_MEMORY_READER_WRITER)
		local
			i: INTEGER
		do
			from i := 1 until i > tuple.count loop
				inspect tuple.item_code (i)
					when {TUPLE}.Boolean_code then
						a_writer.write_boolean (tuple.boolean_item (i))					-- BOOLEAN

					when {TUPLE}.Integer_16_code then
						a_writer.write_integer_16 (tuple.integer_16_item (i))			-- INTEGER_16

					when {TUPLE}.Integer_32_code then
						a_writer.write_integer_32 (tuple.integer_32_item (i))			-- INTEGER_32

					when {TUPLE}.Integer_64_code then
						a_writer.write_integer_64 (tuple.integer_64_item (i))			-- INTEGER_64

					when {TUPLE}.Natural_16_code then
						a_writer.write_natural_16 (tuple.natural_16_item (i))			-- NATURAL_16

					when {TUPLE}.Natural_32_code then
						a_writer.write_natural_32 (tuple.natural_32_item (i))			-- NATURAL_32

					when {TUPLE}.Natural_64_code then
						a_writer.write_natural_64 (tuple.natural_64_item (i))			-- NATURAL_64

					when {TUPLE}.Reference_code then
						write_reference_field (tuple.reference_item (i), a_writer)
				else
				end
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	equal_reference_fields (object, other_object: REFLECTED_REFERENCE_OBJECT; index: INTEGER): BOOLEAN
		local
			type_id: INTEGER; reference_item, other_reference_item: ANY
		do
			type_id := object.field_static_type (index)
			reference_item := object.reference_field (index)
			other_reference_item := other_object.reference_field (index)
			if String_types.has (type_id) or else attached {EL_STORABLE} reference_item						-- EL_STORABLE
				or else attached {TUPLE} reference_item as tuple and then tuple.object_comparison			-- TUPLE
			then
				Result := reference_item ~ other_reference_item
			else
				Result := True
			end
		end

	field_hash (storable_fields: ARRAY [INTEGER]): NATURAL
		local
			object: REFLECTED_REFERENCE_OBJECT; i, field_count: INTEGER
			crc: like crc_generator
		do
			object := new_current_object (Current)
			field_count := storable_fields.count
			crc := crc_generator
			from i := 1 until i > field_count loop
				crc.add_string_8 (object.field_name (storable_fields [i]))
				i := i + 1
			end
			Result := crc.checksum
			recycle (object)
		end

	field_hash_checksum: NATURAL
		-- hash of all field names in same order as `new_storable_fields'
		deferred
		end

	is_storable (field: INTEGER; object: REFLECTED_REFERENCE_OBJECT): BOOLEAN
		local
			type_id: INTEGER; reference_field: ANY
		do
			inspect object.field_type (field)
				when Reference_type then
					type_id := object.field_static_type (field)
					-- Cannot use inspect becase String_z_type is once function
					if type_id = String_8_type or else type_id = String_32_type or else type_id = String_z_type then
						Result := True
					else
						reference_field := object.reference_field (field)
						if attached {EL_STORABLE} reference_field then
							Result := True
						elseif attached {TUPLE} reference_field as tuple then
							Result := is_storable_tuple (tuple)
						end
					end
				when Integer_8_type, Integer_16_type, Integer_32_type, Integer_64_type,
					  Natural_8_type, Natural_16_type, Natural_32_type, Natural_64_type,
					  Real_32_type, Real_64_type, Boolean_type
				then
					Result := True
			else
			end
		end

	is_storable_tuple (tuple: TUPLE): BOOLEAN
		local
			i: INTEGER; reference_item: ANY
		do
			Result := True
			from i := 1 until not Result or else i > tuple.count loop
				inspect tuple.item_code (i)
					when
						{TUPLE}.Boolean_code,
						{TUPLE}.Integer_16_code, {TUPLE}.Integer_32_code, {TUPLE}.Integer_64_code,
						{TUPLE}.Natural_16_code, {TUPLE}.Natural_32_code, {TUPLE}.Natural_64_code
					then
						-- do nothing
					when {TUPLE}.Reference_code then
						reference_item := tuple.reference_item (i)
						if not attached {STRING_GENERAL} reference_item then
							Result := False
						end
				else
					Result := False
				end
				i := i + 1
			end
		end

feature {EL_STORABLE} -- Factory

	new_storable_fields: ARRAY [INTEGER]
			-- field indices of storable fields
		local
			object: REFLECTED_REFERENCE_OBJECT; i, field_count: INTEGER
			excluded_indices: like new_field_indices_set; l_result: ARRAYED_LIST [INTEGER]
		do
			object := new_current_object (Current)
			field_count := object.field_count
			excluded_indices := Excluded_fields_by_type.item (Current)

			create l_result.make (object.field_count)
			from i := 1 until i > field_count loop
				excluded_indices.binary_search (i)
				if not excluded_indices.found and then is_storable (i, object) then
					l_result.extend (i)
				end
				i := i + 1
			end
			Result := l_result.to_array
			adjust_field_order (Result)
			recycle (object)
		ensure
			field_names_and_order_unchanged: field_hash (Result) = field_hash_checksum
		end

	new_twin: like Current
		do
			Result := twin
		end

feature {NONE} -- Constants

	Except_fields: STRING
		once
			Result := Precursor + ", is_deleted"
		end

	Info_line_length: INTEGER
		once
			Result := 100
		end

	Once_storable_fields: EL_FUNCTION_RESULT_TABLE [EL_STORABLE, ARRAY [INTEGER]]
		once
			create Result.make (11, agent {EL_STORABLE}.new_storable_fields)
		end

	Print_field_data_exclusions: ARRAY [INTEGER]
		do
			create Result.make_empty
		end

note
	instructions: "[
		There is support for automatic reading and writing of the following attribute types:

		* Basic types conforming to `NUMERIC'
		* Basic string types conforming to `STRING_GENERAL'. Includes `STRING_8', `STRING_32' and `EL_ZSTRING'
		(AKA `ZSTRING').
		* Types conforming to `EL_STORABLE'. (recursion)
		* A `TUPLE' type composed of any of the previously mentioned types. (recursion)

		Override the function `excluded_fields' to define a list of fields which should not be storable.
	]"

end
