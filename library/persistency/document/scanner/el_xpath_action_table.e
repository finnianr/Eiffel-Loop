note
	description: "[
		Agent actions to be applied on each match of a tokenized xpath ${EL_TOKENIZED_XPATH} 
		while scanning a document object conforming to ${EL_XPATH_MATCH_SCAN_SOURCE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "3"

class
	EL_XPATH_ACTION_TABLE

inherit
	HASH_TABLE [EL_XPATH_TO_AGENT_MAP, EL_TOKENIZED_XPATH]

	EL_MODULE_LIO

create
	make


feature -- Basic operations

	call_any_matching_procedures (
		node: EL_DOCUMENT_NODE_STRING; last_node_xpath: EL_TOKENIZED_XPATH; list: ARRAYED_LIST [EL_TOKENIZED_XPATH]
	)
			--
		local
			i: INTEGER
		do
			debug ("EL_XPATH_MATCH_SCAN_SOURCE")
				lio.put_string_field ("Xpath current node ", last_node_xpath.out)
				lio.put_new_line
			end
			-- first try and match full path
			if has_key (last_node_xpath) then
				found_item.apply (node)
			end
			if attached list.area as area then
				from until i = area.count loop
					if attached area [i] as xpath and then last_node_xpath.matches_wildcard (xpath) then
						if has_key (xpath) then
							found_item.apply (node)
						end
					end
					i := i + 1
				end
			end
		end

feature -- Element change

	add_node_action (
		xpath: EL_TOKENIZED_XPATH; search_term_list: ARRAYED_LIST [EL_TOKENIZED_XPATH]
		node_action: EL_XPATH_TO_AGENT_MAP
	)
			-- fill `search_term_list'
		do
			-- if xpath of form: //AAA/* or /AAA/* or //AAA
			if xpath.has_wild_cards then
				search_term_list.extend (xpath)
			end
			put (node_action, xpath)

			debug ("EL_XPATH_MATCH_SCAN_SOURCE")
--				if Current = node_START_action_table then
--					lio.put_string_field ("Xpath on_node_start", node_action.xpath)
--				else
--					lio.put_string_field ("Xpath on_node_end", node_action.xpath)
--				end
				lio.put_new_line
				lio.put_string_field ("Tokenized xpath", xpath.out)
				lio.put_new_line
				lio.put_new_line
			end
		end

end