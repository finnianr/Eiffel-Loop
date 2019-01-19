note
	description: "[
		Top level abstraction for building nested Eiffel objects by matching relative xpaths to an XML
		parse event source defined by `new_node_source'. The xpaths are mapped to agents by implementing the function
		`building_action_table' found in class [$source EL_EIF_OBJ_BUILDER_CONTEXT]. Typically the agents assign a class attribute
		value by calling a value function of the `last_node' object. But the agent might also change the Eiffel object
		context by calling the procedure `set_next_context'. The new context is mapped to some element in the document
		and all xpaths in the new current context are relative to this element. Returning to the parent context happens
		automatically when all the nodes in the current element have been visited. The top level context is defined by
		implementing the attribute `root_node_name' which defines the root element name.
		
		The most useful descendants of this class are [$source EL_BUILDABLE_FROM_XML]
		and [$source EL_BUILDABLE_FROM_PYXIS]. The latter
		implements a parser for Pyxis, an XML analog with a Python inspired syntax.
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-18 12:29:14 GMT (Friday 18th January 2019)"
	revision: "10"

deferred class
	EL_BUILDABLE_FROM_NODE_SCAN

inherit
	EL_CREATEABLE_FROM_NODE_SCAN
		export
			{NONE} all
			{ANY} build_from_stream, build_from_string, build_from_lines, build_from_file,
					set_parser_type, generator
		end

	EL_EIF_OBJ_BUILDER_CONTEXT
		export
			{NONE} all
			{EL_XML_NODE_SCAN_TO_EIFFEL_OBJECT_BUILDER} set_node
		redefine
			make_default, new_building_actions
		end

feature {EL_EIF_OBJ_FACTORY_ROOT_BUILDER_CONTEXT} -- Initialization

	make_default
			--
		do
			Precursor
			PI_building_actions := PI_building_actions_by_type.item (Current)
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

feature {EL_XML_NODE_SCAN_TO_EIFFEL_OBJECT_BUILDER, EL_EIF_OBJ_ROOT_BUILDER_CONTEXT, EL_BUILDABLE_FROM_NODE_SCAN} -- Factory

	new_building_actions: like building_actions
			--
		do
			Result := Precursor
			Result.put (agent set_xml_name_space_from_node, once "@xmlns")
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

	new_node_source: EL_XML_NODE_SCAN_TO_EIFFEL_OBJECT_BUILDER
			--
		do
			create Result.make (parse_event_source_type)
		end

feature {EL_EIF_OBJ_BUILDER_CONTEXT, EL_XML_NODE_SCAN_TO_EIFFEL_OBJECT_BUILDER} -- Implementation

	PI_building_action_table: EL_PROCEDURE_TABLE [STRING]
		-- building actions assigned to top level processing instructions
		-- i.e. the same level as the root element
		do
			create Result
		end

	root_builder_context: EL_EIF_OBJ_ROOT_BUILDER_CONTEXT
			--
		do
			if Root_builder_context_table.has_key (root_node_name) then
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

feature {EL_EIF_OBJ_BUILDER_CONTEXT} -- Internal attributes

	PI_building_actions: like building_actions

feature {NONE} -- Constants

	PI_building_actions_by_type: EL_FUNCTION_RESULT_TABLE [EL_BUILDABLE_FROM_NODE_SCAN, HASH_TABLE [PROCEDURE, STRING_32]]
			--
		once
			create Result.make (11, agent {EL_BUILDABLE_FROM_NODE_SCAN}.new_pi_building_actions)
		end

	Root_builder_context_table: HASH_TABLE [EL_EIF_OBJ_ROOT_BUILDER_CONTEXT, STRING]
			--
		once
			create Result.make (11)
		end

note
	descendants: "[
			EL_BUILDABLE_FROM_NODE_SCAN*
				[$source EL_SMART_BUILDABLE_FROM_NODE_SCAN]
					[$source EL_SMART_XML_TO_EIFFEL_OBJECT_BUILDER]
				[$source EL_BUILDABLE_FROM_XML]*
					[$source BIOINFORMATIC_COMMANDS]
					[$source MATRIX_CALCULATOR]
				[$source EL_FILE_PERSISTENT_BUILDABLE_FROM_NODE_SCAN]*
					[$source EL_FILE_PERSISTENT_BUILDABLE_FROM_XML]*
						[$source WEB_FORM]
						[$source SMIL_PRESENTATION]
				[$source EL_BUILDABLE_FROM_PYXIS]*
					[$source EL_TRANSLATION_TABLE]

	]"
end
