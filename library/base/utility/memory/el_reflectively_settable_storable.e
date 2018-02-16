note
	description: "[
		Object that can read and write itself to a memory buffer of type `EL_MEMORY_READER_WRITER'.
		Field reading, writing and object comparison is handled using class reflection.
	]"
	notes: "[
		There is support for automatic serialization fo the following types of field:
		
		*1.* All basic types and string references
		
		*2.* All references conforming to `EL_STORABLE'
		
		*3.* TUPLE with type members that are either basic types or string references
		
		Override the once string Except_fields to list any fields which should not be stored.
		
			Except_fields: STRING
				once
					Result := Precursor + ", foo_bar"
				end
				
		*Initialization*
		
		Routine `make_default' automatically initializes attribute fields as follows:
		
		*1.* String references are automatically initialized to a shared empty string.
		
		*2.* TUPLE references are initialized with a new tuple of the appropriate type.
		Any string tuple members are initialized to a shared empty string.
		
		*3.* Any type that is registered in the reflection manager implementation of
		`initialize_reflection'. See class `[$source EL_SHARED_REFLECTION_MANAGER]'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-01-24 13:06:58 GMT (Wednesday 24th January 2018)"
	revision: "12"

deferred class
	EL_REFLECTIVELY_SETTABLE_STORABLE

inherit
	EL_STORABLE
		undefine
			is_equal, print_meta_data
		end

	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_storable_field
		export
			{EL_MEMORY_READER_WRITER} make_default, generating_type
		redefine
			is_equal, new_meta_data, use_default_values, Except_fields
		end

	EL_MODULE_EIFFEL
		undefine
			is_equal
		end

	EL_MODULE_LIO
		undefine
			is_equal
		end

	EL_MODULE_EXECUTION_ENVIRONMENT
		undefine
			is_equal
		end

feature -- Basic operations

	write (a_writer: EL_MEMORY_READER_WRITER)
		local
			field_array: EL_REFLECTED_FIELD_ARRAY
			i, field_count: INTEGER_32
		do
			field_array := Meta_data_by_type.item (Current).field_array
			field_count := field_array.count
			from i := 1 until i > field_count loop
				write_field (field_array [i], a_writer)
				i := i + 1
			end
		end

feature -- Element change

	read_default (a_reader: EL_MEMORY_READER_WRITER)
			-- Read default (current) version of data
		local
			field_array: EL_REFLECTED_FIELD_ARRAY
			i, field_count: INTEGER_32
		do
			field_array := Meta_data_by_type.item (Current).field_array
			field_count := field_array.count
			from i := 1 until i > field_count loop
				read_field (field_array [i], a_reader)
				i := i + 1
			end
		end

feature {EL_STORABLE_CLASS_META_DATA} -- Implementation

	adjust_field_order (fields: EL_REFLECTED_FIELD_ARRAY)
		do
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			-- Comparison
		do
			Result := all_fields_equal (other)
		end

feature {EL_STORABLE_CLASS_META_DATA} -- Access

	field_hash: NATURAL_32
		-- CRC checksum for field names and types of generating type
		deferred
		end

feature {NONE} -- Implementation

	is_storable_field (object: REFLECTED_REFERENCE_OBJECT; index: INTEGER_32): BOOLEAN
			-- hash of all field names in same order as new_storable_fields
		local
			type_id: INTEGER_32
		do
			inspect object.field_type (index)
			when Reference_type then
				type_id := object.field_static_type (index)
				if String_types.has (type_id) or else
					across << Boolean_ref_type, Date_time_type, Storable_type >> as base_type some
						object.field_conforms_to (type_id, base_type.item)
					end

				then
					Result := True
				elseif object.field_conforms_to (type_id, Tuple_type) then
					Result := is_storable_tuple (Eiffel.type_of_type (type_id))
				end
			when Pointer_type then
				Result := False
			else
				Result := True
			end
		end

	is_storable_tuple (type: TYPE [ANY]): BOOLEAN
		local
			i, count: INTEGER_32; member_type: TYPE [ANY]
		do
			Result := True
			count := type.generic_parameter_count
			from i := 1 until not Result or else i > count loop
				member_type := type.generic_parameter_type (i)
				if not member_type.is_expanded then
					Result := String_types.has (member_type.type_id)
				end
				i := i + 1
			end
		end

	new_meta_data: EL_STORABLE_CLASS_META_DATA
		local
			exception: POSTCONDITION_VIOLATION; field_structure_error: STRING
		do
			create Result.make (Current)
			if not Result.same_data_structure (field_hash) then
				field_structure_error := "ERROR: Field structure has changed"
				lio.put_new_line
				lio.put_labeled_string ("class " + generator, field_structure_error)
				lio.put_new_line
				print_field_meta_data (lio, Result.field_array)
				lio.put_new_line
				if not Execution_environment.is_work_bench_mode then
					create exception
					exception.set_description (field_structure_error)
					exception.raise
				end
			end
		ensure then
			same_data_structure: Result.same_data_structure (field_hash)
		end

	read_field (field: EL_REFLECTED_FIELD; a_reader: EL_MEMORY_READER_WRITER)
			-- Read operations
		do
			if attached {EL_REFLECTED_READABLE} field as readable then
				readable.read (Current, a_reader)
			else
				field.set_from_readable (Current, a_reader)
			end
		end

	use_default_values: BOOLEAN
		do
			Result := True
		end

	write_field (field: EL_REFLECTED_FIELD; a_writer: EL_MEMORY_READER_WRITER)
			-- Write operations
		do
			if attached {EL_REFLECTED_STORABLE} field as storable_field then
				storable_field.write (Current, a_writer)
			else
				field.write (Current, a_writer)
			end
		end

feature {NONE} -- Constants

	Except_fields: STRING_8
			-- list of comma-separated fields to be excluded
		once
			Result := Precursor + ", is_deleted"
		end

end

