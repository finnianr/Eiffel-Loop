note
	description: "Summary description for {EL_BUILDABLE_FROM_XML_NODE_TREE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-25 11:19:55 GMT (Friday 25th December 2015)"
	revision: "4"

deferred class
	EL_BUILDABLE_FROM_XML_2 [G -> EL_OBJECT_BUILDING_XML_NODE_VISITOR create make end]

inherit
	EL_XML_NODE_TREE_PROCESSOR [G]
		redefine
			make_default
		end

	EL_EIF_OBJ_BUILDER_CONTEXT
		redefine
			make_default, new_building_actions
		end

feature {EL_EIF_OBJ_FACTORY_ROOT_BUILDER_CONTEXT} -- Initialization

	make_default
			--
		do
			Precursor {EL_XML_NODE_TREE_PROCESSOR}
			Precursor {EL_EIF_OBJ_BUILDER_CONTEXT}
			PI_building_actions := PI_building_actions_table.item ({like Current}, agent new_pi_building_actions)
			create xml_name_space.make_empty
		end

feature -- Access

	xml_name_space: STRING

feature {NONE} -- Element change

	set_xml_name_space_from_node
			--
		do
			xml_name_space := node.to_string_8
		end

feature {NONE} -- Factory

	new_building_actions: like building_actions
			--
		do
			Result := Precursor
			Result.put (agent set_xml_name_space_from_node, ("@xmlns").as_string_32)
		end

	new_pi_building_actions: like building_actions
			--
		local
			action_table: like PI_building_action_table
		do
			action_table := PI_building_action_table
			create Result.make (action_table.count)
			Result.compare_objects
			from action_table.start until action_table.after loop
				Result.extend (action_table.item_for_iteration , action_table.key_for_iteration.as_string_32)
				action_table.forth
			end
		end

	new_root_builder_context: EL_EIF_OBJ_ROOT_BUILDER_CONTEXT_2
		do
			create Result.make (root_node_name, Current)
		end

feature {EL_EIF_OBJ_ROOT_BUILDER_CONTEXT_2, EL_OBJECT_BUILDING_XML_NODE_VISITOR} -- Access

	PI_building_action_table: like Type_building_actions
		-- building actions assigned to top level processing instructions
		-- i.e. the same level as the root element
		do
			create Result
		end

	PI_building_actions: like building_actions

	root_builder_context: like new_root_builder_context
			--
		do
			Result := Root_builder_context_table.item ({like Current}, agent new_root_builder_context)
		end

feature {NONE} -- Implementation

	root_node_name: STRING
			--
		deferred
		end

feature {NONE} -- Constants

	PI_building_actions_table: EL_TYPE_TABLE [HASH_TABLE [PROCEDURE [EL_EIF_OBJ_BUILDER_CONTEXT, TUPLE], STRING_32]]
		once
			create Result.make_equal (11)
		end

	Root_builder_context_table: EL_TYPE_TABLE [EL_EIF_OBJ_ROOT_BUILDER_CONTEXT_2]
			--
		once
			create Result.make_equal (11)
		end

end
