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
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-07 9:06:44 GMT (Wednesday 7th December 2022)"
	revision: "11"

class
	EL_SMART_EIF_OBJ_ROOT_BUILDER_CONTEXT

inherit
	EL_EIF_OBJ_ROOT_BUILDER_CONTEXT
		redefine
			make
		end

	EL_MODULE_EIFFEL

	EL_SHARED_FACTORIES

create
	make

feature {NONE} -- Initialization

	make (a_root_node_xpath: STRING; a_target: like target)
		do
			Precursor (a_root_node_xpath, a_target)
			building_actions.extend (agent on_create_target_of_type, Xpath_processing_instruction_create)
		end

feature {NONE} -- Event handling

	on_create_target_of_type
		-- handle processing instruction <?create {CLASS-NAME}?>
		-- and put result in `smart_buildable.result_stack'
		local
			class_name: STRING_8; result_stack: ARRAYED_STACK [EL_BUILDABLE_FROM_NODE_SCAN]
			target_created: BOOLEAN; s: EL_STRING_8_ROUTINES
		do
			class_name := node.to_string_8
			s.remove_bookends (class_name, once "{}")
			if attached {EL_SMART_BUILDABLE_FROM_NODE_SCAN} target as smart_buildable then
				result_stack := smart_buildable.result_stack
				result_stack.wipe_out
			else
				create result_stack.make (1)
			end
			if Makeable_factory.valid_name (class_name) then -- Classes conforming to EL_MAKEABLE
				if attached {like target} Makeable_factory.new_item_from_name (class_name) as l_target  then
					target := l_target
					target_created := True
				end
			elseif Factory.valid_name (class_name) then
				if attached Factory.new_item_from_name (class_name) as l_target then
					l_target.make_default
					target := l_target
					target_created := True
				end
			end
			if target_created then
				building_actions [target.root_node_name] := agent set_top_level_context
				result_stack.put (target)
				target.set_node (node)
				across target.pi_building_actions as action loop
					if action.key ~ PI_create then
						call_target_pi_action (action.item) -- incase target document has defined <?create <args>?>
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