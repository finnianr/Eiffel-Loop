note
	description: "Exports object conforming to [$source EL_REFLECTIVELY_SETTABLE] as Pyxis document format"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-16 15:07:10 GMT (Thursday 16th November 2023)"
	revision: "9"

class
	EL_PYXIS_OBJECT_EXPORTER [G -> EL_REFLECTIVELY_SETTABLE create make_default end]

inherit
	ANY

	EL_REFLECTION_HANDLER

	EL_MODULE_PYXIS

	EL_SHARED_ZSTRING_BUFFER_SCOPES

create
	make, make_default

feature {NONE} -- Initialization

	make (a_object: G)
		do
			object := a_object
		end

	make_default
		do
			create {G} object.make_default
		end

feature -- Element change

	set_object (a_object: G)
		do
			object := a_object
		end

feature -- Basic operations

	put_header (output: EL_OUTPUT_MEDIUM; software_version: NATURAL)
		do
			output.put_line (
				Pyxis_header #$ [output.encoding_name, Pyxis.root_element_name_for_type ({G}), software_version]
			)
		end

	put_item (a_object: EL_REFLECTIVE; output: EL_OUTPUT_MEDIUM; tab_count: INTEGER)
		do
			object := a_object
			output.put_indented_line (tab_count + 1, Item_element)
			put (output, tab_count + 2)
		end

	put (output: EL_OUTPUT_MEDIUM; tab_count: INTEGER)
		local
			name: STRING; is_attribute: SPECIAL [BOOLEAN]
		do
			create is_attribute.make_filled (False, object.field_table.count)

			put_attributes (output, tab_count, is_attribute)

			across object.meta_data.alphabetical_list as list loop
				name := list.item.name
				if not is_attribute [list.cursor_index - 1] then
					if attached {EL_REFLECTED_COLLECTION [ANY]} list.item as collection_field then
						put_collection (output, tab_count, collection_field)

					elseif attached {EL_REFLECTED_TUPLE} list.item as tuple_field
						and then attached tuple_field.value (object) as tuple
						and then attached tuple_field.field_name_list as name_list
					then
						put_field (output, name, tab_count)
						put_tuple (output, tab_count + 1, tuple_field, tuple, name_list)

					elseif attached {EL_REFLECTED_REFERENCE [ANY]} list.item as field
						and then attached {EL_REFLECTIVE} field.value (object) as reflective
					then
						put_field (output, name, tab_count)
						if attached object as previous then
							object := reflective
							put (output, tab_count + 1)
							object := previous
						end
					else
						across String_scope as scope loop
							if attached scope.item as value then
								list.item.append_to_string (object, value)
								if value.has ('%N') then
									put_field (output, name, tab_count)
									put_manifest (output, value, tab_count + 1)

								elseif value.count > 0 then
									value.enclose ('"', '"')
									put_field (output, name, tab_count)
									output.put_indented_line (tab_count + 1, value)
								end
							end
						end
					end
				end
			end
		end

feature {NONE} -- Implementation

	put_attributes (output: EL_OUTPUT_MEDIUM; tab_count: INTEGER; is_attribute: SPECIAL [BOOLEAN])
		local
			value: ZSTRING; name: STRING; line_index: INTEGER
			type: EL_ATTRIBUTE_TYPE_ROUTINES
		do
			if attached Once_attribute_lines as attribute_lines then
				across String_pool_scope as pool loop
					value := pool.borrowed_item
					across object.meta_data.alphabetical_list as list loop
						-- output numeric as Pyxis element attributes
						name := list.item.name
						line_index := type.attribute_id (object, list.item)
						if line_index > 0 then
							is_attribute [list.cursor_index - 1] := True
							value := pool.borrowed_item
							list.item.append_to_string (object, value)
							if value.count > 0 then
								attribute_lines.extend (line_index, name, value)
							end
						end
					end
					attribute_lines.put (output, tab_count)
				end
			end
		end

	put_collection (output: EL_OUTPUT_MEDIUM; tab_count: INTEGER; collection_field: EL_REFLECTED_COLLECTION [ANY])
		do
			if attached {EL_REFLECTED_COLLECTION [EL_REFLECTIVE]} collection_field as reflective
				and then attached reflective.collection (object) as collection
			then
				if not collection.is_empty then
					put_field (output, collection_field.name, tab_count)
					put_recursive_list (output, tab_count, collection.linear_representation)
				end

			elseif attached collection_field.to_string_list (object) as string_list then
				if not string_list.is_empty then
					put_field (output, collection_field.name, tab_count)
					put_item_list (output, tab_count + 1, string_list)
				end
			end
		end

	put_field (output: EL_OUTPUT_MEDIUM; name: STRING; tab_count: INTEGER)
		do
			output.put_indent (tab_count)
			output.put_string_8 (name)
			output.put_character_8 (':')
			output.put_new_line
		end

	put_item_list (output: EL_OUTPUT_MEDIUM; tab_count: INTEGER; list: LIST [READABLE_STRING_GENERAL])
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

	put_manifest (output: EL_OUTPUT_MEDIUM; str: ZSTRING; tab_count: INTEGER)
		do
			output.put_indented_line (tab_count, Pyxis_triple_quote)
			across str.split ('%N') as line loop
				output.put_indented_line (tab_count + 1, line.item)
			end
			output.put_indented_line (tab_count, Pyxis_triple_quote)
		end

	put_recursive_list (output: EL_OUTPUT_MEDIUM; tab_count: INTEGER; list: LINEAR [EL_REFLECTIVE])
		do
			if attached object as l_object then
				from list.start until list.after loop
					put_item (list.item, output, tab_count)
					list.forth
				end
				object := l_object
			end
		end

	put_tuple (
		output: EL_OUTPUT_MEDIUM; tab_count: INTEGER; field: EL_REFLECTED_TUPLE; tuple: TUPLE
		name_list: EL_STRING_8_LIST
	)
		local
			value: ZSTRING; i: INTEGER
		do
			if attached Once_attribute_lines as attribute_lines then
				across String_pool_scope as pool loop
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
					attribute_lines.put (output, tab_count)
				end
			end
		end

feature {NONE} -- Internal attributes

	object: EL_REFLECTIVE

feature {NONE} -- Constants

	Item_element: STRING = "item:"

	Once_attribute_lines: EL_PYXIS_ATTRIBUTES
		once
			create Result.make
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