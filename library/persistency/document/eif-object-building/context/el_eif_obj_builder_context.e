note
	description: "Eiffel object model Xpath context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-02 13:41:18 GMT (Saturday 2nd January 2021)"
	revision: "12"

deferred class
	EL_EIF_OBJ_BUILDER_CONTEXT

inherit
	EL_EIF_OBJ_XPATH_CONTEXT
		rename
			do_with_xpath as apply_building_action_for_xpath
		redefine
			make_default
		end

	EL_ZSTRING_CONSTANTS
		export
			{EL_XML_NODE_SCAN_SOURCE} Empty_string -- For precondition
		end

feature {EL_SETTABLE_FROM_XML_NODE} -- Initialization

	make_default
			--
		do
			Precursor {EL_EIF_OBJ_XPATH_CONTEXT}
			building_actions := Building_actions_by_type.item (Current)
		end

feature -- Basic operations

	apply_building_action_for_xpath
			-- Apply building action if xpath has one assigned
		local
			build_action: PROCEDURE
		do
			if building_actions.has_key (xpath) then
				build_action := building_actions.found_item
				check -- have all the arguments been specified
					no_open_arguments: build_action.open_count = 0
				end
				build_action.set_target (Current)
				build_action.apply
			end
		end

feature -- Element change

	modify_xpath_to_select_element_by_attribute_value
			-- Change xpath from: /AAA/BBB/@name to: /AAA/BBB[@name='x']/@name
			-- where x is the current value of @name
		require
			valid_xpath: is_xpath_attribute
			xpath_has_at_least_one_element: xpath_has_at_least_one_element
		local
			separator_pos: INTEGER; attribute_name: ZSTRING
		do
			separator_pos := xpath.last_index_of (xpath_step_separator, xpath.count)
			attribute_name := xpath.substring (separator_pos + 1, xpath.count)
			remove_xpath_step
			xpath.append_character ('[')
			xpath.append (attribute_name)
			xpath.append_string_general ("='")
			xpath.append (node.to_string)
			xpath.append_string_general ("']")

			-- In case /AAA/BBB[@name='x'] has an action assigned to it
			apply_building_action_for_xpath
			add_xpath_step (attribute_name)
		end

	refresh_building_actions
			-- Cause the building actions to be revaluated
			-- Useful if a building action xpath depends on class instance variable
		do
			Building_actions_by_type.remove (Current)
			building_actions := Building_actions_by_type.item (Current)
		end

feature {EL_EIF_OBJ_BUILDER_CONTEXT} -- Factory

	new_building_actions: like building_actions
		local
			action_table: like building_action_table
		do
			action_table := building_action_table
			action_table.compare_objects
			add_builder_actions_for_xpaths_containing_attribute_value_predicates (action_table)

			create Result.make (action_table.count)
			Result.compare_objects
			from action_table.start until action_table.after loop
				Result.extend (action_table.item_for_iteration , action_table.key_for_iteration.as_string_32)
				action_table.forth
			end
		end

feature {EL_EIF_OBJ_ROOT_BUILDER_CONTEXT} -- Implementation attributes

	building_actions: HASH_TABLE [PROCEDURE, ZSTRING]

feature {EL_XML_NODE_SCAN_SOURCE} -- Implementation

	add_builder_actions_for_xpaths_containing_attribute_value_predicates (a_building_actions: EL_PROCEDURE_TABLE [STRING])
			--
		local
			xpath_array: ARRAY [STRING]
			i: INTEGER
		do
			xpath_array := a_building_actions.current_keys
			from i := 1 until i > xpath_array.count loop
				XPath_parser.set_source_text (xpath_array [i])
				XPath_parser.parse

				if XPath_parser.path_contains_attribute_value_predicate then
					across xpaths_ending_with_attribute_value_predicate (XPath_parser.step_list) as xpath_to_selecting_attribute loop
						a_building_actions.put (
							agent modify_xpath_to_select_element_by_attribute_value, xpath_to_selecting_attribute.item
						)
					end
				end
				i := i + 1
			end
		end

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		deferred
		end

	call_pi_action (do_action: PROCEDURE)
		require
			valid_operands: do_action.open_count > 0 implies do_action.valid_operands ([Empty_string])
		do
			-- set appropriate target before calling
			inspect do_action.open_count
				when 1 then
					do_action (node.to_string)
				when 0 then
					do_action.apply
			else
			end
		end

	xpaths_ending_with_attribute_value_predicate (xpath_step_list: like XPath_parser.step_list): ARRAYED_LIST [STRING]
			-- list of xpaths ending attribute value predicate
			-- Eg.
			--		/AAA/BBB[@name='foo']
			--		/AAA/BBB[@name='foo']/BBB[@id='bar']
		local
			l_xpath, xpath_to_selecting_attribute: STRING; xpath_step: EL_PARSED_XPATH_STEP
		do
			create Result.make (3)
			create l_xpath.make_empty
			from xpath_step_list.start until xpath_step_list.after loop
				xpath_step := xpath_step_list.item
				if xpath_step.has_selection_by_attribute then
					create xpath_to_selecting_attribute.make_from_string (l_xpath)
					if not l_xpath.is_empty then
						xpath_to_selecting_attribute.append_character ('/')
					end
					xpath_to_selecting_attribute.append (xpath_step.element_name.to_string_8)
					xpath_to_selecting_attribute.append_character ('/')
					xpath_to_selecting_attribute.append (xpath_step.selecting_attribute_name.to_string_8)
					Result.extend (xpath_to_selecting_attribute)
				end
				if not l_xpath.is_empty then
					l_xpath.append_character ('/')
				end
				l_xpath.append (xpath_step.step.to_string_8)
				xpath_step_list.forth
			end
		end

feature {NONE} -- Constants

	Building_actions_by_type: EL_FUNCTION_RESULT_TABLE [EL_EIF_OBJ_BUILDER_CONTEXT, HASH_TABLE [PROCEDURE, ZSTRING]]
			--
		once
			create Result.make (17, agent {EL_EIF_OBJ_BUILDER_CONTEXT}.new_building_actions)
		end

	XPath_parser: EL_XPATH_PARSER
			--
		once
			create Result.make
		end

end