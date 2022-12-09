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
	date: "2022-12-09 15:16:26 GMT (Friday 9th December 2022)"
	revision: "60"

deferred class
	EL_REFLECTIVELY_SETTABLE_STORABLE

inherit
	EL_STORABLE
		undefine
			is_equal
		end

	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_storable_field
		export
			{EL_MEMORY_READER_WRITER} make_default, generating_type
		redefine
			is_equal, new_meta_data, use_default_values
		end

	EL_CSV_CONVERTABLE

	EL_MODULE_BUFFER; EL_MODULE_EXECUTABLE; EL_MODULE_LIO; EL_MODULE_REUSEABLE

	EL_SHARED_CLASS_ID; EL_SHARED_FACTORIES

feature -- Basic operations

	write (a_writer: EL_MEMORY_READER_WRITER)
		local
			i, l_count: INTEGER_32
		do
			if attached meta_data.field_list as list then
				l_count := list.count
				from i := 1 until i > l_count loop
					write_field (list [i], a_writer)
					i := i + 1
				end
			end
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
				if attached {EL_STRING_FIELD_REPRESENTATION [ANY, ANY]} list.item.representation as representation then
					representation.append_comment (field_definition)
					if attached {EL_ENUMERATION [NUMERIC]} representation.item as enumeration then
						enumeration_list.extend (enumeration)
					end
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

feature {EL_STORABLE_CLASS_META_DATA} -- Access

	field_hash: NATURAL
		-- CRC checksum for field names and types of generating type
		deferred
		end

feature {NONE} -- Implementation

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
		local
			item_type_id: INTEGER
		do
			if Eiffel.is_storable_type (basic_type, type_id) then
				Result := True

			elseif Eiffel.type_conforms_to (type_id, Class_id.ARRAYED_LIST_ANY) then
				if Arrayed_list_factory.is_valid_type (type_id)
					and then attached {ARRAYED_LIST [ANY]} Arrayed_list_factory.new_item_from_type_id (type_id) as list
				then
					item_type_id := list.area.generating_type.generic_parameter_type (1).type_id
					Result := Eiffel.is_storable_type (basic_type, item_type_id)
				end
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

	write_pyxis_tuple (output: EL_OUTPUT_MEDIUM; tab_count: INTEGER; tuple: TUPLE; tuple_types: EL_TUPLE_TYPE_ARRAY)
		local
			pair, value: ZSTRING; name: STRING; i: INTEGER
		do
			across Reuseable.string as reuse loop
				value := reuse.item
				across Reuseable.string_8 as reuse_8 loop
					name := reuse_8.copied_item (once "i_")
					output.put_indent (tab_count)
					from i := 1 until i > tuple.count loop
						name.keep_head (2); name.append_integer (i)
						value.wipe_out
						value.append_tuple_item (tuple, i)
						if tuple_types.i_th_is_character_data (i) and then not value.is_code_identifier then
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
				end
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