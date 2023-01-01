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
	date: "2022-12-30 10:59:30 GMT (Friday 30th December 2022)"
	revision: "43"

deferred class
	EL_SETTABLE_FROM_XML_NODE

inherit
	EL_REFLECTION_HANDLER

	EL_MODULE_CONVERT_STRING; EL_MODULE_EIFFEL; EL_MODULE_TUPLE

	EL_EIF_OBJ_BUILDER_CONTEXT_TYPE_CONSTANTS

	EL_SHARED_CLASS_ID

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
			field_list: like importable_list; xpath: STRING_8
			node_type: INTEGER; field: EL_REFLECTED_FIELD
		do
			field_list := importable_list
			if type /= {ANY} then
				field_list := field_list.query_if (agent {EL_REFLECTED_FIELD}.is_type (type.type_id))
			end
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
			if attached {EL_EIF_OBJ_XPATH_CONTEXT} context_field.value (builder_context) as context then
				set_next_context (context)
			end
		end

	extend_collection (field_collection: EL_REFLECTED_COLLECTION [ANY])
		do
			field_collection.extend_from_readable (builder_context, node)
		end

	extend_context_collection (builder_context_list: EL_REFLECTED_COLLECTION [EL_EIF_OBJ_BUILDER_CONTEXT])
		require
			extendible_collection: builder_context_list.is_extendible (builder_context)
		do
			builder_context_list.extend_with_new (builder_context)
			if attached {CHAIN [EL_EIF_OBJ_BUILDER_CONTEXT]}
				builder_context_list.collection (builder_context) as list
			then
				set_next_context (list.last)
			end
		end

	is_builder_context_field (type_id: INTEGER): BOOLEAN
		do
			Result := Eiffel.type_of_type (type_id).conforms_to ({EL_EIF_OBJ_BUILDER_CONTEXT})
		end

	set_field_from_node (field: EL_REFLECTED_FIELD)
		do
			field.set_from_readable (builder_context, node)
		end

	set_cached_field_from_node (field: EL_REFLECTED_STRING [READABLE_STRING_GENERAL])
		-- set string `field' with a cached value from `field.hash_set'
		do
			field.set_from_node (builder_context, node)
		end

	set_path_field_from_node (field: EL_REFLECTED_PATH)
		do
			field.set_from_readable (builder_context, node)
			field.expand (builder_context)
			if field.type_id = Class_id.FILE_PATH
				and then attached {FILE_PATH} field.value (builder_context) as file_path
				and then not file_path.is_absolute
				and then not node.document_dir.is_empty
			then
				field.set (builder_context, node.document_dir.plus (file_path))
			end
		end

feature {NONE} -- Deferred

	builder_context: EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		deferred
		end

	importable_list: EL_ARRAYED_LIST [EL_REFLECTED_FIELD]
		deferred
		end

	node: EL_DOCUMENT_NODE_STRING
		deferred
		end

	set_next_context (context: EL_EIF_OBJ_XPATH_CONTEXT)
		deferred
		end

feature {NONE} -- Constants

	Item: TUPLE [name, xpath, text_xpath: STRING]
		-- list item name
		once
			create Result
			Tuple.fill (Result, "item, /item, /item/text()")
		end

end
