note
	description: ""

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_EIF_OBJ_ROOT_BUILDER_CONTEXT

inherit
	EL_EIF_OBJ_BUILDER_CONTEXT
		rename
			make as make_context
		end

create
	make

feature {NONE} -- Initialization

	make (a_root_node_xpath: STRING; a_target: like target)
			--
		do
			create xpath.make_empty
			building_actions := create_building_actions

			root_node_xpath := a_root_node_xpath
			target := a_target
			reset
		end

feature -- Element change

	set_target (a_target: like target)
		-- set target object to build from XML
		do
			target := a_target
		end

	set_root_node_xpath (a_root_node_xpath: STRING)
			--
		do
			root_node_xpath := a_root_node_xpath
		end

	reset
			--
		do
			xpath.wipe_out
			building_actions.wipe_out
			building_actions.extend (agent set_top_level_context, root_node_xpath)
			extend_building_actions_from_root_PI_actions
		end

feature -- Access

	target: EL_BUILDABLE_FROM_XML
		-- Target object to build from XML

feature {NONE} -- Implementation

	extend_building_actions_from_root_PI_actions
			-- extend building_actions with processing instruction actions defined in target object to build
		local
			PI_building_actions: like building_actions
		do
			PI_building_actions := target.PI_building_actions
			from PI_building_actions.start until PI_building_actions.after loop
				building_actions.put (
					agent call_process_instruction_action (PI_building_actions.item_for_iteration),
					PI_building_actions.key_for_iteration
				)
				PI_building_actions.forth
			end
		end

	set_top_level_context
			--
		do
			set_next_context (target)
		end

	call_process_instruction_action (pi_action: PROCEDURE [EL_EIF_OBJ_BUILDER_CONTEXT, TUPLE])
			--
		do
			pi_action.set_target (target)
			pi_action.call ([node.to_string])
		end

	building_action_table: like Type_building_actions
			--
		do
			create Result
		end

	root_node_xpath: STRING_32

end
