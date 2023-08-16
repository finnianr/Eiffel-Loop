note
	description: "[
		Map xpath node matches of XML/Pyxis document to [$source EL_XPATH_TO_AGENT_MAP] handlers
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-23 16:21:21 GMT (Sunday 23rd July 2023)"
	revision: "1"

class
	EL_DOCUMENT_NODE_XPATH_MATCHER

inherit
	EL_CREATEABLE_FROM_XPATH_MATCH_EVENTS
		rename
			build_from_file as scan_document,
			make_default as do_nothing
		export
			{NONE} all
			{ANY} scan_document
		end

create
	make

feature {NONE} -- Initialization

	make (a_parse_event_source_type: TYPE [EL_PARSE_EVENT_SOURCE]; match_events: ITERABLE [EL_XPATH_TO_AGENT_MAP])
		do
			parse_event_source_type := a_parse_event_source_type
			xpath_match_events := match_events
		end

feature {NONE} -- Internal attributes

	parse_event_source_type: TYPE [EL_PARSE_EVENT_SOURCE]

	xpath_match_events: ITERABLE [EL_XPATH_TO_AGENT_MAP]

end