note
	description: "Summary description for {EL_SMART_BUILDABLE_FROM_NODE_SCAN}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-14 13:36:35 GMT (Sunday 14th May 2017)"
	revision: "1"

class
	EL_SMART_BUILDABLE_FROM_NODE_SCAN [EVENT_SOURCE -> EL_PARSE_EVENT_SOURCE]

inherit
	EL_BUILDABLE_FROM_NODE_SCAN
		redefine
			root_builder_context, build_from_stream, build_from_string
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
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

	building_action_table: like Type_building_actions
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

feature {NONE} -- Factory

	new_node_source: EL_XML_NODE_SCAN_TO_EIFFEL_OBJECT_BUILDER
			--
		do
			create Result.make ({EVENT_SOURCE})
		end

feature {NONE} -- Internal attributes

	root_builder_context: EL_EIF_OBJ_FACTORY_ROOT_BUILDER_CONTEXT


feature {NONE} -- Constants

	Root_node_name: STRING = "<NONE>"

end
