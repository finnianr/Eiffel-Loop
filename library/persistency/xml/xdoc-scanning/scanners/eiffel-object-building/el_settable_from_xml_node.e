note
	description: "[
		A helper class for implementing the function `building_action_table' from class
		`[$source EL_EIF_OBJ_BUILDER_CONTEXT]' by using Eiffel reflection to map xpath's
		 derived from object field names to a setter agent.
		
		The implementing class must also inherit class `[$source EL_REFLECTIVE]' either directly
		or from one of it's descendants.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-12 17:35:48 GMT (Thursday 12th April 2018)"
	revision: "6"

deferred class
	EL_SETTABLE_FROM_XML_NODE

inherit
	EL_REFLECTOR_CONSTANTS

feature {NONE} -- Implementation

	building_actions_for_each_type (types: ARRAY [TYPE [ANY]]; node_type: INTEGER_32): EL_PROCEDURE_TABLE
		local
			i: INTEGER_32
		do
			from i := 1 until i > types.count loop
				if i = 1 then
					Result := building_actions_for_type (types [i], node_type)
				else
					Result.merge (building_actions_for_type (types [i], node_type))
				end
				i := i + 1
			end
		end

	building_actions_for_type (type: TYPE [ANY]; node_type: INTEGER_32): EL_PROCEDURE_TABLE
		require
			valid_node_type: (<< Attribute_node, Text_element_node >>).has (node_type)
		local
			meta_data: like meta_data_by_type.item; table: EL_REFLECTED_FIELD_TABLE
			field_list: LIST [EL_REFLECTED_FIELD]; text_xpath: STRING_8
		do
			meta_data := meta_data_by_type.item (current_reflective)
			table := meta_data.field_table
			table.query_by_type (type)
			field_list := table.last_query
			create Result.make_equal (field_list.count)
			from field_list.start until field_list.after loop
				inspect node_type
					when Attribute_node then
						text_xpath := once "@" + field_list.item.export_name
				else
					text_xpath := field_list.item.export_name + once "/text()"
				end
				Result [text_xpath] := agent set_field_from_node (field_list.item)
				field_list.forth
			end
		end

	set_field_from_node (field: EL_REFLECTED_FIELD)
		do
			field.set_from_readable (current_reflective, node)
		end

feature {NONE} -- Implementation

	current_reflective: EL_REFLECTIVE
		deferred
		end

	meta_data_by_type: EL_FUNCTION_RESULT_TABLE [EL_REFLECTIVE, EL_CLASS_META_DATA]
		deferred
		end

	node: EL_XML_NODE
		deferred
		end

feature {NONE} -- Constants

	Attribute_node: INTEGER_32 = 1
			-- Constants

	Text_element_node: INTEGER_32 = 2

end

