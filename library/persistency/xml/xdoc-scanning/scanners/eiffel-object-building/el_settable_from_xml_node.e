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
	date: "2019-01-18 12:29:02 GMT (Friday 18th January 2019)"
	revision: "10"

deferred class
	EL_SETTABLE_FROM_XML_NODE

inherit
	EL_REFLECTIVE_I

feature {NONE} -- Implementation

	building_actions_for_each_type (types: ARRAY [TYPE [ANY]]; node_type: INTEGER_32): EL_PROCEDURE_TABLE [STRING]
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

	building_actions_for_type (type: TYPE [ANY]; node_type: INTEGER_32): EL_PROCEDURE_TABLE [STRING]
		require
			valid_node_type: Node_types.has (node_type)
		local
			table: EL_REFLECTED_FIELD_TABLE
			field_list: LIST [EL_REFLECTED_FIELD]; text_xpath: STRING_8
		do
			table := field_table
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

	node: EL_XML_NODE
		deferred
		end

feature {NONE} -- Node types

	Node_types: ARRAY [INTEGER]
		once
			Result := << Attribute_node, Text_element_node >>
		end

	Attribute_node: INTEGER = 1

	Text_element_node: INTEGER = 2

end

