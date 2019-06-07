note
	description: "Reflective Eiffel object builder (from XML) context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-07 15:58:09 GMT (Friday 7th June 2019)"
	revision: "6"

deferred class
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT

inherit
	EL_EIF_OBJ_BUILDER_CONTEXT
		export
			{NONE} all
		undefine
			is_equal
		redefine
			make_default
		end

	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_field_convertable_from_xml,
			export_name as xml_names,
			import_name as import_default
		export
			{NONE} all
		redefine
			Except_fields, make_default, new_meta_data
		end

	EL_SETTABLE_FROM_XML_NODE
		undefine
			is_equal
		end

	EL_ZSTRING_CONSTANTS
		undefine
			is_equal
		end

	EL_XML_ESCAPING_CONSTANTS
		undefine
			is_equal
		end

feature {NONE} -- Initialization

	make_default
		do
			Precursor {EL_REFLECTIVELY_SETTABLE}
			Precursor {EL_EIF_OBJ_BUILDER_CONTEXT}
		end

feature {EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT} -- Basic operations

	put_xml_element (xml_out: EL_PLAIN_TEXT_FILE; name: STRING; tab_count: INTEGER)
		-- recursively output elements to file as XML
		local
			has_builder_context, has_builder_context_collection: BOOLEAN; table: like field_table
			attribute_count: INTEGER; context_list: LINEAR [EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT]
			value: ZSTRING; item_name: STRING
		do
			table := field_table
			value := String_pool.new_string
			xml_out.put_indent (tab_count); xml_out.put_character_8 ('<')
			xml_out.put_string_8 (name)
			across table as field loop
				if attached {EL_REFLECTED_EIF_OBJ_BUILDER_CONTEXT} field.item then
					has_builder_context := True
				elseif attached {EL_REFLECTED_COLLECTION_EIF_OBJ_BUILDER_CONTEXT} field.item then
					has_builder_context_collection := True
				else
					value.wipe_out
					field.item.write (current_reflective, value)
					if not value.is_empty then
						if attribute_count = 0 then
							xml_out.put_new_line
						end
						xml_out.put_indent (tab_count + 1); xml_out.put_string_8 (field.item.name)
						xml_out.put_string_8 (once " = %"")
						if attached {EL_REFLECTED_STRING_GENERAL} field.item then
							xml_out.put_string_general (Xml_escaper.escaped (value, False))
						else
							xml_out.put_string_general (value)
						end
						xml_out.put_string_8 (once "%"%N")
						attribute_count := attribute_count + 1
					end
				end
			end
			if has_builder_context or has_builder_context_collection then
				xml_out.put_string_8 (once ">%N")
				across table as field loop
					if attached {EL_REFLECTED_EIF_OBJ_BUILDER_CONTEXT} field.item as context_field then
						if attached {EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT} context_field.value (current_reflective) as context
						then
							context.put_xml_element (xml_out, field.item.name, tab_count + 1)
						end
					elseif attached {EL_REFLECTED_COLLECTION_EIF_OBJ_BUILDER_CONTEXT} field.item as collection_field then
						if attached {COLLECTION [EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT]}
							collection_field.value (current_reflective) as collection
						then
							item_name := List_item_element_name.substring (2, List_item_element_name.count)
							put_xml_tag (xml_out, collection_field.name, tab_count + 1, False)
							context_list := collection.linear_representation
							from context_list.start until context_list.after loop
								context_list.item.put_xml_element (xml_out, item_name, tab_count + 2)
								context_list.forth
							end
							put_xml_tag (xml_out, collection_field.name, tab_count + 1, True)
						end
					end
				end
				put_xml_tag (xml_out, name, tab_count, True)
			else
				xml_out.put_indent (tab_count)
				xml_out.put_string_8 (once "/>%N")
			end
			String_pool.recycle (value)
		end

	put_xml_tag (xml_out: EL_PLAIN_TEXT_FILE; name: STRING; tab_count: INTEGER; closed: BOOLEAN)
		do
			xml_out.put_indent (tab_count)
			if closed then
				xml_out.put_string_8 (once "</")
			else
				xml_out.put_character_8 ('<')
			end
			xml_out.put_string_8 (name)
			xml_out.put_string_8 (once ">%N")
		end

feature {NONE} -- Implementation

	is_field_convertable_from_xml (basic_type, type_id: INTEGER): BOOLEAN
		do
			Result := is_field_convertable_from_string (basic_type, type_id)
			if not Result and then basic_type = Reference_type then
				Result := across Builder_context_types as base_type some
					Eiffel.field_conforms_to (type_id, base_type.item)
				end
			end
		end

	new_meta_data: EL_EIF_OBJ_BUILDER_CONTEXT_CLASS_META_DATA
		do
			create Result.make (Current)
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			Result := building_actions_for_each_type (field_table.type_set, element_node_type)
		end

	element_node_type: INTEGER
		-- type of XML node mapped to attribute value
		-- Possible values `Text_element_node' or `Attribute_node'
		deferred
		ensure
			valid_node_type: Node_types.has (Result)
		end

feature {NONE} -- Constants

	Except_fields: STRING
		once
			Result := Precursor + ", next_context, xpath"
		end

	List_item_element_name: STRING
		once
			Result := "/item"
		end
end
