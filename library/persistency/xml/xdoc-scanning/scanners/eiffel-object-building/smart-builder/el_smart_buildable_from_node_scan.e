note
	description: "[
		XML parser that reacts to a special processing instructions before the root element of the form:
		
			<?create {MY_CLASS}?>
			
		`MY_CLASS' represents an implementation of the deferred class [$source EL_BUILDABLE_FROM_XML] and it knows how
		to build itself from this type of document. The built object is accessible via the attribute `target'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-28 10:09:21 GMT (Sunday 28th October 2018)"
	revision: "6"

class
	EL_SMART_BUILDABLE_FROM_NODE_SCAN

inherit
	EL_BUILDABLE_FROM_NODE_SCAN
		redefine
			root_builder_context, build_from_stream, build_from_string
		end

create
	make

feature {NONE} -- Initialization

	make (a_parse_event_source_type: like parse_event_source_type)
			--
		do
			parse_event_source_type := a_parse_event_source_type
			make_default
			create root_builder_context.make (Root_node_name, Current)
			target := Current
		end

feature -- Access

	target: EL_BUILDABLE_FROM_NODE_SCAN

feature -- Basic operations

	build_from_stream (a_stream: IO_MEDIUM)
			--
		do
			Precursor (a_stream)
			target := Root_builder_context.target
			reset
		end

	build_from_string (a_string: STRING)
			--
		do
			Precursor (a_string)
			target := Root_builder_context.target
			reset
		end

feature {NONE} -- Implementation

	building_action_table: EL_PROCEDURE_TABLE
			--
		do
			create Result
		end

	reset
			--
		do
			root_builder_context.set_root_node_xpath (Root_node_name)
			root_builder_context.set_target (Current)
			root_builder_context.reset
		end

feature {NONE} -- Internal attributes

	parse_event_source_type: TYPE [EL_PARSE_EVENT_SOURCE]

	root_builder_context: EL_EIF_OBJ_FACTORY_ROOT_BUILDER_CONTEXT

feature {NONE} -- Constants

	Root_node_name: STRING = "<NONE>"

end
