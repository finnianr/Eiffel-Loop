note
	description: "[
		Top level abstraction for building nested Eiffel objects by matching relative xpaths to an XML
		parse event source defined by `new_node_source'. The xpaths are mapped to agents by implementing the function
		`building_action_table' found in class ${EL_EIF_OBJ_BUILDER_CONTEXT}. Typically the agents assign a class attribute
		value by calling a value function of the `last_node' object. But the agent might also change the Eiffel object
		context by calling the procedure `set_next_context'. The new context is mapped to some element in the document
		and all xpaths in the new current context are relative to this element. Returning to the parent context happens
		automatically when all the nodes in the current element have been visited. The top level context is defined by
		implementing the attribute `root_node_name' which defines the root element name.
		
		The most useful descendants of this class are ${EL_BUILDABLE_FROM_XML}
		and ${EL_BUILDABLE_FROM_PYXIS}. The latter
		implements a parser for Pyxis, an XML analog with a Python inspired syntax.
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 14:10:05 GMT (Sunday 22nd September 2024)"
	revision: "31"

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
			{EL_DOCUMENT_EIFFEL_OBJECT_BUILDER, EL_EIF_OBJ_ROOT_BUILDER_CONTEXT} set_node
		redefine
			make_default, new_building_actions
		end

	EL_MODULE_NAMING

feature {EL_EIF_OBJ_ROOT_BUILDER_CONTEXT} -- Initialization

	make_default
			--
		do
			create xml_name_space.make_empty
			Precursor {EL_EIF_OBJ_BUILDER_CONTEXT}
			PI_building_actions := PI_building_actions_by_type.item (Current)
		end

feature -- Access

	xml_name_space: STRING note option: transient attribute end

feature {NONE} -- Element change

	set_xml_name_space_from_node
			--
		do
			xml_name_space := node.to_string_8
		end

feature {EL_DOCUMENT_EIFFEL_OBJECT_BUILDER, EL_EIF_OBJ_ROOT_BUILDER_CONTEXT, EL_BUILDABLE_FROM_NODE_SCAN} -- Factory

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

	new_node_source: EL_DOCUMENT_EIFFEL_OBJECT_BUILDER
			--
		do
			create Result.make (parse_event_source_type)
		end

feature {EL_EIF_OBJ_BUILDER_CONTEXT, EL_DOCUMENT_NODE_SCAN_SOURCE} -- Implementation

	class_prefix_word_count: INTEGER
		-- number of words used as prefix for class name
		do
			inspect generator.index_of ('_', 1)
			 	when 2, 3 then
			 		Result := 1
			 else
			 	Result := 0
			 end
		end

	default_root_node_name: STRING
		-- `generator.as_lower' with `class_prefix_word_count' words pruned from start
		do
			Result := Naming.class_as_snake_lower (Current, class_prefix_word_count, 0)
		end

	PI_building_action_table: EL_PROCEDURE_TABLE [STRING]
		-- building actions assigned to top level processing instructions
		-- i.e. the same level as the root element
		do
			create Result
		end

	root_node_name: STRING
			--
		deferred
		end

feature {EL_EIF_OBJ_BUILDER_CONTEXT, EL_DOCUMENT_NODE_SCAN_SOURCE} -- Internal attributes

	PI_building_actions: like building_actions note option: transient attribute end

feature {NONE} -- Constants

	PI_building_actions_by_type: EL_FUNCTION_RESULT_TABLE [EL_BUILDABLE_FROM_NODE_SCAN, EL_PROCEDURE_TABLE [STRING]]
			--
		once
			create Result.make (11, agent {EL_BUILDABLE_FROM_NODE_SCAN}.new_pi_building_actions)
		end

note
	descendants: "[
			EL_BUILDABLE_FROM_NODE_SCAN*
				${EL_SMART_BUILDABLE_FROM_NODE_SCAN}
					${EL_SMART_XML_TO_EIFFEL_OBJECT_BUILDER}
				${EL_BUILDABLE_FROM_XML}*
					${BIOINFORMATIC_COMMANDS}
					${MATRIX_CALCULATOR}
				${EL_FILE_PERSISTENT_BUILDABLE_FROM_NODE_SCAN}*
					${EL_FILE_PERSISTENT_BUILDABLE_FROM_XML}*
						${WEB_FORM}
						${SMIL_PRESENTATION}
				${EL_BUILDABLE_FROM_PYXIS}*
					${EL_TRANSLATION_TABLE}

	]"
end