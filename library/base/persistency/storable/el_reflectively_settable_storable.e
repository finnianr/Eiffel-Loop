note
	description: "[
		Object that can read and write itself to a memory buffer of type [$source EL_MEMORY_READER_WRITER].
		Field reading, writing and object comparison is handled using class reflection.
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-03 16:14:53 GMT (Monday 3rd May 2021)"
	revision: "33"

deferred class
	EL_REFLECTIVELY_SETTABLE_STORABLE

inherit
	EL_STORABLE
		undefine
			is_equal
		end

	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_storable_field,
			export_name as export_default,
			import_name as import_default
		export
			{EL_MEMORY_READER_WRITER} make_default, generating_type
		redefine
			is_equal, new_meta_data, use_default_values, Except_fields
		end

	EL_REFLECTION_HANDLER undefine is_equal end

	EL_MODULE_LIO

	EL_MODULE_EXECUTABLE

	EL_MODULE_BUFFER

	EL_MODULE_TUPLE

	EL_ZSTRING_CONSTANTS

	EL_STRING_8_CONSTANTS

	EL_SHARED_CLASS_ID

feature -- Basic operations

	write (a_writer: EL_MEMORY_READER_WRITER)
		local
			field_array: EL_REFLECTED_FIELD_LIST;i, l_count: INTEGER_32
		do
			field_array := Meta_data_by_type.item (Current).field_list
			l_count := field_array.count
			from i := 1 until i > l_count loop
				write_field (field_array [i], a_writer)
				i := i + 1
			end
		end

	write_as_pyxis (output: EL_OUTPUT_MEDIUM; tab_count: INTEGER)
		local
			value: ZSTRING; cursor_index_set: ARRAYED_LIST [INTEGER]
			name: STRING
		do
			create cursor_index_set.make (10)
			value := buffer.empty
			write_pyxis_attributes (output, tab_count, cursor_index_set)

			across meta_data.alphabetical_list as list loop
				name := list.item.name
				if not cursor_index_set.has (list.cursor_index) then
					if attached {EL_REFLECTED_STORABLE} list.item as storable_field
						and then attached {EL_REFLECTIVELY_SETTABLE_STORABLE} storable_field.value (Current) as storable
					then
						write_pyxis_field (output, name, tab_count)
						storable.write_as_pyxis (output, tab_count + 1)
					elseif attached {EL_REFLECTED_TUPLE} list.item as tuple_field
						and then attached {TUPLE} tuple_field.value (Current) as l_tuple
					then
						write_pyxis_field (output, name, tab_count)
						write_pyxis_tuple (output, tab_count + 1, l_tuple, tuple_field.member_types)
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
		do
			create enumeration_list.make (5)
			output.put_indented_line (tab_count, "class " + generator)
			across meta_data.field_list as list loop
				-- Number
				output.put_indented_line (tab_count, "-- " + list.cursor_index.out)

				field_definition := list.item.name + ": " + list.item.class_name
				if attached {EL_REFLECTED_ENUMERATION [NUMERIC]} list.item as numeric then
					enumeration_list.extend (numeric.enumeration)
					field_definition.append (" -- Enumeration: " + numeric.enumeration.generator)
				end
				output.put_indented_line (tab_count + 1, field_definition)
				if attached {EL_REFLECTIVELY_SETTABLE_STORABLE} list.item.value (Current) as storable then
					storable.write_meta_data (output, tab_count + 1)
				end
			end
			output.put_new_line
			output.put_indented_line (tab_count, "-- CRC checksum ")
			output.put_indented_line (tab_count + 1, "Field_hash: NATURAL = " + field_hash.out)

			output.put_indented_line (tab_count, "end")

			across enumeration_list as enum loop
				output.put_new_line
				output.put_indented_line (tab_count, "class " + enum.item.generator)
				across enum.item.field_table as table loop
					output.put_indented_line (tab_count + 1, table.item.name + " = " + table.item.value (enum.item).out)
				end
				output.put_indented_line (tab_count, "end")
			end
		end

feature -- Element change

	read_default (a_reader: EL_MEMORY_READER_WRITER)
			-- Read default (current) version of data
		local
			field_array: EL_REFLECTED_FIELD_LIST
			i, l_count: INTEGER_32
		do
			field_array := Meta_data_by_type.item (Current).field_list
			l_count := field_array.count
			from i := 1 until i > l_count loop
				read_field (field_array [i], a_reader)
				i := i + 1
			end
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			-- Comparison
		do
			Result := all_fields_equal (other)
		end

feature {EL_STORABLE_CLASS_META_DATA} -- Access

	field_hash: NATURAL
		-- CRC checksum for field names and types of generating type
		deferred
		end

feature {NONE} -- Implementation

	is_storable_field (basic_type, type_id: INTEGER_32): BOOLEAN
		do
			Result := Eiffel.is_storable_type (basic_type, type_id)
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

	write_field (field: EL_REFLECTED_FIELD; a_writer: EL_MEMORY_READER_WRITER)
			-- Write operations
		do
			if attached {EL_REFLECTED_STORABLE} field as storable_field then
				storable_field.write (Current, a_writer)
			else
				field.write_to_memory (Current, a_writer)
			end
		end

	write_pyxis_attributes (output: EL_OUTPUT_MEDIUM; tab_count: INTEGER; cursor_index_set: LIST [INTEGER])
		local
			attribute_lines: ARRAY [ZSTRING]; value: ZSTRING; attribute_index: INTEGER
		do
			value := buffer.empty
			attribute_lines := << String_pool.reuseable_item, String_pool.reuseable_item, String_pool.reuseable_item >>
			across meta_data.alphabetical_list as list loop
				-- output numeric as Pyxis element attributes
				if attached {EL_REFLECTED_ENUMERATION [NUMERIC]} list.item then
					attribute_index := 3
				elseif attached {EL_REFLECTED_NUMERIC_FIELD [NUMERIC]} list.item then
					attribute_index := 1
				elseif attached {EL_REFLECTED_BOOLEAN} list.item then
					attribute_index := 2
				else
					attribute_index := 0
				end
				if attribute_index > 0 then
					cursor_index_set.extend (list.cursor_index)
					value.wipe_out
					list.item.append_to_string (Current, value)
					if value.count > 0 then
						if attribute_index = 3 and then not value.is_code_identifier then
							value.enclose ('"', '"')
						end
						attribute_lines.item (attribute_index).append (Pyxis_attribute #$ [list.item.name, value])
					end
				end
			end
			across attribute_lines as line loop
				if line.item.count > 0 then
					line.item.remove_head (2)
					output.put_indented_line (tab_count, line.item)
				end
			end
			attribute_lines.do_all (agent String_pool.recycle)
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

	write_pyxis_tuple (output: EL_OUTPUT_MEDIUM; tab_count: INTEGER; a_tuple: TUPLE; tuple_types: EL_TUPLE_TYPE_ARRAY)
		local
			pair: ZSTRING; i: INTEGER
		do
			if attached String_pool.reuseable_item as value and attached String_8_pool.reuseable_item as name then
				name.append (once "i_")
				output.put_indent (tab_count)
				from i := 1 until i > a_tuple.count loop
					name.keep_head (2); name.append_integer (i)
					value.wipe_out
					Tuple.append_i_th (a_tuple, i, value)
					if Class_id.Character_data_types.has (tuple_types [i].type_id)
						and then not value.is_code_identifier
					then
						value.enclose ('"', '"')
					end
					pair := Pyxis_attribute #$ [name, value]
					if i = 1 then
						pair.remove_head (2)
					end
					output.put_string (pair)
					i := i + 1
				end
				output.put_new_line
				String_pool.recycle (value); String_8_pool.recycle (name)
			end
		end

feature {NONE} -- Constants

	Except_fields: STRING_8
			-- list of comma-separated fields to be excluded
		once
			Result := Precursor + ", is_deleted"
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

		**3.** TUPLE with type members that are either basic types or string references

		Override the once string Except_fields to list any fields which should not be stored.

			Except_fields: STRING
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