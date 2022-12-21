note
	description: "[
		A helper class for implementing the function `building_action_table' from class
		[$source EL_EIF_OBJ_BUILDER_CONTEXT] by using Eiffel reflection to map xpath's
		 derived from object field names to a setter agent.
		
		The implementing class must also inherit class [$source EL_REFLECTIVE] either directly
		or from one of it's descendants.
	]"
	descendants: "[
			EL_SETTABLE_FROM_XML_NODE*
				[$source RBOX_IGNORED_ENTRY]
					[$source RBOX_SONG]
				[$source EL_BOOK_INFO]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-21 21:28:48 GMT (Wednesday 21st December 2022)"
	revision: "42"

deferred class
	EL_SETTABLE_FROM_XML_NODE

inherit
	EL_REFLECTIVE_I

	REFLECTOR_CONSTANTS
		export
			{NONE} all
		end

	EL_MODULE_CONVERT_STRING; EL_MODULE_EIFFEL; EL_MODULE_REUSEABLE; EL_MODULE_TUPLE

	EL_EIF_OBJ_BUILDER_CONTEXT_TYPE_CONSTANTS

	XML_ZSTRING_CONSTANTS

	EL_SHARED_CLASS_ID

feature {EL_SETTABLE_FROM_XML_NODE} -- Basic operations

	put_xml_element (xml_out: EL_OUTPUT_MEDIUM; name: STRING; tab_count: INTEGER)
		-- recursively output elements to file as XML
		local
			has_child_element: BOOLEAN; table: like field_table
			attribute_count: INTEGER; l_name: STRING; value: ZSTRING
		do
			table := field_table
			across Reuseable.string as reuse loop
				value := reuse.item
				xml_out.put_indent (tab_count); xml_out.put_character_8 ('<')
				xml_out.put_string_8 (name)
				across table as field loop
					l_name := field.item.name
					if attached {EL_REFLECTED_REFERENCE [EL_EIF_OBJ_BUILDER_CONTEXT]} field.item
						or else attached {EL_REFLECTED_COLLECTION [ANY]} field.item
						or else attached {EL_REFLECTED_COLLECTION [EL_EIF_OBJ_BUILDER_CONTEXT]} field.item
					then
						has_child_element := True
					else
						value.wipe_out
						field.item.write (current_reflective, value)
						if not value.is_empty then
							if attribute_count = 0 then
								xml_out.put_new_line
							end
							xml_out.put_indent (tab_count + 1); xml_out.put_string_8 (field.item.name)
							xml_out.put_string_8 (once " = %"")
							put_value (xml_out, value, attached {EL_REFLECTED_STRING [STRING_GENERAL]} field.item)
							xml_out.put_character_8 ('"')
							xml_out.put_new_line
							attribute_count := attribute_count + 1
						end
					end
				end
				if has_child_element then
					xml_out.put_character_8 ('>')
					xml_out.put_new_line
					put_child_elements (xml_out, table, value, tab_count)
					put_xml_tag_close (xml_out, name, tab_count, New_line)
				else
					xml_out.put_indent (tab_count)
					xml_out.put_string_8 (once "/>%N")
				end
			end
		end

	put_child_elements (xml_out: EL_OUTPUT_MEDIUM; table: like field_table; value: ZSTRING; tab_count: INTEGER)
		local
			needs_escaping: BOOLEAN
		do
			across table as field loop
				if attached {EL_REFLECTED_REFERENCE [EL_EIF_OBJ_BUILDER_CONTEXT]} field.item as context_field then
					if attached {EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT} context_field.value (current_reflective) as context
					then
						context.put_xml_element (xml_out, field.item.name, tab_count + 1)
					end
				elseif attached {EL_REFLECTED_COLLECTION [EL_EIF_OBJ_BUILDER_CONTEXT]} field.item as collection_field then
					if attached {COLLECTION [EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT]}
						collection_field.collection (current_reflective) as collection
					then
						put_xml_tag_open (xml_out, collection_field.name, tab_count + 1, New_line)
						if attached collection.linear_representation as list then
							from list.start until list.after loop
								list.item.put_xml_element (xml_out, Item.name, tab_count + 2)
								list.forth
							end
						end
						put_xml_tag_close (xml_out, collection_field.name, tab_count + 1, New_line)
					end
				elseif attached {EL_REFLECTED_COLLECTION [ANY]} field.item as collection_field then
					needs_escaping := collection_field.has_character_data
					put_xml_tag_open (xml_out, collection_field.name, tab_count + 1, New_line)
					across collection_field.to_string_list (current_reflective) as general loop
						put_xml_tag_open (xml_out, Item.name, tab_count + 2, Null)
						value.wipe_out
						value.append_string_general (general.item)
						put_value (xml_out, value, needs_escaping)
						put_xml_tag_close (xml_out, Item.name, 0, New_line)
					end
					put_xml_tag_close (xml_out, collection_field.name, tab_count + 1, New_line)

				end
			end
		end

	put_value (xml_out: EL_OUTPUT_MEDIUM; value: ZSTRING; escape: BOOLEAN)
		do
			if escape then
				xml_out.put_string_general (Xml_escaper.escaped (value, False))
			else
				xml_out.put_string_general (value)
			end
		end

	put_xml_tag_open (xml_out: EL_OUTPUT_MEDIUM; name: STRING; tab_count: INTEGER; character: CHARACTER)
		do
			put_xml_tag (xml_out, name, tab_count, False, character)
		end

	put_xml_tag_close (xml_out: EL_OUTPUT_MEDIUM; name: STRING; tab_count: INTEGER; character: CHARACTER)
		do
			put_xml_tag (xml_out, name, tab_count, True, character)
		end

	put_xml_tag (xml_out: EL_OUTPUT_MEDIUM; name: STRING; tab_count: INTEGER; closed: BOOLEAN; character: CHARACTER)
		do
			xml_out.put_indent (tab_count)
			xml_out.put_character_8 ('<')
			if closed then
				xml_out.put_character_8 ('/')
			end
			xml_out.put_string_8 (name)
			xml_out.put_character_8 ('>')
			if character = New_line then
				xml_out.put_new_line
			end
		end

feature {NONE} -- Implementation

	building_actions_for_each_type (types: ARRAY [TYPE [ANY]]; element_set: EL_FIELD_INDICES_SET): EL_PROCEDURE_TABLE [STRING]
		local
			i: INTEGER_32; table: EL_PROCEDURE_TABLE [STRING]
		do
			from i := 1 until i > types.count loop
				table := building_actions_for_type (types [i], element_set)
				if i = 1 then
					Result := table
				else
					Result.merge (table)
				end
				i := i + 1
			end
		end

	building_actions_for_type (type: TYPE [ANY]; element_set: EL_FIELD_INDICES_SET): EL_PROCEDURE_TABLE [STRING]
		-- table of build actions for fields matching `type' indexed by a relative xpath
		-- by default xpaths select an element attribute except for field in `element_set' which
		-- select the text within an element.
		local
			table: EL_REFLECTED_FIELD_TABLE; field_list: LIST [EL_REFLECTED_FIELD]; xpath: STRING_8
			node_type: INTEGER; field: EL_REFLECTED_FIELD
		do
			table := field_table
			table.query_by_type (type)
			field_list := table.last_query
			create Result.make_equal (field_list.count)
			across field_list as list loop
				field := list.item
				if element_set.has (field.index) then
					node_type := Text_element_node
				else
					node_type := Attribute_node
				end
				if attached {EL_REFLECTED_COLLECTION [EL_EIF_OBJ_BUILDER_CONTEXT]} field as builder_context_list then
					xpath := new_xpath (field, Element_node) + Item.xpath
					Result [xpath] := agent extend_context_collection (builder_context_list)

				elseif attached {EL_REFLECTED_COLLECTION [ANY]} field as collection_field then
					xpath := new_xpath (field, Element_node) + Item.text_xpath
					Result [xpath] := agent extend_collection (collection_field)

				elseif attached {EL_REFLECTED_REFERENCE [EL_EIF_OBJ_BUILDER_CONTEXT]} field as context_field then
					Result [new_xpath (field, Element_node)] := agent change_context (context_field)

				elseif attached {EL_REFLECTED_PATH} field as path_field then
					Result [new_xpath (field, node_type)] := agent set_path_field_from_node (path_field)

				elseif attached {EL_REFLECTED_STRING [READABLE_STRING_GENERAL]} field as string_field
					and then string_field.is_value_cached
				then
					-- Field value caching
					xpath := new_xpath (string_field, node_type)
					Result [xpath] := agent set_cached_field_from_node (string_field)
				else
					Result [new_xpath (field, node_type)] := agent set_field_from_node (field)
				end
			end
		end

	new_xpath (field: EL_REFLECTED_FIELD; node_type: INTEGER): STRING
		local
			s: EL_STRING_8_ROUTINES
		do
			inspect node_type
				when Attribute_node then
					Result := s.character_string ('@') + field.export_name
				when Text_element_node then
					Result := field.export_name + once "/text()"
			else
				Result := field.export_name
			end
		end

	change_context (context_field: EL_REFLECTED_REFERENCE [EL_EIF_OBJ_BUILDER_CONTEXT])
		do
			if attached {EL_EIF_OBJ_XPATH_CONTEXT} context_field.value (current_reflective) as context then
				set_next_context (context)
			end
		end

	extend_collection (field_collection: EL_REFLECTED_COLLECTION [ANY])
		do
			field_collection.extend_from_readable (current_reflective, node)
		end

	extend_context_collection (builder_context_list: EL_REFLECTED_COLLECTION [EL_EIF_OBJ_BUILDER_CONTEXT])
		require
			extendible_collection: builder_context_list.is_extendible (current_reflective)
		do
			builder_context_list.extend_with_new (current_reflective)
			if attached {CHAIN [EL_EIF_OBJ_BUILDER_CONTEXT]}
				builder_context_list.collection (current_reflective) as list
			then
				set_next_context (list.last)
			end
		end

	is_field_convertable_from_xml (basic_type, type_id: INTEGER): BOOLEAN
		local
			item_type_id: INTEGER
		do
			if attached current_reflective as cr then
				if cr.is_field_convertable_from_string (basic_type, type_id)
					or else is_builder_context_field (type_id)
				then
					Result := True

				elseif cr.is_collection_field (basic_type, type_id) then
					item_type_id := Eiffel.collection_item_type (type_id)
					Result := Convert_string.has (item_type_id) or else is_builder_context_field (item_type_id)
				end
			end
		end

	is_builder_context_field (type_id: INTEGER): BOOLEAN
		do
			Result := Eiffel.type_of_type (type_id).conforms_to ({EL_EIF_OBJ_BUILDER_CONTEXT})
		end

	set_field_from_node (field: EL_REFLECTED_FIELD)
		do
			field.set_from_readable (current_reflective, node)
		end

	set_cached_field_from_node (field: EL_REFLECTED_STRING [READABLE_STRING_GENERAL])
		-- set string `field' with a cached value from `field.hash_set'
		do
			field.set_from_node (current_reflective, node)
		end

	set_path_field_from_node (field: EL_REFLECTED_PATH)
		do
			field.set_from_readable (current_reflective, node)
			field.expand (current_reflective)
			if field.type_id = Class_id.FILE_PATH
				and then attached {FILE_PATH} field.value (current_reflective) as file_path
				and then not file_path.is_absolute
				and then not node.document_dir.is_empty
			then
				field.set (current_reflective, node.document_dir.plus (file_path))
			end
		end

feature {NONE} -- Implementation

	node: EL_DOCUMENT_NODE_STRING
		deferred
		end

	set_next_context (context: EL_EIF_OBJ_XPATH_CONTEXT)
		deferred
		end

feature {NONE} -- Node types

	Attribute_node: INTEGER = 1

	Element_node: INTEGER = 2

	Node_types: ARRAY [INTEGER]
		once
			Result := << Attribute_node, Element_node, Text_element_node >>
		end

	Text_element_node: INTEGER = 3

feature {NONE} -- Constants

	All_fields: STRING
		-- rename `element_node_fields' as this to include all
		once ("PROCESS")
			create Result.make_empty
		end

	Item: TUPLE [name, xpath, text_xpath: STRING]
		-- list item name
		once
			create Result
			Tuple.fill (Result, "item, /item, /item/text()")
		end

	New_line: CHARACTER = '%N'

	Empty_set: STRING = ""
		-- rename `element_node_fields' as this to exclude all

	Empty_element_set: EL_FIELD_INDICES_SET
		do
			create Result.make_empty
		end

	Null: CHARACTER = '%/0/'
end