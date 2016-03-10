 note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_BUILDABLE_FROM_XML

inherit
	EL_CREATEABLE_FROM_XML
		rename
			node_source as Builder
		end

	EL_EIF_OBJ_BUILDER_CONTEXT
		redefine
			make, create_building_actions
		end

feature {EL_EIF_OBJ_FACTORY_ROOT_BUILDER_CONTEXT} -- Initialization

	make
			--
		do
			Precursor
			PI_building_actions := PI_building_actions_by_type.item (Current, agent create_pi_building_actions)
			create xml_name_space.make_empty
		end

	make_default
		deferred
		end

feature -- Access

	xml_name_space: STRING

feature {NONE} -- Element change

	set_xml_name_space_from_node
			--
		do
			xml_name_space := node.to_string
		end

feature {EL_XML_TO_EIFFEL_OBJECT_BUILDER, EL_EIF_OBJ_ROOT_BUILDER_CONTEXT}
	-- Implementation

	create_building_actions: like building_actions
			--
		do
			Result := Precursor
			Result.put (agent set_xml_name_space_from_node, ("@xmlns").as_string_32)
		end

	create_PI_building_actions: like building_actions
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

	PI_building_action_table: like Type_building_actions
		-- building actions assigned to top level processing instructions
		-- i.e. the same level as the root element
		do
			create Result
		end

	root_builder_context: EL_EIF_OBJ_ROOT_BUILDER_CONTEXT
			--
		do
			Root_builder_context_table.search (root_node_name)
			if Root_builder_context_table.found then
				Result := Root_builder_context_table.found_item
			else
				create Result.make (root_node_name, Current)
				Root_builder_context_table.extend (Result, root_node_name)
			end
		end

	root_node_name: STRING
			--
		deferred
		end

	PI_building_actions: like building_actions

feature {NONE} -- Globals

	Root_builder_context_table: HASH_TABLE [EL_EIF_OBJ_ROOT_BUILDER_CONTEXT, STRING]
			--
		once
			create Result.make (11)
		end

	PI_building_actions_by_type: EL_TYPE_TABLE [
		EL_EIF_OBJ_BUILDER_CONTEXT,
		HASH_TABLE [PROCEDURE [EL_EIF_OBJ_BUILDER_CONTEXT, TUPLE], STRING_32]
	]
			--
		once
			create Result.make (11)
		end

	Builder: EL_XML_TO_EIFFEL_OBJECT_BUILDER
			--
		once
			create Result.make
		end

end
