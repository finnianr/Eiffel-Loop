note
	description: "Summary description for {XHTML_XPATH_MATCH_EVENTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:09:44 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	XHTML_XPATH_MATCH_EVENTS

inherit
	EL_CREATEABLE_FROM_XPATH_MATCH_EVENTS
		redefine
			make
		end

	EL_MODULE_LOG

create
	make_from_file

feature {NONE} -- Initialization

	make
			--
		do
			create title.make_empty
		end

feature -- Access

	paragraph_count: INTEGER

	title: EL_ASTRING

feature {NONE} -- Implementation

	xpath_match_events: ARRAY [like Type_agent_mapping]
			--
		do
			Result := <<
				-- Fixed paths
				["/html/head/title/text()", on_node_start, agent do title.copy (last_node.to_string) end],

				-- Wild card paths
				["//p", on_node_start, agent do paragraph_count := paragraph_count + 1 end]
			>>
		end

end