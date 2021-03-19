note
	description: "Eiffel object root builder context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-15 10:48:58 GMT (Monday 15th March 2021)"
	revision: "11"

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
			root_node_xpath := a_root_node_xpath; target := a_target
			make_default
			building_actions.wipe_out
			building_actions.extend (agent set_top_level_context, root_node_xpath)
			across target.pi_building_actions as action loop
				building_actions.put (agent call_target_pi_action (action.item), PI_template #$ [action.key])
			end
		end

feature -- Element change

	set_root_node_xpath (a_root_node_xpath: STRING)
			--
		do
			root_node_xpath := a_root_node_xpath
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

	call_target_pi_action (do_action: PROCEDURE)
		do
			do_action.set_target (target)
			call_pi_action (do_action)
		end

	set_top_level_context
			--
		do
			set_next_context (target)
		end

feature {NONE} -- Internal attributes

	root_node_xpath: STRING_32

feature {NONE} -- Constants

	PI_template: ZSTRING
		once
			Result := "processing-instruction('%S')"
		end

end