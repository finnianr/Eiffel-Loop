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
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-10 14:09:54 GMT (Monday 10th June 2019)"
	revision: "14"

deferred class
	EL_SETTABLE_FROM_XML_NODE

inherit
	EL_REFLECTIVE_I

	EL_MODULE_EIFFEL

	EL_SHARED_DEFAULT_VALUE_TABLE

	EL_EIF_OBJ_BUILDER_CONTEXT_TYPE_CONSTANTS

	EL_ZSTRING_CONSTANTS

	EL_XML_ESCAPING_CONSTANTS

feature {EL_SETTABLE_FROM_XML_NODE} -- Basic operations

	put_xml_element (xml_out: EL_OUTPUT_MEDIUM; name: STRING; tab_count: INTEGER)
		-- recursively output elements to file as XML
		local
			has_child_element: BOOLEAN; table: like field_table
			attribute_count: INTEGER; value: ZSTRING
		do
			table := field_table
			value := String_pool.new_string
			xml_out.put_indent (tab_count); xml_out.put_character_8 ('<')
			xml_out.put_string_8 (name)
			across table as field loop
				if attached {EL_REFLECTED_EIF_OBJ_BUILDER_CONTEXT} field.item
					or else attached {EL_REFLECTED_COLLECTION [ANY]} field.item
					or else attached {EL_REFLECTED_COLLECTION_EIF_OBJ_BUILDER_CONTEXT} field.item
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
						put_value (xml_out, value, attached {EL_REFLECTED_STRING_GENERAL} field.item)
						xml_out.put_string_8 (once "%"%N")
						attribute_count := attribute_count + 1
					end
				end
			end
			if has_child_element then
				xml_out.put_string_8 (once ">%N")
				put_child_elements (xml_out, table, value, tab_count)
				put_xml_tag_close (xml_out, name, tab_count, New_line)
			else
				xml_out.put_indent (tab_count)
				xml_out.put_string_8 (once "/>%N")
			end
			String_pool.recycle (value)
		end

	put_child_elements (xml_out: EL_OUTPUT_MEDIUM; table: like field_table; value: ZSTRING; tab_count: INTEGER)
		local
			context_list: LINEAR [EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT]
			needs_escaping: BOOLEAN
		do
			across table as field loop
				if attached {EL_REFLECTED_EIF_OBJ_BUILDER_CONTEXT} field.item as context_field then
					if attached {EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT} context_field.value (current_reflective) as context
					then
						context.put_xml_element (xml_out, field.item.name, tab_count + 1)
					end
				elseif attached {EL_REFLECTED_COLLECTION [ANY]} field.item as collection_field then
					needs_escaping := collection_field.is_string_item
					put_xml_tag_open (xml_out, collection_field.name, tab_count + 1, New_line)
					across collection_field.to_string_list (current_reflective) as general loop
						put_xml_tag_open (xml_out, Item_name, tab_count + 2, Null)
						value.wipe_out
						value.append_string_general (general.item)
						put_value (xml_out, value, needs_escaping)
						put_xml_tag_close (xml_out, Item_name, 0, New_line)
					end
					put_xml_tag_close (xml_out, collection_field.name, tab_count + 1, New_line)

				elseif attached {EL_REFLECTED_COLLECTION_EIF_OBJ_BUILDER_CONTEXT} field.item as collection_field then
					if attached {COLLECTION [EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT]}
						collection_field.value (current_reflective) as collection
					then
						put_xml_tag_open (xml_out, collection_field.name, tab_count + 1, New_line)
						context_list := collection.linear_representation
						from context_list.start until context_list.after loop
							context_list.item.put_xml_element (xml_out, Item_name, tab_count + 2)
							context_list.forth
						end
						put_xml_tag_close (xml_out, collection_field.name, tab_count + 1, New_line)
					end
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
			if closed then
				xml_out.put_string_8 (once "</")
			else
				xml_out.put_character_8 ('<')
			end
			xml_out.put_string_8 (name)
			xml_out.put_string_8 (once ">")
			if character = New_line then
				xml_out.put_new_line
			end
		end

feature {NONE} -- Implementation

	building_actions_for_each_type (types: ARRAY [TYPE [ANY]]; node_type: INTEGER_32): EL_PROCEDURE_TABLE [STRING]
		local
			i: INTEGER_32; table: EL_PROCEDURE_TABLE [STRING]
		do
			from i := 1 until i > types.count loop
				table := building_actions_for_type (types [i], node_type)
				if i = 1 then
					Result := table
				else
					Result.merge (table)
				end
				i := i + 1
			end
		end

	building_actions_for_type (type: TYPE [ANY]; node_type: INTEGER_32): EL_PROCEDURE_TABLE [STRING]
		require
			valid_node_type: Node_types.has (node_type)
		local
			table: EL_REFLECTED_FIELD_TABLE; field_list: LIST [EL_REFLECTED_FIELD]; xpath: STRING_8
		do
			table := field_table
			table.query_by_type (type)
			field_list := table.last_query
			create Result.make_equal (field_list.count)
			from field_list.start until field_list.after loop
				if attached {EL_REFLECTED_COLLECTION_EIF_OBJ_BUILDER_CONTEXT} field_list.item as context_field_collection
				then
					if Default_value_table.has_key (context_field_collection.item_type_id)
						and then attached {EL_EIF_OBJ_BUILDER_CONTEXT} Default_value_table.found_item as default_value
					then
						xpath := new_xpath (field_list.item, Element_node) + Item_xpath
						Result [xpath] := agent extend_context_collection (context_field_collection, default_value)
					else
						check
							default_value_available: False
							-- Need to add a default value for collection item to `Default_value_table'
						end
					end

				elseif attached {EL_REFLECTED_COLLECTION [ANY]} field_list.item as collection_field then
					xpath := new_xpath (field_list.item, Element_node) + Item_text_xpath
					Result [xpath] := agent extend_collection (collection_field)

				elseif attached {EL_REFLECTED_EIF_OBJ_BUILDER_CONTEXT} field_list.item as context_field then
					Result [new_xpath (field_list.item, Element_node)] := agent change_context (context_field)

				elseif attached {EL_REFLECTED_PATH} field_list.item as path_field then
					Result [new_xpath (field_list.item, node_type)] := agent set_path_field_from_node (path_field)
				else
					Result [new_xpath (field_list.item, node_type)] := agent set_field_from_node (field_list.item)
				end
				field_list.forth
			end
		end

	new_xpath (field: EL_REFLECTED_FIELD; node_type: INTEGER): STRING
		do
			inspect node_type
				when Attribute_node then
					Result := once "@" + field.export_name
				when Text_element_node then
					Result := field.export_name + once "/text()"
			else
				Result := field.export_name
			end
		end

	change_context (context_field: EL_REFLECTED_EIF_OBJ_BUILDER_CONTEXT)
		do
			if attached {EL_EIF_OBJ_XPATH_CONTEXT} context_field.value (current_reflective) as context then
				set_next_context (context)
			end
		end

	extend_collection (field_collection: EL_REFLECTED_COLLECTION [ANY])
		do
			field_collection.extend_from_readable (current_reflective, node)
		end

	extend_context_collection (
		context_field_collection: EL_REFLECTED_COLLECTION_EIF_OBJ_BUILDER_CONTEXT
		default_value: EL_EIF_OBJ_BUILDER_CONTEXT
	)
		local
			new_context: EL_EIF_OBJ_BUILDER_CONTEXT
		do
			if attached {COLLECTION [EL_EIF_OBJ_BUILDER_CONTEXT]}
				context_field_collection.value (current_reflective) as collection
			then
				new_context := default_value.twin
				new_context.make_default
				set_next_context (new_context)
				collection.extend (new_context)
			end
		end

	is_field_convertable_from_xml (basic_type, type_id: INTEGER): BOOLEAN
		do
			Result := is_field_convertable_from_string (basic_type, type_id)
							or else is_collection_field (basic_type, type_id)
							or else is_builder_context_field (basic_type, type_id)
		end

	is_builder_context_field (basic_type, type_id: INTEGER): BOOLEAN
		do
			Result := Eiffel.field_conforms_to_one_of (basic_type, type_id, Builder_context_types)
		end

	set_field_from_node (field: EL_REFLECTED_FIELD)
		do
			field.set_from_readable (current_reflective, node)
		end

	set_path_field_from_node (field: EL_REFLECTED_PATH)
		do
			field.set_from_readable (current_reflective, node)
			field.expand (current_reflective)
		end

feature {NONE} -- Implementation

	node: EL_XML_NODE
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

	Item_name: STRING
		-- list item name
		once
			Result := "item"
		end

	Item_xpath: STRING
		once
			Result := Item_name.twin
			Result.prepend_character ('/')
		end

	Item_text_xpath: STRING
		once
			Result := Item_xpath + "/text()"
		end

	New_line: CHARACTER = '%N'

	Null: CHARACTER = '%/0/'
end

