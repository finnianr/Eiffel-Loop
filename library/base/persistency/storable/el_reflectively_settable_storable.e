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
	date: "2020-12-01 15:40:20 GMT (Tuesday 1st December 2020)"
	revision: "24"

deferred class
	EL_REFLECTIVELY_SETTABLE_STORABLE

inherit
	EL_STORABLE
		undefine
			is_equal, print_meta_data
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

	EL_MODULE_LIO

	EL_MODULE_EXECUTABLE

	EL_MODULE_STRING_8

	EL_SHARED_ONCE_ZSTRING

	EL_ZSTRING_CONSTANTS

feature -- Basic operations

	write (a_writer: EL_MEMORY_READER_WRITER)
		local
			field_array: EL_REFLECTED_FIELD_LIST
			i, field_count: INTEGER_32
		do
			field_array := Meta_data_by_type.item (Current).field_list
			field_count := field_array.count
			from i := 1 until i > field_count loop
				write_field (field_array [i], a_writer)
				i := i + 1
			end
		end

	write_as_pyxis (output: EL_OUTPUT_MEDIUM; tab_count: INTEGER)
		local
			value: ZSTRING; cursor_index_set: ARRAYED_LIST [INTEGER]
		do
			create cursor_index_set.make (10)
			value := empty_once_string
			write_pyxis_attributes (output, tab_count, cursor_index_set)

			across field_table as table loop
				if not cursor_index_set.has (table.cursor_index) then
					if attached {EL_REFLECTIVELY_SETTABLE_STORABLE} table.item as storable then
						write_pyxis_field (output, table.key, tab_count)
						storable.write_as_pyxis (output, tab_count + 1)
					elseif attached {EL_REFLECTED_TUPLE} table.item as tuple then
						write_pyxis_field (output, table.key, tab_count)
						write_pyxis_tuple (output, tab_count + 1, tuple.value (Current))

					else
						value.wipe_out
						value.append_string_general (table.item.to_string (Current))
						if value.has ('%N') then
							write_pyxis_field (output, table.key, tab_count)
							write_pyxis_manifest (output, value, tab_count + 1)

						elseif value.count > 0 then
							value.enclose ('"', '"')
							write_pyxis_field (output, table.key, tab_count)
							output.put_indent (tab_count + 1)
							output.put_string (value)
							output.put_new_line
						end
					end
				end
			end
		end

feature -- Element change

	read_default (a_reader: EL_MEMORY_READER_WRITER)
			-- Read default (current) version of data
		local
			field_array: EL_REFLECTED_FIELD_LIST
			i, field_count: INTEGER_32
		do
			field_array := Meta_data_by_type.item (Current).field_list
			field_count := field_array.count
			from i := 1 until i > field_count loop
				read_field (field_array [i], a_reader)
				i := i + 1
			end
		end

feature -- Status query

	ordered_alphabetically: BOOLEAN
		-- when `True' read/write fields in alphabetical order of field name
		do
		end

feature {EL_STORABLE_CLASS_META_DATA} -- Implementation

	adjust_field_order (fields: EL_REFLECTED_FIELD_LIST)
		do
			if ordered_alphabetically then
				fields.order_by (agent {EL_REFLECTED_FIELD}.name, True)
			end
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

	write_pyxis_attributes (output: EL_OUTPUT_MEDIUM; tab_count: INTEGER; cursor_index_set: LIST [INTEGER])
		local
			attribute_lines: ARRAY [ZSTRING]; value: ZSTRING; attribute_index: INTEGER
		do
			value := empty_once_string
			attribute_lines := << String_pool.reuseable_item, String_pool.reuseable_item, String_pool.reuseable_item >>
			across field_table as table loop
				-- output numeric as Pyxis element attributes
				if attached {EL_REFLECTED_NUMERIC_FIELD [NUMERIC]} table.item as numeric then
					if numeric.is_enumeration then
						attribute_index := 3
					else
						attribute_index := 1
					end
				elseif attached {EL_REFLECTED_BOOLEAN} table.item then
					attribute_index := 2
				end
				if attribute_index > 0 then
					cursor_index_set.extend (table.cursor_index)
					value.wipe_out
					value.append_string_general (table.item.to_string (Current))
					if value.count > 0 then
						if attribute_index = 3 and then not value.is_code_identifier then
							value.enclose ('"', '"')
						end
						attribute_lines.item (attribute_index).append (Pyxis_attribute #$ [table.key, value])
					end
				end
			end
			across attribute_lines as line loop
				if line.item.count > 0 then
					line.item.remove_head (2)
					output.put_indent (tab_count)
					output.put_string (line.item)
					output.put_new_line
				end
			end
			attribute_lines.do_all (agent String_pool.recycle)
		end

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
				print_field_meta_data (lio, Result.field_list.to_array)
				lio.put_new_line
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
			if attached {EL_REFLECTED_READABLE [ANY]} field as readable then
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
				output.put_indent (tab_count); output.put_string (list.item)
				output.put_new_line
			end
		end

	write_pyxis_tuple (output: EL_OUTPUT_MEDIUM; tab_count: INTEGER; tuple: TUPLE)
		local
			name: STRING; value, pair: ZSTRING; i: INTEGER
		do
			value := String_pool.reuseable_item
			output.put_indent (tab_count)
			from i := 1 until i > tuple.count loop
				create name.make_from_string (once "item_")
				name.append_integer (i)
				value.wipe_out
				if attached {NUMERIC} tuple.item (i) as numeric then
					value.append_string_general (numeric.out)

				elseif attached {READABLE_STRING_GENERAL} tuple.item (i) as general then
					value.append_string_general (general)
					if not value.is_code_identifier then
						value.enclose ('"', '"')
					end
				end
				pair := Pyxis_attribute #$ [name, value]
				if i = 1 then
					pair.remove_head (2)
				end
				output.put_string (pair)
				i := i + 1
			end
			output.put_new_line
			String_pool.recycle (value)
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
