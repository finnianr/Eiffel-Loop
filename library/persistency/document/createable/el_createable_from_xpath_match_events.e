note
	description: "[
		Object that scans an XML node event source, matching visited nodes against a user defined set of xpaths.
		Matching nodes trigger a call to an agent defined in the mapping function `xpath_match_events'. The agent can
		process the visited node by accessing the `last_node' attribute.
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "13"

deferred class
	EL_CREATEABLE_FROM_XPATH_MATCH_EVENTS

inherit
	EL_CREATEABLE_FROM_NODE_SCAN
		rename
			node_source as node_match_source
		redefine
			new_node_source
		end

	EL_NODE_CONSTANTS

feature {EL_XPATH_MATCH_SCAN_SOURCE} -- Implementation

	new_node_source: EL_XPATH_MATCH_SCAN_SOURCE
		do
			create Result.make (parse_event_source_type)
		end

	set_last_node (node: EL_DOCUMENT_NODE_STRING)
			--
		do
			last_node := node
		end

	xpath_match_events: ITERABLE [EL_XPATH_TO_AGENT_MAP]
			--
		deferred
		end

feature {NONE} -- Internal attributes

	last_node: EL_DOCUMENT_NODE_STRING;

note
	notes: "[
		Although only a tiny subset of the xpath standard is implemented, it is still quite useful as this rudimentary
		XHTML renderer, ${EL_HTML_TEXT}, illustrates.

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
						[on_open, "//par/va	lue/*", agent on_parameter_data_value_field],
						[on_open, "//label/text()", agent on_label],
						[on_open, "//label", agent increment (label_count)],
						[on_open, "//par/id", agent increment (par_id_count)],

						[on_open, "//par/id/text()", agent on_par_id]
					>>
				end
	]"

end