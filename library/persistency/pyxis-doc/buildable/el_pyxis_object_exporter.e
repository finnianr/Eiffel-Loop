note
	description: "Exports object conforming to [$source EL_REFLECTIVE] as Pyxis document format"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-28 16:15:32 GMT (Wednesday 28th December 2022)"
	revision: "3"

class
	EL_PYXIS_OBJECT_EXPORTER [G -> EL_REFLECTIVELY_SETTABLE create make_default end]

inherit
	EL_REFLECTION_HANDLER

	EL_MODULE_BUFFER; EL_MODULE_PYXIS; EL_MODULE_REUSEABLE

create
	make

feature {NONE} -- Initialization

	make
		do
			create {G} object.make_default
		end

feature -- Element change

	set_object (a_object: G)
		do
			object := a_object
		end

feature -- Basic operations

	write_header (file: EL_PLAIN_TEXT_FILE; software_version: NATURAL)
		do
			file.put_line (Pyxis_header #$ [file.encoding_name, Pyxis.root_element_name_for_type ({G}), software_version])
		end

	write_item_to (a_object: EL_REFLECTIVE; output: EL_OUTPUT_MEDIUM; tab_count: INTEGER)
		do
			object := a_object
			output.put_indented_line (tab_count + 1, Item_element)
			write_to (output, tab_count + 2)
		end

	write_to (output: EL_OUTPUT_MEDIUM; tab_count: INTEGER)
		local
			name: STRING; value: ZSTRING; is_attribute: SPECIAL [BOOLEAN]
		do
			create is_attribute.make_filled (False, object.field_table.count)
			value := buffer.empty
			write_attributes (output, tab_count, is_attribute)

			across object.meta_data.alphabetical_list as list loop
				name := list.item.name
				if not is_attribute [list.cursor_index - 1] then
					if attached {EL_REFLECTED_COLLECTION [ANY]} list.item as collection_field then
						write_collection (output, tab_count, collection_field)

					elseif attached {EL_REFLECTED_TUPLE} list.item as tuple_field
						and then attached tuple_field.value (object) as tuple
						and then attached tuple_field.field_name_list as name_list
					then
						write_field (output, name, tab_count)
						write_tuple (output, tab_count + 1, tuple_field, tuple, name_list)

					elseif attached {EL_REFLECTED_REFERENCE [ANY]} list.item as field
						and then attached {EL_REFLECTIVE} field.value (object) as reflective
					then
						write_field (output, name, tab_count)
						if attached object as previous then
							object := reflective
							write_to (output, tab_count + 1)
							object := previous
						end
					else
						value.wipe_out
						list.item.append_to_string (object, value)
						if value.has ('%N') then
							write_field (output, name, tab_count)
							write_manifest (output, value, tab_count + 1)

						elseif value.count > 0 then
							value.enclose ('"', '"')
							write_field (output, name, tab_count)
							output.put_indented_line (tab_count + 1, value)
						end
					end
				end
			end
		end

feature {NONE} -- Implementation

	empty_attribute_lines: like Once_attribute_lines
		do
			Result := Once_attribute_lines
			across Result as line loop
				line.item.wipe_out
			end
		end

	write_attributes (output: EL_OUTPUT_MEDIUM; tab_count: INTEGER; is_attribute: SPECIAL [BOOLEAN])
		local
			attribute_lines: like Once_attribute_lines; value: ZSTRING; line_index: INTEGER
			name: STRING
		do
			value := buffer.empty; attribute_lines := empty_attribute_lines
			across Reuseable.string_pool as pool loop
				across object.meta_data.alphabetical_list as list loop
					-- output numeric as Pyxis element attributes
					name := list.item.name
					line_index := Pyxis.attribute_type (list.item)
					if line_index > 0 then
						is_attribute [list.cursor_index - 1] := True
						value := pool.borrowed_item
						list.item.append_to_string (object, value)
						if value.count > 0 then
							attribute_lines [line_index].extend (value, name)
						end
					end
				end
				write_attribute_lines (output, tab_count, attribute_lines)
			end
		end

	write_collection (output: EL_OUTPUT_MEDIUM; tab_count: INTEGER; collection_field: EL_REFLECTED_COLLECTION [ANY])
		do
			if attached {EL_REFLECTED_COLLECTION [EL_REFLECTIVE]} collection_field as reflective
				and then attached reflective.collection (object) as collection
			then
				if not collection.is_empty then
					write_field (output, collection_field.name, tab_count)
					write_recursive_list (output, tab_count, collection.linear_representation)
				end

			elseif attached collection_field.to_string_list (object) as string_list then
				if not string_list.is_empty then
					write_field (output, collection_field.name, tab_count)
					write_item_list (output, tab_count + 1, string_list)
				end
			end
		end

	write_attribute_lines (output: EL_OUTPUT_MEDIUM; tab_count: INTEGER; attribute_lines: like Once_attribute_lines)
		local
			value_table: like Once_attribute_lines.item; use_quotes: BOOLEAN
		do
			across attribute_lines as line loop
				value_table := line.item
				if value_table.count > 0 then
					output.put_indent (tab_count)
					across value_table as table loop
						if not table.is_first then
							output.put_string_8 (Semicolon_space)
						end
						output.put_string_8 (table.key)
						output.put_string_8 (Equals_sign)
						use_quotes := line.is_last and then not table.item.is_code_identifier
						if use_quotes then
							output.put_character_8 ('"')
						end
						output.put_string (table.item)
						if use_quotes then
							output.put_character_8 ('"')
						end
					end
					output.put_new_line
				end
			end
		end

	write_field (output: EL_OUTPUT_MEDIUM; name: STRING; tab_count: INTEGER)
		do
			output.put_indent (tab_count)
			output.put_string_8 (name)
			output.put_character_8 (':')
			output.put_new_line
		end

	write_item_list (output: EL_OUTPUT_MEDIUM; tab_count: INTEGER; list: LIST [READABLE_STRING_GENERAL])
		do
			output.put_indented_line (tab_count, Item_element)
			from list.start until list.after loop
				output.put_indent (tab_count + 1)
				output.put_character_8 ('"')
				output.put_string_general (list.item)
				output.put_character_8 ('"')
				output.put_new_line
				list.forth
			end
		end

	write_manifest (output: EL_OUTPUT_MEDIUM; str: ZSTRING; tab_count: INTEGER)
		do
			output.put_indented_line (tab_count, Pyxis_triple_quote)
			across str.split ('%N') as line loop
				output.put_indented_line (tab_count + 1, line.item)
			end
			output.put_indented_line (tab_count, Pyxis_triple_quote)
		end

	write_recursive_list (output: EL_OUTPUT_MEDIUM; tab_count: INTEGER; list: LINEAR [EL_REFLECTIVE])
		do
			if attached object as l_object then
				from list.start until list.after loop
					write_item_to (list.item, output, tab_count)
					list.forth
				end
				object := l_object
			end
		end

	write_tuple (
		output: EL_OUTPUT_MEDIUM; tab_count: INTEGER; field: EL_REFLECTED_TUPLE; tuple: TUPLE
		name_list: EL_STRING_8_LIST
	)
		local
			value: ZSTRING; i: INTEGER
			attribute_lines: like Once_attribute_lines
		do
			attribute_lines := empty_attribute_lines
			across Reuseable.string_pool as pool loop
				from i := 1 until i > tuple.count loop
					value := pool.borrowed_item
					value.append_tuple_item (tuple, i)
					if field.member_types.i_th_is_character_data (i) then
						attribute_lines.last.extend (value, name_list [i])
					else
						attribute_lines.first.extend (value, name_list [i])
					end
					i := i + 1
				end
				write_attribute_lines (output, tab_count, attribute_lines)
			end
		end

feature {NONE} -- Internal attributes

	object: EL_REFLECTIVE

feature {NONE} -- Constants

	Equals_sign: STRING = " = "

	Item_element: STRING = "item:"

	Semicolon_space: STRING = "; "

	Once_attribute_lines: ARRAYED_LIST [HASH_TABLE [ZSTRING, STRING]]
		once
			create Result.make (Pyxis.Type_represented)
			from until Result.full loop
				Result.extend (create {HASH_TABLE [ZSTRING, STRING]}.make (5))
			end
		ensure
			expected_size: Result.count = 3
		end

	Pyxis_header: ZSTRING
		once
			Result := "[
				pyxis-doc:
					version = 1.0; encoding = "#"
				
				#:
					software_version = #
			]"
		end

	Pyxis_triple_quote: ZSTRING
		once
			create Result.make_filled ('"', 3)
		end
end