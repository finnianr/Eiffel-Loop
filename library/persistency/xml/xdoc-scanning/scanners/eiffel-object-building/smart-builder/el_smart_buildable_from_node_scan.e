note
	description: "[
		XML parser that reacts to a special processing instructions before the root element of the form:
		
			<?create {MY_CLASS}?>
			
		`MY_CLASS' represents an implementation of the deferred class `EL_BUILDABLE_FROM_XML' and it knows how
		to build itself from this type of document. The built object is accessible via the attribute `target'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-09 20:50:11 GMT (Saturday 9th December 2017)"
	revision: "4"

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

	make (a_parser_type: like parser_type)
			--
		do
			parser_type := a_parser_type
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

feature {NONE} -- Factory

	new_node_source: EL_XML_NODE_SCAN_TO_EIFFEL_OBJECT_BUILDER
			--
		do
			create Result.make (parser_type)
		end

feature {NONE} -- Internal attributes

	parser_type: TYPE [EL_PARSE_EVENT_SOURCE]

	root_builder_context: EL_EIF_OBJ_FACTORY_ROOT_BUILDER_CONTEXT

feature {NONE} -- Constants

	Root_node_name: STRING = "<NONE>"

end
