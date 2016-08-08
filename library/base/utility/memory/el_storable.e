note
	description: "[
		Object that can read and write itself to a memory buffer of type `EL_MEMORY_READER_WRITER'.
	]"

	instructions: "See end of page"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-29 14:51:13 GMT (Friday 29th July 2016)"
	revision: "1"

deferred class
	EL_STORABLE

inherit
	EL_REFLECTOR_CONSTANTS
		export
			{EL_MEMORY_READER_WRITER} generating_type
		redefine
			is_equal
		end

feature {EL_MEMORY_READER_WRITER} -- Initialization

	make_default
		deferred
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
			current_object: REFLECTED_REFERENCE_OBJECT
			i, field_count: INTEGER; storable_fields: ARRAY [INTEGER]
		do
			current_object := new_current_object
			storable_fields := Once_storable_fields.item ({like Current}, agent new_storable_fields)
			field_count := storable_fields.count
			from i := 1 until i > field_count loop
				write_field (storable_fields [i], current_object, a_writer)
				i := i + 1
			end
			Reflected_object_pool.put (current_object)
		ensure
			reversable: a_writer.is_default_data_version implies is_reversible (a_writer, old a_writer.count)
		end

feature -- Status query

	is_deleted: BOOLEAN

feature -- Status change

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

	print_info
		do
		end

feature {EL_STORABLE} -- Implementation

	read_default (a_reader: EL_MEMORY_READER_WRITER)
			-- Read default (current) version of data
		local
			current_object: REFLECTED_REFERENCE_OBJECT; i, field_count: INTEGER
			storable_fields: ARRAY [INTEGER]
		do
			current_object := new_current_object
			storable_fields := Once_storable_fields.item ({like Current}, agent new_storable_fields)
			field_count := storable_fields.count
			from i := 1 until i > field_count loop
				read_field (storable_fields [i], current_object, a_reader)
				i := i + 1
			end
			Reflected_object_pool.put (current_object)
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

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		local
			current_object, other_object: REFLECTED_REFERENCE_OBJECT
			storable_fields: ARRAY [INTEGER]; i, field_count: INTEGER
		do
			current_object := new_current_object; other_object := new_current_object
			other_object.set_object (other)
			storable_fields := Once_storable_fields.item ({like Current}, agent new_storable_fields)
			field_count := storable_fields.count
			Result := True
			from i := 1 until i > field_count or else not Result loop
				Result := Result and equal_fields (storable_fields [i], current_object, other_object)
				i := i + 1
			end
			Reflected_object_pool.put (current_object)
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

	read_field (field: INTEGER; current_object: REFLECTED_REFERENCE_OBJECT; a_reader: EL_MEMORY_READER_WRITER)
		local
			type_id: INTEGER
		do
			type_id := current_object.field_type (field)
			inspect type_id
				when Boolean_type then
					current_object.set_boolean_field (field, a_reader.read_boolean)		 	-- BOOLEAN

				when Integer_8_type then
					current_object.set_integer_8_field (field, a_reader.read_integer_8) 		-- INTEGER_8

				when Integer_16_type then
					current_object.set_integer_16_field (field, a_reader.read_integer_16) 	-- INTEGER_16

				when Integer_32_type then
					current_object.set_integer_32_field (field, a_reader.read_integer_32) 	-- INTEGER_32

				when Integer_64_type then
					current_object.set_integer_64_field (field, a_reader.read_integer_64) 	-- INTEGER_64

				when Real_type then
					current_object.set_real_32_field (field, a_reader.read_real_32)			-- REAL

				when Real_64_type then
					current_object.set_real_64_field (field, a_reader.read_real_64)			-- REAL_64

				when Natural_8_type then
					current_object.set_natural_8_field (field, a_reader.read_natural_8) 	-- NATURAL_8

				when Natural_16_type then
					current_object.set_natural_16_field (field, a_reader.read_natural_16) 	-- NATURAL_16

				when Natural_32_type then
					current_object.set_natural_32_field (field, a_reader.read_natural_32) 	-- NATURAL_32

				when Natural_64_type then
					current_object.set_natural_64_field (field, a_reader.read_natural_64) 	-- NATURAL_64
			else
				read_reference_field (field, current_object, a_reader)
			end
		end

	read_reference_field (field: INTEGER; current_object: REFLECTED_REFERENCE_OBJECT; a_reader: EL_MEMORY_READER_WRITER)
		local
			type_id: INTEGER; reference_item: ANY
		do
			type_id := current_object.field_static_type (field)

			-- Cannot use inspect becase String_z_type is once function
			if type_id = String_8_type then
				current_object.set_reference_field (field, a_reader.read_string_8)	-- STRING_8

			elseif type_id = String_32_type then
				current_object.set_reference_field (field, a_reader.read_string_32)	-- STRING_32

			elseif type_id = String_z_type then
				current_object.set_reference_field (field, read_string (a_reader))	-- ZSTRING

			else
				reference_item := current_object.reference_field (field)
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

	write_field (field: INTEGER; current_object: REFLECTED_REFERENCE_OBJECT; a_writer: EL_MEMORY_READER_WRITER)
		local
			type_id: INTEGER
		do
			type_id := current_object.field_type (field)
			inspect type_id
				when Boolean_type then
					a_writer.write_boolean (current_object.boolean_field (field)) 				-- BOOLEAN

				when Integer_8_type then
					a_writer.write_integer_8 (current_object.integer_8_field (field)) 		-- INTEGER_8

				when Integer_16_type then
					a_writer.write_integer_16 (current_object.integer_16_field (field)) 		-- INTEGER_16

				when Integer_32_type then
					a_writer.write_integer_32 (current_object.integer_32_field (field)) 		-- INTEGER_32

				when Integer_64_type then
					a_writer.write_integer_64 (current_object.integer_64_field (field)) 		-- INTEGER_64

				when Real_32_type then
					a_writer.write_real_32 (current_object.real_32_field (field)) 				-- REAL_32

				when Real_64_type then
					a_writer.write_real_64 (current_object.real_64_field (field)) 				-- REAL_64

				when Natural_8_type then
					a_writer.write_natural_8 (current_object.natural_8_field (field)) 		-- NATURAL_8

				when Natural_16_type then
					a_writer.write_natural_16 (current_object.natural_16_field (field)) 		-- NATURAL_16

				when Natural_32_type then
					a_writer.write_natural_32 (current_object.natural_32_field (field)) 		-- NATURAL_32

				when Natural_64_type then
					a_writer.write_natural_64 (current_object.natural_64_field (field)) 		-- NATURAL_64

				when Reference_type then
					write_reference_field (current_object.reference_field (field), a_writer)
			else
			end
		end

	write_reference_field (item: ANY; a_writer: EL_MEMORY_READER_WRITER)
		do
			if attached {ZSTRING} item as zstring then
				a_writer.write_string (zstring)					-- ZSTRING

			elseif attached {STRING} item as string then
				a_writer.write_string_8 (string)					-- STRING

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

	equal_fields (field: INTEGER; current_object, other_object: REFLECTED_REFERENCE_OBJECT): BOOLEAN
		local
			type_id: INTEGER; reference_item, other_reference_item: ANY
		do
			type_id := current_object.field_type (field)
			inspect type_id
				when Boolean_type then
					Result := current_object.boolean_field (field) = other_object.boolean_field (field)	 		-- BOOLEAN

				when Integer_8_type then
					Result := current_object.integer_8_field (field) = other_object.integer_8_field (field) 	-- INTEGER_8

				when Integer_16_type then
					Result := current_object.integer_16_field (field) = other_object.integer_16_field (field) -- INTEGER_16

				when Integer_32_type then
					Result := current_object.integer_32_field (field) = other_object.integer_32_field (field) -- INTEGER_32

				when Integer_64_type then
					Result := current_object.integer_64_field (field) = other_object.integer_64_field (field) -- INTEGER_64

				when Real_32_type then
					Result := current_object.real_32_field (field) = other_object.real_32_field (field)			-- REAL_32

				when Real_64_type then
					Result := current_object.real_64_field (field) = other_object.real_64_field (field)			-- REAL_64

				when Natural_8_type then
					Result := current_object.natural_8_field (field) = other_object.natural_8_field (field)	-- NATURAL_8

				when Natural_16_type then
					Result := current_object.natural_16_field (field) = other_object.natural_16_field (field)	-- NATURAL_16

				when Natural_32_type then
					Result := current_object.natural_32_field (field)  = other_object.natural_32_field (field)-- NATURAL_32

				when Natural_64_type then
					Result := current_object.natural_64_field (field) = other_object.natural_64_field (field) -- NATURAL_64
			else
				type_id := current_object.field_static_type (field)
				reference_item := current_object.reference_field (field)
				other_reference_item := other_object.reference_field (field)
				if String_types.has (type_id) or else attached {EL_STORABLE} reference_item						-- EL_STORABLE
					or else attached {TUPLE} reference_item as tuple and then tuple.object_comparison			-- TUPLE
				then
					Result := reference_item ~ other_reference_item
				else
					Result := True
				end
			end
		end

	excluded_fields: ARRAY [STRING]
		-- storable fields to be excluded from read/write
		do
			create Result.make_empty
		end

	is_storable (field: INTEGER; current_object: REFLECTED_REFERENCE_OBJECT): BOOLEAN
		local
			type_id: INTEGER; reference_field: ANY
		do
			type_id := current_object.field_type (field)
			inspect type_id when
				Boolean_type,
				Integer_8_type, Integer_16_type, Integer_32_type, Integer_64_type,
				Natural_8_type, Natural_16_type, Natural_32_type, Natural_64_type,
				Real_32_type, Real_64_type
			then
				Result := True
			else
				type_id := current_object.field_static_type (field)
				-- Cannot use inspect becase String_z_type is once function
				if type_id = String_8_type or else type_id = String_32_type or else type_id = String_z_type then
					Result := True
				else
					reference_field := current_object.reference_field (field)
					if attached {EL_STORABLE} reference_field then
						Result := True
					elseif attached {TUPLE} reference_field as tuple then
						Result := is_storable_tuple (tuple)
					end
				end
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

	new_current_object: REFLECTED_REFERENCE_OBJECT
		local
			pool: like Reflected_object_pool
		do
			pool := Reflected_object_pool
			if pool.is_empty then
				create Result.make (Current)
			else
				Result := pool.item
				Result.set_object (Current)
				pool.remove
			end
		end

	new_storable_fields: ARRAY [INTEGER]
			-- field indices of storable fields
		local
			current_object: REFLECTED_REFERENCE_OBJECT; i, field_count: INTEGER
			exclusions: EL_HASH_SET [STRING]; l_result: ARRAYED_LIST [INTEGER]
		do
			current_object := new_current_object
			field_count := current_object.field_count
			create exclusions.make_from_array (excluded_fields)
			exclusions.put ("is_deleted")

			create l_result.make (current_object.field_count)
			from i := 1 until i > field_count loop
				if is_storable (i, current_object) and then not exclusions.has (current_object.field_name (i)) then
					l_result.extend (i)
				end
				i := i + 1
			end
			Result := l_result.to_array
			Reflected_object_pool.put (current_object)
		end

	new_twin: like Current
		do
			Result := twin
		end

feature {NONE} -- Constants

	Once_storable_fields: EL_TYPE_TABLE [ARRAY [INTEGER]]
		once
			create Result.make_equal (11)
		end

	Reflected_object_pool: ARRAYED_STACK [REFLECTED_REFERENCE_OBJECT]
		once
			create Result.make (3)
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
