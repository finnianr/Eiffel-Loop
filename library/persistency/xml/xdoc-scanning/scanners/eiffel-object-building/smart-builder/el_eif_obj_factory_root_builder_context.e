note
	description: "[
		Root builder context that changes the type of the target object to build according to a processing instruction
		at the start of the XML. The example below will build an instance of class `SMIL_PRESENTATION'.

			<?xml version="1.0" encoding="utf-8"?>
			<?create {SMIL_PRESENTATION}?>
			<smil xmlns="http://www.w3.org/2001/SMIL20/Language">
			..
			</smil>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-07 16:13:35 GMT (Thursday 7th July 2016)"
	revision: "1"

class
	EL_EIF_OBJ_FACTORY_ROOT_BUILDER_CONTEXT

inherit
	EL_EIF_OBJ_ROOT_BUILDER_CONTEXT
		redefine
			reset
		end

	EL_MODULE_STRING_8
		export
			{NONE} all
		end

	EL_MODULE_EIFFEL
		export
			{NONE} all
		end

create
	make

feature -- Element change

	reset
			--
		do
			Precursor
			building_actions.extend (agent set_target_from_processing_instruction, Xpath_processing_instruction_create)
		end

feature {NONE} -- Implementation

	set_target_from_processing_instruction
			--
		local
			class_type: STRING
		do
			class_type := node.to_string
			String_8.remove_bookends (class_type, "{}")

			target := Factory.instance_from_class_name (class_type, agent {EL_BUILDABLE_FROM_XML}.make_default)
			building_actions.extend (agent set_top_level_context, target.root_node_name)
			extend_building_actions_from_root_PI_actions
		end

feature {NONE} -- Implementation

	Factory: EL_OBJECT_FACTORY [EL_BUILDABLE_FROM_XML]
			--
		once
			create Result
		end

	Xpath_processing_instruction_create: STRING = "processing-instruction('create')"

end