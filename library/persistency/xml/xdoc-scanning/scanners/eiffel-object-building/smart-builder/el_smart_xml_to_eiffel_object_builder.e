note
	description: "[
		Detects the desired target type from XML processing instruction 'create {G}' 
		and sets the type of target_object to G where G is a type conforming to EL_BUILDABLE_FROM_XML. 
		Built object is made available as 'product'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-01 13:53:19 GMT (Thursday 1st January 2015)"
	revision: "4"

class
	EL_SMART_XML_TO_EIFFEL_OBJECT_BUILDER

inherit
	EL_BUILDABLE_FROM_XML
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

	target: EL_BUILDABLE_FROM_XML

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

	reset
			--
		do
			root_builder_context.set_root_node_xpath (Root_node_name)
			root_builder_context.set_target (Current)
			root_builder_context.reset
		end

	building_action_table: like Type_building_actions
			--
		do
			create Result
		end

	Root_node_name: STRING = "<NONE>"

feature {NONE} -- Globals

	root_builder_context: EL_EIF_OBJ_FACTORY_ROOT_BUILDER_CONTEXT

end
