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
	date: "2020-01-13 11:59:09 GMT (Monday 13th January 2020)"
	revision: "12"

class
	EL_SMART_BUILDABLE_FROM_NODE_SCAN

inherit
	EL_BUILDABLE_FROM_NODE_SCAN
		redefine
			new_node_source
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

	item: detachable EL_BUILDABLE_FROM_NODE_SCAN
		-- resulting object from call to `build_from_*' routine
		require
			has_object: has_item
		do
			Result := result_stack.item
		end

feature -- Status query

	has_item: BOOLEAN
		-- `True' if call to `build_from_*' routine succeeded in building an object
		do
			Result := not result_stack.is_empty
		end

feature {EL_XML_NODE_SCAN_TO_EIFFEL_OBJECT_BUILDER} -- Implementation

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			create Result
		end

	new_node_source: EL_SMART_NODE_SCAN_TO_EIFFEL_OBJECT_BUILDER
			--
		do
			create Result.make (parse_event_source_type)
		end

	new_root_builder_context: EL_SMART_EIF_OBJ_ROOT_BUILDER_CONTEXT
			--
		do
			create Result.make (root_node_name, Current)
		end

feature {EL_SMART_EIF_OBJ_ROOT_BUILDER_CONTEXT} -- Internal attributes

	parse_event_source_type: TYPE [EL_PARSE_EVENT_SOURCE]

	result_stack: ARRAYED_STACK [EL_BUILDABLE_FROM_NODE_SCAN]

feature {NONE} -- Constants

	Root_node_name: STRING = "*"
		-- Wild card root name

end
