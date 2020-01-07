note
	description: "[
		Node scan builder that can respond to a `create ' processing instructions before the root element as for example:
		
			<?xml version="1.0" encoding="UTF-8"?>
			<?create {SMIL_PRESENTATION}?>
			<smil>
			..
			</smil>
			
		[$source SMIL_PRESENTATION]' implements the deferred class [$source EL_BUILDABLE_FROM_NODE_SCAN].
		The created object is accessible via the stack container `result_stack'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-07 15:31:02 GMT (Tuesday 7th January 2020)"
	revision: "9"

class
	EL_SMART_BUILDABLE_FROM_NODE_SCAN

inherit
	EL_BUILDABLE_FROM_NODE_SCAN
		redefine
			PI_building_action_table
		end

	EL_MODULE_STRING_8

create
	make

feature {NONE} -- Initialization

	make (a_parse_event_source_type: like parse_event_source_type)
			--
		do
			parse_event_source_type := a_parse_event_source_type
			create result_stack.make (1)
			make_default
		end

feature -- Access

	result_stack: ARRAYED_STACK [EL_BUILDABLE_FROM_NODE_SCAN]

feature -- Status query

	has_result: BOOLEAN
		do
			Result := not result_stack.is_empty
		end

feature {NONE} -- Event handling

	on_create
		local
			class_type: STRING; target: EL_BUILDABLE_FROM_NODE_SCAN
		do
			result_stack.wipe_out
			class_type := node.to_string_8
			String_8.remove_bookends (class_type, once "{}")
			target := Factory.instance_from_class_name (class_type, agent {EL_BUILDABLE_FROM_NODE_SCAN}.make_default)
			if attached {EL_XML_NODE_SCAN_TO_EIFFEL_OBJECT_BUILDER} node_source.item as builder
				and then not builder.context_stack.is_empty
				and then attached {EL_EIF_OBJ_ROOT_BUILDER_CONTEXT} builder.context_stack.item as root_context
			then
				if target.pi_building_actions.has_key (PI_create) then
					target.set_node (node)
					target.pi_building_actions.found_item.set_target (target)
					target.pi_building_actions.found_item.apply
				end
				root_context.set_target (target)
				result_stack.put (target)
			end
		end

feature {NONE} -- Implementation

	PI_building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			create Result.make (<< [PI_create, agent on_create] >>)
		end

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			create Result
		end

feature {NONE} -- Internal attributes

	parse_event_source_type: TYPE [EL_PARSE_EVENT_SOURCE]

feature {NONE} -- Constants

	Factory: EL_OBJECT_FACTORY [EL_BUILDABLE_FROM_NODE_SCAN]
			--
		once
			create Result
		end

	PI_create: STRING = "create"

	Root_node_name: STRING = "*"
		-- Wild card root name

end
