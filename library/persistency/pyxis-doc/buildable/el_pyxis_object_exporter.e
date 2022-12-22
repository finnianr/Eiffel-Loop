note
	description: "Exports object conforming to [$source EL_REFLECTIVE] as Pyxis document format"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-22 10:38:18 GMT (Thursday 22nd December 2022)"
	revision: "1"

class
	EL_PYXIS_OBJECT_EXPORTER

inherit
	EL_REFLECTION_HANDLER

	EL_MODULE_BUFFER; EL_MODULE_REUSEABLE

create
	make

feature {NONE} -- Initialization

	make (a_object: EL_REFLECTIVE)
		do
			object := a_object
		end

feature -- Element change

	set_object (a_object: EL_REFLECTIVE)
		do
			object := a_object
		end

feature -- Basic operations

	write_header (file: EL_PLAIN_TEXT_FILE; software_version: NATURAL)
		do
			file.put_line (Pyxis_header #$ [file.encoding_name, file.path.base_sans_extension, software_version])
		end

	write_item_to (a_object: EL_REFLECTIVE; output: EL_OUTPUT_MEDIUM; tab_count: INTEGER)
		do
			object := a_object
			output.put_indented_line (tab_count + 1, once "item:")
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
					if attached {EL_REFLECTED_STORABLE} list.item as storable_field
						and then attached {EL_REFLECTIVELY_SETTABLE_STORABLE} storable_field.value (object) as storable
					then
						write_field (output, name, tab_count)
						if attached object as l_object then
							object := storable
							write_to (output, tab_count + 1)
							object := l_object
						end
					elseif attached {EL_REFLECTED_COLLECTION [EL_REFLECTIVE]} list.item as collection_field
						and then attached collection_field.collection (object) as collection
					then
						write_field (output, name, tab_count)
						write_list (output, tab_count, collection.linear_representation)

					elseif attached {EL_REFLECTED_TUPLE} list.item as tuple_field
						and then attached tuple_field.value (object) as tuple
						and then attached tuple_field.field_name_list as name_list
					then
						write_field (output, name, tab_count)
						write_tuple (output, tab_count + 1, tuple_field, tuple, name_list)
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

	write_attributes (output: EL_OUTPUT_MEDIUM; tab_count: INTEGER; is_attribute: SPECIAL [BOOLEAN])
		local
			attribute_lines: EL_ZSTRING_LIST; value: ZSTRING; line_index: INTEGER
			name: STRING
		do
			value := buffer.empty; attribute_lines := Once_attribute_lines
			across Reuseable.string_pool as pool loop
				from attribute_lines.wipe_out until attribute_lines.full loop
					attribute_lines.extend (pool.borrowed_item)
				end
				across object.meta_data.alphabetical_list as list loop
					-- output numeric as Pyxis element attributes
					name := list.item.name
					line_index := attribute_line_index (list.item)
					if line_index > 0 then
						is_attribute [list.cursor_index - 1] := True
						value.wipe_out
						list.item.append_to_string (object, value)
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

	write_list (output: EL_OUTPUT_MEDIUM; tab_count: INTEGER; list: LINEAR [EL_REFLECTIVE])
		do
			if attached object as l_object then
				from list.start until list.after loop
					write_item_to (list.item, output, tab_count)
					list.forth
				end
				object := l_object
			end
		end

	write_field (output: EL_OUTPUT_MEDIUM; name: STRING; tab_count: INTEGER)
		do
			output.put_indent (tab_count)
			output.put_string_8 (name)
			output.put_character_8 (':')
			output.put_new_line
		end

	write_manifest (output: EL_OUTPUT_MEDIUM; str: ZSTRING; tab_count: INTEGER)
		do
			output.put_indented_line (tab_count, Pyxis_triple_quote)
			across str.split ('%N') as line loop
				output.put_indented_line (tab_count + 1, line.item)
			end
			output.put_indented_line (tab_count, Pyxis_triple_quote)
		end

	write_tuple (
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

feature {NONE} -- Internal attributes

	object: EL_REFLECTIVE

feature {NONE} -- Constants

	Once_attribute_lines: EL_ZSTRING_LIST
		once
			create Result.make (3)
		end

	Pyxis_attribute: ZSTRING
		once
			Result := "; %S = %S"
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