note
	description: "Eif obj root builder context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-07 15:22:02 GMT (Tuesday 7th January 2020)"
	revision: "8"

class
	EL_EIF_OBJ_ROOT_BUILDER_CONTEXT

inherit
	EL_EIF_OBJ_BUILDER_CONTEXT

create
	make

feature {NONE} -- Initialization

	make (a_root_node_xpath: STRING; a_target: like target)
			--
		do
			make_default
			building_actions := new_building_actions
			root_node_xpath := a_root_node_xpath
			target := a_target
			reset
		end

feature -- Element change

	reset
			--
		do
			xpath.wipe_out
			building_actions.wipe_out
			building_actions.extend (agent set_top_level_context, root_node_xpath)
			add_process_instruction_actions (target.pi_building_actions)
		end

	set_root_node_xpath (a_root_node_xpath: STRING)
			--
		do
			root_node_xpath := a_root_node_xpath
		end

	set_target (a_target: like target)
		-- set target object to build from XML
		do
			target := a_target
			building_actions.extend (agent set_top_level_context, a_target.root_node_name)
			add_process_instruction_actions (target.pi_building_actions)
		end

feature -- Access

	target: EL_BUILDABLE_FROM_NODE_SCAN
		-- Target object to build from XML

feature {NONE} -- Implementation

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			create Result
		end

	call_process_instruction_action (pi_action: PROCEDURE)
			--
		do
			pi_action.set_target (target)
			pi_action (node.to_string)
		end

	add_process_instruction_actions (pi_action_table: like building_actions)
			-- extend `building_actions' with processing instruction actions
		do
			across pi_action_table as action loop
				building_actions.put (agent call_process_instruction_action (action.item), PI_template #$ [action.key])
			end
		end

	root_node_xpath: STRING_32

	set_top_level_context
			--
		do
			set_next_context (target)
		end

feature {NONE} -- Constants

	PI_template: ZSTRING
		once
			Result := "processing-instruction('%S')"
		end

end
