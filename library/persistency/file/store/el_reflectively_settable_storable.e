note
	description: "[
		Object that can read and write itself to a memory buffer of type [$source EL_MEMORY_READER_WRITER].
		Field reading, writing and object comparison is handled using class reflection.
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-16 12:07:10 GMT (Sunday 16th July 2023)"
	revision: "70"

deferred class
	EL_REFLECTIVELY_SETTABLE_STORABLE

inherit
	EL_STORABLE
		rename
			write as write_to_memory
		undefine
			is_equal
		end

	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_storable_field
		export
			{EL_MEMORY_READER_WRITER} make_default, generating_type
		redefine
			is_equal, make_default, new_meta_data, use_default_values
		end

	EL_CSV_CONVERTABLE

	EL_MODULE_BUFFER; EL_MODULE_EXECUTABLE; EL_MODULE_LIO; EL_MODULE_REUSEABLE

	EL_SHARED_CLASS_ID; EL_SHARED_FACTORIES

feature {NONE} -- Initialization

	make_default
		do
			Precursor
		ensure then
			all_fields_storable: all_fields_storable
		end

feature -- Basic operations

	write_meta_data (output: EL_OUTPUT_MEDIUM; tab_count: INTEGER)
		local
			field_definition: STRING; collection_item_list: ARRAYED_LIST [EL_REFLECTIVELY_SETTABLE_STORABLE]
			enumeration_list: ARRAYED_LIST [EL_ENUMERATION [NUMERIC]]; field: EL_REFLECTED_FIELD
		do
			create enumeration_list.make (5)
			create collection_item_list.make (0)
			output.put_indented_line (tab_count, "class " + generator)
			across meta_data.field_list as list loop
				field := list.item
				-- Number
				output.put_indented_line (tab_count, "-- " + list.cursor_index.out)

				field_definition := new_field_definition (field)
				if attached {EL_STRING_FIELD_REPRESENTATION [ANY, ANY]} field.representation as representation then
					representation.append_comment (field_definition)
					if attached {EL_ENUMERATION [NUMERIC]} representation.item as enumeration then
						enumeration_list.extend (enumeration)
					end
				end
				if attached {EL_REFLECTED_COLLECTION [EL_REFLECTIVELY_SETTABLE_STORABLE]} field as collection then
					if attached {EL_MAKEABLE_READER_WRITER [EL_REFLECTIVELY_SETTABLE_STORABLE]} collection.reader_writer as rw then
						collection_item_list.extend (rw.new_item)
						if attached collection_item_list.last.generator as name then
							field_definition.append (" -- " + name + " -> EL_REFLECTIVELY_SETTABLE_STORABLE")
						end
					end
				end
				output.put_indented_line (tab_count + 1, field_definition)
			end
			output.put_new_line
			output.put_indented_line (tab_count, "-- CRC checksum ")
			output.put_indented_line (tab_count + 1, "Field_hash: NATURAL = " + field_hash.out)

			output.put_indented_line (tab_count, "end")

			across collection_item_list as list loop
				output.put_new_line
				list.item.write_meta_data (output, tab_count)
			end
			across enumeration_list as enum loop
				output.put_new_line
				enum.item.write_meta_data (output, tab_count)
			end
		end

feature -- Element change

	read_default (a_reader: EL_MEMORY_READER_WRITER)
			-- Read default (current) version of data
		local
			i, l_count: INTEGER_32
		do
			if attached meta_data.field_list as list then
				l_count := list.count
				from i := 1 until i > l_count loop
					read_field (list [i], a_reader)
					i := i + 1
				end
			end
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			-- Comparison
		do
			Result := all_fields_equal (other)
		end

feature {EL_CLASS_META_DATA} -- Access

	field_hash: NATURAL
		-- CRC checksum for field names and types of generating type
		deferred
		end

feature {NONE} -- Implementation

	all_fields_storable: BOOLEAN
		do
			Result := True
			across field_table as table until not Result loop
				if attached {EL_REFLECTED_REFERENCE [ANY]} table.item as ref_item then
					Result := is_storable_field (ref_item.category_id, ref_item.type_id)
				end
			end
		end

	is_storable_field (basic_type, type_id: INTEGER): BOOLEAN
		do
			if Eiffel.is_storable_type (basic_type, type_id) then
				Result := True

			elseif {ISE_RUNTIME}.type_conforms_to (type_id, Class_id.ARRAYED_LIST_ANY) then
				if Arrayed_list_factory.is_valid_type (type_id) then
					Result := Eiffel.is_storable_collection_type (type_id)
				end
			end
		end

	new_field_definition (field: EL_REFLECTED_FIELD): STRING
		local
			parts: EL_SPLIT_INTERVALS; index: INTEGER
		do
			Result := field.name + ": " + field.class_name
			if attached {EL_REFLECTED_TUPLE} field as tuple
				and then attached tuple.field_name_list as name_list
			then
				create parts.make_by_string (Result, ", ")
				from parts.finish until parts.before loop
					if parts.isfirst then
						index := Result.index_of ('[', 1) + 1
					else
						index := parts.item_lower
					end
					Result.insert_string (name_list [parts.index] + ": ", index)
					parts.back
				end
			end
		end

	new_meta_data: EL_CLASS_META_DATA
		local
			exception: POSTCONDITION_VIOLATION; field_structure_error: STRING
		do
			create Result.make (Current)
			if not Result.same_data_structure (field_hash) then
				field_structure_error := "ERROR: Field structure has changed"
				lio.put_new_line
				lio.put_labeled_string ("class " + generator, field_structure_error)
				lio.put_new_line
				lio.put_natural_field ("actual field_hash", Result.field_list.field_hash)
				lio.put_new_line_x2
				if not Executable.is_work_bench then
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
			field.set_from_memory (Current, a_reader)
		end

	use_default_values: BOOLEAN
		do
			Result := True
		end

note
	notes: "[
		There is support for automatic serialization fo the following types of field:

		**1.** All basic types and string references

		**2.** All references conforming to [$source EL_STORABLE]

		**3.** [$source TUPLE] with type members that are either basic types or string references

		Fields which have a note option marking them as ''transient'' are excluded from the `field_table'
		Also any fields listed in the `Transient_fields' string will be treated the same.

			Transient_fields: STRING
				once
					Result := Precursor + ", foo_bar"
				end

		**Initialization**

		Routine `make_default' automatically initializes attribute fields as follows:

		**1.** String references are automatically initialized to a shared empty string.

		**2.** TUPLE references are initialized with a new tuple of the appropriate type.
		Any string tuple members are initialized to a shared empty string.

		**3.** Any type that is listed in a redefinition of routine `{[$source EL_REFLECTIVE]}.default_values'
	]"

end