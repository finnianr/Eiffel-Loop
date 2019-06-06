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
	date: "2019-06-06 19:33:06 GMT (Thursday 6th June 2019)"
	revision: "11"

deferred class
	EL_SETTABLE_FROM_XML_NODE

inherit
	EL_REFLECTIVE_I

	EL_MODULE_EIFFEL

	EL_SHARED_DEFAULT_VALUE_TABLE

feature {NONE} -- Implementation

	building_actions_for_each_type (types: ARRAY [TYPE [ANY]]; node_type: INTEGER_32): EL_PROCEDURE_TABLE [STRING]
		local
			i: INTEGER_32; i_th: TYPE [ANY]
			table: EL_PROCEDURE_TABLE [STRING]
		do
			from i := 1 until i > types.count loop
				i_th := types [i]
				if across Convertable_types as base_type some
						Eiffel.field_conforms_to (i_th.type_id, base_type.item)
					end
				then
					table := building_actions_for_type (i_th, Element_node)
				else
					table := building_actions_for_type (i_th, node_type)
				end
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
			table: EL_REFLECTED_FIELD_TABLE
			field_list: LIST [EL_REFLECTED_FIELD]; text_xpath: STRING_8
			context_change: BOOLEAN
		do
			table := field_table
			table.query_by_type (type)
			field_list := table.last_query
			create Result.make_equal (field_list.count)
			from field_list.start until field_list.after loop
				inspect node_type
					when Attribute_node then
						text_xpath := once "@" + field_list.item.export_name
						context_change := False

					when Text_element_node then
						text_xpath := field_list.item.export_name + once "/text()"
						context_change := False
				else
					text_xpath := field_list.item.export_name
					context_change := True
				end
				if context_change and then attached {EL_REFLECTED_REFERENCE [ANY]} field_list.item as l_reference then
					if Eiffel.field_conforms_to (type.type_id, EIF_OBJ_BUILDER_CONTEXT) then
						Result [text_xpath] := agent change_context (l_reference)

					elseif Eiffel.field_conforms_to (type.type_id, COLLECTION_EIF_OBJ_BUILDER_CONTEXT) then
						if Default_value_table.has_key (type.generic_parameter_type (1).type_id)
							and then attached {EL_EIF_OBJ_BUILDER_CONTEXT} Default_value_table.found_item as default_value
						then
							Result [text_xpath + once "/item"] := agent extend_collection (l_reference, default_value)
						else
							check
								default_value_available: False
								-- Need to add a default value for collection item to `Default_value_table'
							end
						end
					end
				elseif attached {EL_REFLECTED_PATH} field_list.item as path_field then
					Result [text_xpath] := agent set_path_field_from_node (path_field)
				else
					Result [text_xpath] := agent set_field_from_node (field_list.item)
				end
				field_list.forth
			end
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

	extend_collection (a_reference: EL_REFLECTED_REFERENCE [ANY]; default_value: EL_EIF_OBJ_BUILDER_CONTEXT)
		local
			new_context: EL_EIF_OBJ_BUILDER_CONTEXT
		do
			if attached {COLLECTION [EL_EIF_OBJ_BUILDER_CONTEXT]} a_reference.value (current_reflective) as collection
			then
				new_context := default_value.twin
				new_context.make_default
				set_next_context (new_context)
				collection.extend (new_context)
			end
		end

	change_context (a_reference: EL_REFLECTED_REFERENCE [ANY])
		do
			if attached {EL_EIF_OBJ_XPATH_CONTEXT} a_reference.value (current_reflective) as context then
				set_next_context (context)
			end
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

	Node_types: ARRAY [INTEGER]
		once
			Result := << Attribute_node, Element_node, Text_element_node >>
		end

	Element_node: INTEGER = 2

	Text_element_node: INTEGER = 3

feature {NONE} -- Constants

	Convertable_types: ARRAY [INTEGER]
		once
			Result := << EIF_OBJ_BUILDER_CONTEXT, COLLECTION_EIF_OBJ_BUILDER_CONTEXT >>
		end

	EIF_OBJ_BUILDER_CONTEXT: INTEGER
		once ("PROCESS")
			Result := ({EL_EIF_OBJ_BUILDER_CONTEXT}).type_id
		end

	COLLECTION_EIF_OBJ_BUILDER_CONTEXT: INTEGER
		once ("PROCESS")
			Result := ({COLLECTION [EL_EIF_OBJ_BUILDER_CONTEXT]}).type_id
		end

end

