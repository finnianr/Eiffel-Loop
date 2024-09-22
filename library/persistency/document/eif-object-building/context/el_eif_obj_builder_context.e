note
	description: "Eiffel object model Xpath context"
	notes: "[
		By default the building actions defined by deferred routine `building_action_table'
		are cached in `Building_actions_by_type'. Redefine `actions_cached' if you do not
		want the actions to be cached.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 14:07:13 GMT (Sunday 22nd September 2024)"
	revision: "26"

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
			{EL_DOCUMENT_NODE_SCAN_SOURCE} Empty_string -- For precondition
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor {EL_EIF_OBJ_XPATH_CONTEXT}
			if actions_cached then
				building_actions := Building_actions_by_type.item (Current)
			else
				building_actions := new_building_actions
			end
		end

feature {EL_EIF_OBJ_BUILDER_CONTEXT} -- Basic operations

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

feature {EL_EIF_OBJ_BUILDER_CONTEXT} -- Element change

	modify_xpath_to_select_element_by_attribute_value
			-- Change xpath from: /AAA/BBB/@name to: /AAA/BBB[@name='x']/@name
			-- where x is the current value of @name
			-- (method does not require any new string to be created)
		require
			valid_xpath: is_xpath_attribute
			xpath_has_at_least_one_element: xpath_has_at_least_one_element
		local
			index_at, name_count: INTEGER
		do
			index_at := xpath.last_index_of ('@', xpath.count)
			name_count := xpath.count - index_at

			if index_at - 1 > 0 then
				xpath [index_at - 1] := '['
			else
				xpath.insert_character ('[', index_at)
				index_at := index_at + 1
			end
			xpath.append (Equal_to_literal) -- ='']
			xpath.insert_string (node.adjusted_8 (False), xpath.count - 1)

			-- First trying applying match action for: /AAA/BBB[@name='x']
			apply_building_action_for_xpath

			xpath.append_character ('/')
			xpath.append_substring (xpath, index_at, index_at + name_count) -- /AAA/BBB[@name='x']/@name

		end

feature {EL_EIF_OBJ_BUILDER_CONTEXT} -- Factory

	new_building_actions: like building_actions
		local
			action_table: like building_action_table
		do
			action_table := building_action_table
			action_table.compare_objects
			add_builder_actions_for_xpaths_selectors (action_table)

			create Result.make_equal (action_table.count)
			from action_table.start until action_table.after loop
				Result.extend (action_table.item_for_iteration , action_table.key_for_iteration.as_string_32)
				action_table.forth
			end
		end

feature {EL_DOCUMENT_CLIENT} -- Implementation attributes

	building_actions: EL_PROCEDURE_TABLE [STRING] note option: transient attribute end

feature {NONE} -- Implementation

	actions_cached: BOOLEAN
		-- is the `building_action_table' to be cached in `PI_building_actions_by_type'
		do
			Result := True
		end

	add_builder_actions_for_xpaths_selectors (a_building_actions: like building_actions)
		-- add builder actions for xpaths containing attribute value predicates
		-- /AAA/BBB[@name='x']/@name
		do
			if attached XPath_parser as parser then
				across a_building_actions.key_list as key_list loop
					parser.set_source_text (key_list.item)
					parser.parse

					if parser.path_contains_attribute_value_predicate and then
						attached xpaths_ending_with_attribute_value_predicate (parser.step_list) as xpath_list
					then
						across xpath_list as list loop
							if attached list.item as l_xpath then
								a_building_actions.put (agent modify_xpath_to_select_element_by_attribute_value, l_xpath)
							end
						end
					end
				end
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

	Building_actions_by_type: EL_FUNCTION_RESULT_TABLE [EL_EIF_OBJ_BUILDER_CONTEXT, EL_PROCEDURE_TABLE [STRING]]
		-- cache table for building actions defined by `building_action_table' for each conforming type
		once
			create Result.make (17, agent {EL_EIF_OBJ_BUILDER_CONTEXT}.new_building_actions)
		end

	XPath_parser: EL_XPATH_PARSER
			--
		once
			create Result.make
		end

	Equal_to_literal: STRING = "='']"

end