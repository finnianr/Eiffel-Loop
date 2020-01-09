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
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-09 15:05:42 GMT (Thursday 9th January 2020)"
	revision: "3"

class
	EL_SMART_EIF_OBJ_ROOT_BUILDER_CONTEXT

inherit
	EL_EIF_OBJ_ROOT_BUILDER_CONTEXT
		redefine
			make
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

feature {NONE} -- Initialization

	make (a_root_node_xpath: STRING; a_target: like target)
		do
			Precursor (a_root_node_xpath, a_target)
			building_actions.extend (agent set_target_from_processing_instruction, Xpath_processing_instruction_create)
		end

feature {NONE} -- Implementation

	set_target_from_processing_instruction
		local
			class_type: STRING_8; result_stack: ARRAYED_STACK [EL_BUILDABLE_FROM_NODE_SCAN]
		do
			class_type := node.to_string.to_latin_1
			String_8.remove_bookends (class_type, once "{}")
			if Factory.valid_type (class_type)
				and then attached {EL_SMART_BUILDABLE_FROM_NODE_SCAN} target as smart_buildable
			then
				result_stack := smart_buildable.result_stack
				target := Factory.instance_from_class_name (class_type, agent {EL_BUILDABLE_FROM_NODE_SCAN}.make_default)
				building_actions [target.root_node_name] := agent set_top_level_context
				result_stack.wipe_out; result_stack.put (target)
				target.set_node (node)
				across target.pi_building_actions as action loop
					if action.key ~ PI_create then
						call_target_pi_action (action.item)
					else
						building_actions [Pi_template #$ [action.key]] := agent call_target_pi_action (action.item)
					end
				end
			end
		end

feature {NONE} -- Constants

	Factory: EL_OBJECT_FACTORY [EL_BUILDABLE_FROM_NODE_SCAN]
		once
			create Result
		end

	PI_create: STRING_32 = "create"

	Xpath_processing_instruction_create: STRING_32
		once
			Result := Pi_template #$ [Pi_create]
		end

end

