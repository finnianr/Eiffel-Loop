note
	description: "[
		Object that scans an XML node event source, matching visited nodes against a user defined set of xpaths.
		Matching nodes trigger a call to an agent defined in the mapping function `xpath_match_events'. The agent can
		process the visited node by accessing the `last_node' attribute. Although only a tiny subset of the xpath
		standard is implemented, it is still quite useful as this rudimentary XHTML renderer,
		[http://www.eiffel-loop.com/library/graphic/toolkit/html-viewer/el_html_text.html EL_HTML_TEXT], illustrates.
		
		The following xpath to agent map is from the example class
		[http://www.eiffel-loop.com/test/source/xpath-events/bioinfo_xpath_match_events.html BIOINFO_XPATH_MATCH_EVENTS].
		The first mapping argument `on_open' or `on_close' applies only to element nodes and specifies whether to call 
		the agent when the element open tag or closing tag is encountered.
	
			xpath_match_events: ARRAY [EL_XPATH_TO_AGENT_MAP]
					--
				do
					Result := <<
						-- Fixed paths
						[on_open, "/bix/package/env/text()", agent on_package_env],
						[on_open, "/bix/package/command/action/text()", agent on_command_action],
						[on_open, "/bix/package/command/parlist/par/value/@type", agent on_parameter_list_value_type],
						[on_open, "/bix/package/command/parlist/par/value/text()", agent on_parameter_list_value],

						[on_close, "/bix", agent log_results], -- matches only when closing tag encountered

						-- Wildcard paths
						[on_open, "//par/value/*", agent on_parameter_data_value_field],
						[on_open, "//label/text()", agent on_label],
						[on_open, "//label", agent increment (label_count)],
						[on_open, "//par/id", agent increment (par_id_count)],

						[on_open, "//par/id/text()", agent on_par_id]
					>>
				end
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-14 11:51:49 GMT (Sunday 14th May 2017)"
	revision: "2"

deferred class
	EL_CREATEABLE_FROM_XPATH_MATCH_EVENTS [EVENT_SOURCE -> EL_PARSE_EVENT_SOURCE]

inherit
	EL_CREATEABLE_FROM_NODE_SCAN
		rename
			node_source as node_match_source
		end

feature {EL_XPATH_MATCH_SCAN_SOURCE} -- Implementation

	new_node_source: EL_XPATH_MATCH_SCAN_SOURCE
		do
			create Result.make ({EVENT_SOURCE})
		end

	set_last_node (node: EL_XML_NODE)
			--
		do
			last_node := node
		end

	xpath_match_events: ARRAY [EL_XPATH_TO_AGENT_MAP]
			--
		deferred
		end

feature {NONE} -- Internal attributes

	last_node: EL_XML_NODE

feature {NONE} -- Constants

	on_close: BOOLEAN = false

	on_open: BOOLEAN = true

end

