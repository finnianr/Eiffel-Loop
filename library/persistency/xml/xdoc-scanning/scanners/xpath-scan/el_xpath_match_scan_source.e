note
	description: "Class for parsing XML documents and matching sets of xpaths"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-15 10:30:58 GMT (Monday 15th May 2017)"
	revision: "4"

class
	EL_XPATH_MATCH_SCAN_SOURCE

inherit
	EL_XML_NODE_SCAN_SOURCE
		rename
			seed_object as target_object,
			set_seed_object as set_target_object
		redefine
			make_default, target_object, set_target_object
		end

	EL_MODULE_LIO

create
	make

feature {NONE}  -- Initialisation

	make_default
			--
		do
			Precursor
			create xpath_step_lookup
			create last_node_xpath.make (xpath_step_lookup)
			create node_START_procedure_lookup.make (23)
			create node_END_procedure_lookup.make (23)
			create node_START_wildcard_xpath_search_term_list.make
			create node_END_wildcard_xpath_search_term_list.make
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
			on_content
		end

	on_content
			--
		do
			last_node_xpath.append_step (last_node.xpath_name)
			call_any_matching_procedures (node_START_procedure_lookup, node_START_wildcard_xpath_search_term_list)
			last_node_xpath.remove
		end

	on_end_document
			--
		do
			reset
		end

	on_end_tag
			--
		do
			call_any_matching_procedures (node_END_procedure_lookup, node_END_wildcard_xpath_search_term_list)
			last_node_xpath.remove
		end

	on_processing_instruction
			--
		do
		end

	on_start_document
			--
		do
		end

	on_start_tag
			--
		local
			element_node: like last_node
		do
			last_node_xpath.append_step (last_node_name)
			call_any_matching_procedures (node_START_procedure_lookup, node_START_wildcard_xpath_search_term_list)

			if not attribute_list.is_empty then
				element_node := last_node
				from attribute_list.start until attribute_list.after loop
					last_node := attribute_list.node
					target_object.set_last_node (attribute_list.node)

					on_content
					attribute_list.forth
				end
				last_node := element_node
				target_object.set_last_node (element_node)
			end
		end

	on_xml_tag_declaration (version: REAL; encodeable: EL_ENCODEABLE_AS_TEXT)
			--
		do
		end

feature {NONE} -- Implementation

	reset
		do
			xpath_step_lookup.wipe_out
			last_node_xpath.wipe_out
			node_START_procedure_lookup.wipe_out
			node_END_procedure_lookup.wipe_out
			node_START_wildcard_xpath_search_term_list.wipe_out
			node_END_wildcard_xpath_search_term_list.wipe_out
		end

feature {NONE} -- Internal attributes

	last_node_id: INTEGER_16

	last_node_xpath: EL_TOKENIZED_XPATH

	node_END_procedure_lookup: like node_START_procedure_lookup

	node_END_wildcard_xpath_search_term_list: like node_START_wildcard_xpath_search_term_list

	node_START_procedure_lookup: HASH_TABLE [PROCEDURE [ANY, TUPLE], EL_TOKENIZED_XPATH]

	node_START_wildcard_xpath_search_term_list: LINKED_LIST [EL_TOKENIZED_XPATH]

	target_object: EL_CREATEABLE_FROM_XPATH_MATCH_EVENTS [EL_PARSE_EVENT_SOURCE]

	xpath_step_lookup: EL_XPATH_TOKEN_TABLE

feature {NONE} -- Xpath matching operations

	add_node_action_to_procedure_lookup (
		node_procedure_lookup: like node_START_procedure_lookup;
		wildcard_search_term_list: LINKED_LIST [EL_TOKENIZED_XPATH]
		node_action: EL_XPATH_TO_AGENT_MAP
	)
			--
		local
			xpath: EL_TOKENIZED_XPATH
		do
			create xpath.make (xpath_step_lookup)
			xpath.append_xpath (node_action.xpath)

			-- if xpath of form: //AAA/* or /AAA/* or //AAA
			if xpath.has_wild_cards then
				wildcard_search_term_list.extend (xpath)
			end
			node_procedure_lookup.put (node_action.action, xpath)

			debug ("EL_XPATH_MATCH_SCAN_SOURCE")
				if node_procedure_lookup = node_START_procedure_lookup then
					lio.put_string_field ("Xpath on_node_start", node_action.xpath)
				else
					lio.put_string_field ("Xpath on_node_end", node_action.xpath)
				end
				lio.put_new_line
				lio.put_string_field ("Tokenized xpath", xpath.out)
				lio.put_new_line
				lio.put_new_line
			end
		end

	call_any_matching_procedures (
		procedure_lookup: like node_START_procedure_lookup;
		wildcard_search_term_list: like node_START_wildcard_xpath_search_term_list
	)
			--
		do
			debug ("EL_XPATH_MATCH_SCAN_SOURCE")
				lio.put_string_field ("Xpath current node ", last_node_xpath.out)
				lio.put_new_line
			end
			-- first try and match full path
			procedure_lookup.search (last_node_xpath)
			if procedure_lookup.found then

				procedure_lookup.found_item.call ([])
			end
			from wildcard_search_term_list.start until wildcard_search_term_list.off loop
				if last_node_xpath.matches_wildcard (wildcard_search_term_list.item) then
					procedure_lookup.search (wildcard_search_term_list.item)
					if procedure_lookup.found then
						procedure_lookup.found_item.call ([])
					end
				end
				wildcard_search_term_list.forth
			end
		end

	fill_xpath_action_table (agent_map_array: ARRAY [EL_XPATH_TO_AGENT_MAP])
			--
		local
			i: INTEGER
		do
			from i := 1 until i > agent_map_array.count loop
				if agent_map_array.item (i).is_applied_to_open_element then
					add_node_action_to_procedure_lookup (
						node_START_procedure_lookup, node_START_wildcard_xpath_search_term_list, agent_map_array.item (i)
					)
				else
					add_node_action_to_procedure_lookup (
						node_END_procedure_lookup, node_END_wildcard_xpath_search_term_list, agent_map_array.item (i)
					)
				end
				i := i + 1
			end
		end

end
