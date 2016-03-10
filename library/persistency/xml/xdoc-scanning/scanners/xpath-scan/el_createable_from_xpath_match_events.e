note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-01 14:29:37 GMT (Thursday 1st January 2015)"
	revision: "4"

deferred class
	EL_CREATEABLE_FROM_XPATH_MATCH_EVENTS

inherit
	EL_CREATEABLE_FROM_XML
		rename
			node_source as Node_match_source
		end

feature -- Access

	agent_map_array: ARRAY [EL_XPATH_TO_AGENT_MAP]
			--
		local
			l_xpath_match_events: like xpath_match_events
			i: INTEGER
		do
			l_xpath_match_events := xpath_match_events
			create Result.make (1, l_xpath_match_events.count)
			from i := 1 until i > l_xpath_match_events.count loop
				Result [i] := create {EL_XPATH_TO_AGENT_MAP}.make_from_tuple (l_xpath_match_events [i])
				i := i + 1
			end
		end

	xpath_match_events: ARRAY [like Type_agent_mapping]
			--
		deferred
		end

feature -- Element change

	set_last_node (node: EL_XML_NODE)
			--
		do
			last_node := node
		end

feature {NONE} -- Implementation

	last_node: EL_XML_NODE

	Node_match_source: EL_XPATH_MATCH_SCAN_SOURCE
			--
		once
			create Result.make
		end

feature {NONE} -- Anchored type declaration

	Type_agent_mapping: TUPLE [BOOLEAN, STRING, PROCEDURE [ANY, TUPLE]]
		once
		end

feature {NONE} -- Constants

	on_open: BOOLEAN = true

	on_close: BOOLEAN = false

end -- class EL_XML_EVENT_PROCESSOR

