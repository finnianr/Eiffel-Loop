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
	date: "2022-12-18 12:50:01 GMT (Sunday 18th December 2022)"
	revision: "66"

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

	write (writable: EL_WRITABLE)
		do
			meta_data.field_list.write (Current, writable)
		end

	write_to_memory (memory: EL_MEMORY_READER_WRITER)
		do
			meta_data.field_list.write_to_memory (Current, memory)
		end

	write_as_pyxis (output: EL_OUTPUT_MEDIUM; tab_count: INTEGER)
		local
			name: STRING; value: ZSTRING; is_pyxis_attribute: SPECIAL [BOOLEAN]
		do
			create is_pyxis_attribute.make_filled (False, field_table.count)
			value := buffer.empty
			write_pyxis_attributes (output, tab_count, is_pyxis_attribute)

			across meta_data.alphabetical_list as list loop
				name := list.item.name
				if not is_pyxis_attribute [list.cursor_index - 1] then
					if attached {EL_REFLECTED_STORABLE} list.item as storable_field
						and then attached {EL_REFLECTIVELY_SETTABLE_STORABLE} storable_field.value (Current) as storable
					then
						write_pyxis_field (output, name, tab_count)
						storable.write_as_pyxis (output, tab_count + 1)
					elseif attached {EL_REFLECTED_TUPLE} list.item as tuple_field
						and then attached tuple_field.value (Current) as tuple
						and then attached tuple_field.field_name_list as name_list
					then
						write_pyxis_field (output, name, tab_count)
						write_pyxis_tuple (output, tab_count + 1, tuple_field, tuple, name_list)
					else
						value.wipe_out
						list.item.append_to_string (Current, value)
						if value.has ('%N') then
							write_pyxis_field (output, name, tab_count)
							write_pyxis_manifest (output, value, tab_count + 1)

						elseif value.count > 0 then
							value.enclose ('"', '"')
							write_pyxis_field (output, name, tab_count)
							output.put_indented_line (tab_count + 1, value)
						end
					end
				end
			end
		end

	write_meta_data (output: EL_OUTPUT_MEDIUM; tab_count: INTEGER)
		local
			field_definition: STRING; enumeration_list: ARRAYED_LIST [EL_ENUMERATION [NUMERIC]]
			collection_item_list: ARRAYED_LIST [EL_REFLECTIVELY_SETTABLE_STORABLE]
		do
			create enumeration_list.make (5)
			create collection_item_list.make (0)
			output.put_indented_line (tab_count, "class " + generator)
			across meta_data.field_list as list loop
				-- Number
				output.put_indented_line (tab_count, "-- " + list.cursor_index.out)

				field_definition := list.item.name + ": " + list.item.class_name
				if attached {EL_STRING_FIELD_REPRESENTATION [ANY, ANY]} list.item.representation as representation then
					representation.append_comment (field_definition)
					if attached {EL_ENUMERATION [NUMERIC]} representation.item as enumeration then
						enumeration_list.extend (enumeration)
					end
				end
				if attached {EL_REFLECTED_COLLECTION [EL_REFLECTIVELY_SETTABLE_STORABLE]} list.item as collection then
					if attached {EL_STORABLE_READER_WRITER [EL_REFLECTIVELY_SETTABLE_STORABLE]} collection.reader_writer as rw then
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

	attribute_line_index (field: EL_REFLECTED_FIELD): INTEGER
		do
			if attached {EL_REFLECTED_BOOLEAN} field then
				Result := 2
			elseif attached {EL_REFLECTED_BOOLEAN_REF} field then
				Result := 2

			elseif attached {EL_REFLECTED_EXPANDED_FIELD [ANY]} field as expanded_field then
				if expanded_field.has_string_representation then
					Result := 3
				else
					Result := 1
				end
			end
		ensure
			valid_index: Result <= Once_attribute_lines.count
		end

	is_storable_field (basic_type, type_id: INTEGER_32): BOOLEAN
		do
			if Eiffel.is_storable_type (basic_type, type_id) then
				Result := True

			elseif {ISE_RUNTIME}.type_conforms_to (type_id, Class_id.ARRAYED_LIST_ANY) then
				if Arrayed_list_factory.is_valid_type (type_id) then
					Result := Eiffel.is_storable_type (basic_type, Eiffel.collection_item_type (type_id))
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

	write_pyxis_attributes (output: EL_OUTPUT_MEDIUM; tab_count: INTEGER; is_pyxis_attribute: SPECIAL [BOOLEAN])
		local
			attribute_lines: EL_ZSTRING_LIST; value: ZSTRING; line_index: INTEGER
			name: STRING
		do
			value := buffer.empty; attribute_lines := Once_attribute_lines
			across Reuseable.string_pool as pool loop
				from attribute_lines.wipe_out until attribute_lines.full loop
					attribute_lines.extend (pool.borrowed_item)
				end
				across meta_data.alphabetical_list as list loop
					-- output numeric as Pyxis element attributes
					name := list.item.name
					line_index := attribute_line_index (list.item)
					if line_index > 0 then
						is_pyxis_attribute [list.cursor_index - 1] := True
						value.wipe_out
						list.item.append_to_string (Current, value)
						if value.count > 0 then
							if line_index = 3 and then not value.is_code_identifier then
								value.enclose ('"', '"')
							end
							attribute_lines [line_index].append (Pyxis_attribute #$ [name, value])
						end
					end
				end
				across attribute_lines as line loop
					if line.item.count > 0 then
						line.item.remove_head (2)
						output.put_indented_line (tab_count, line.item)
					end
				end
			end
		end

	write_pyxis_field (output: EL_OUTPUT_MEDIUM; name: STRING; tab_count: INTEGER)
		do
			output.put_indent (tab_count)
			output.put_string_8 (name)
			output.put_character_8 (':')
			output.put_new_line
		end

	write_pyxis_manifest (output: EL_OUTPUT_MEDIUM; str: ZSTRING; tab_count: INTEGER)
		local
			lines: EL_ZSTRING_LIST
		do
			create lines.make_with_lines (str)
			lines.indent (1)
			lines.put_front (Pyxis_triple_quote)
			lines.extend (Pyxis_triple_quote)
			across lines as list loop
				output.put_indented_line (tab_count, list.item)
			end
		end

	write_pyxis_tuple (
		output: EL_OUTPUT_MEDIUM; tab_count: INTEGER; field: EL_REFLECTED_TUPLE; tuple: TUPLE
		name_list: EL_STRING_8_LIST
	)
		local
			pair, value: ZSTRING; i: INTEGER
		do
			across Reuseable.string as reuse loop
				value := reuse.item
				output.put_indent (tab_count)
				from i := 1 until i > tuple.count loop
					value.wipe_out
					value.append_tuple_item (tuple, i)
					if field.member_types.i_th_is_character_data (i) and then not value.is_code_identifier then
						value.enclose ('"', '"')
					end
					pair := Pyxis_attribute #$ [name_list [i], value]
					if i = 1 then
						pair.remove_head (2)
					end
					output.put_string (pair)
					i := i + 1
				end
				output.put_new_line
			end
		end

feature {NONE} -- Constants

	Once_attribute_lines: EL_ZSTRING_LIST
		once
			create Result.make (3)
		end

	Pyxis_attribute: ZSTRING
		once
			Result := "; %S = %S"
		end

	Pyxis_triple_quote: ZSTRING
		once
			create Result.make_filled ('"', 3)
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