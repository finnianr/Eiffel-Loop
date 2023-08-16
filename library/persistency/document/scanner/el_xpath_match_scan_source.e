note
	description: "[
		Class for scanning document nodes and checking if each node path matches against
		a set of xpath expressions, each mapped to procedure. If a node matches, the procedure
		is called.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-13 13:43:25 GMT (Sunday 13th August 2023)"
	revision: "17"

class
	EL_XPATH_MATCH_SCAN_SOURCE

inherit
	EL_DOCUMENT_NODE_SCAN_SOURCE
		rename
			seed_object as target_object,
			set_seed_object as set_target_object
		redefine
			make_default, target_object, set_target_object
		end

	EL_MODULE_LIO

	EL_NODE_CONSTANTS; EL_STRING_8_CONSTANTS; EL_XPATH_NODE_CONSTANTS

create
	make

feature {NONE}  -- Initialisation

	make_default
			--
		do
			Precursor
			create last_node_xpath.make

			create action_table.make_empty (2)
			from until action_table.count = 2 loop
				action_table.extend (create {EL_XPATH_ACTION_TABLE}.make (23))
			end

			create wildcard_xpath_search_term_list.make_empty (2)
			from until wildcard_xpath_search_term_list.count = 2 loop
				wildcard_xpath_search_term_list.extend (create {ARRAYED_LIST [EL_TOKENIZED_XPATH]}.make (5))
			end
		end

feature -- Element change

	set_target_object (a_target_object: like target_object)
			--
		do
			Precursor (a_target_object)
			target_object.set_last_node (last_node)
			fill_xpath_action_table (target_object.xpath_match_events)
		end

feature {NONE} -- Parsing events

	on_comment
			--
		do
			on_content (last_node)
		end

	on_content (node: EL_DOCUMENT_NODE_STRING)
			--
		do
			if attached last_node_xpath as xpath then
				xpath.append_step (node.raw_name, node.type)
				action_table [Node_START].call_any_matching_procedures (
					node, xpath, wildcard_xpath_search_term_list [Node_START]
				)
				xpath.remove
			end
		end

	on_end_document
			--
		do
			reset
		end

	on_end_tag
			--
		do
			action_table [Node_END].call_any_matching_procedures (
			 	last_node, last_node_xpath, wildcard_xpath_search_term_list [Node_END]
			)
			last_node_xpath.remove
		end

	on_processing_instruction
			--
		do
			last_node_xpath.append_step (last_node.raw_name, last_node.type)
			action_table [Node_START].call_any_matching_procedures (
				last_node, last_node_xpath, wildcard_xpath_search_term_list [Node_START]
			)
			last_node_xpath.remove
			last_node_xpath.remove
		end

	on_start_document
			--
		do
		end

	on_start_tag
			--
		local
			i: INTEGER
		do
			last_node_xpath.append_step (last_node.raw_name, Type_element)
			action_table [Node_START].call_any_matching_procedures (
				last_node, last_node_xpath, wildcard_xpath_search_term_list [Node_START]
			)
			if attached attribute_list.area as area and then area.count > 0 then
				from until i = area.count loop
					if attached area [i] as node then
						target_object.set_last_node (area [i])
						on_content (node)
					end
					i := i + 1
				end
				target_object.set_last_node (last_node)
			end
		end

feature {NONE} -- Implementation

	reset
		do
			last_node_xpath.wipe_out
			across action_table as table loop
				table.item.wipe_out
			end
			across wildcard_xpath_search_term_list as list loop
				list.item.wipe_out
			end
		end

feature {EL_TOKENIZED_XPATH} -- Internal attributes

	last_node_id: INTEGER_16

	last_node_xpath: EL_TOKENIZED_XPATH

	action_table: SPECIAL [EL_XPATH_ACTION_TABLE]
		-- for `Node_START' and `Node_END'

	wildcard_xpath_search_term_list: SPECIAL [ARRAYED_LIST [EL_TOKENIZED_XPATH]]
		-- for `Node_START' and `Node_END'

	target_object: EL_CREATEABLE_FROM_XPATH_MATCH_EVENTS

feature {NONE} -- Xpath matching operations

	fill_xpath_action_table (agent_map_list: ITERABLE [EL_XPATH_TO_AGENT_MAP])
			--
		local
			i: INTEGER; xpath: EL_TOKENIZED_XPATH
		do
			across agent_map_list as list loop
				if attached list.item as map then
					if map.is_applied_to_open_element then
						i := Node_START
					else
						i := Node_END
					end
					create xpath.make
					xpath.append_xpath (map.xpath)

					action_table [i].add_node_action (xpath, wildcard_xpath_search_term_list [i], map)
				end
			end
		end
end