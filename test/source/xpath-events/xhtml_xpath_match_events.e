note
	description: "Summary description for {XHTML_XPATH_MATCH_EVENTS}."

	notes: "[
		Error processing ISO-8859-15 encoding

		http://sourceforge.net/p/expat/bugs/498/

		Expat does not support iso-8859-15. It only supports UTF-8, UTF-16, ISO-8859-1, and US-ASCII.
		The XML specification does not require an XML parser to support anything else.
		Your best bet is to convert the document to UTF-8 or UTF-16.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 18:45:34 GMT (Wednesday 16th December 2015)"
	revision: "6"

class
	XHTML_XPATH_MATCH_EVENTS

inherit
	EL_CREATEABLE_FROM_XPATH_MATCH_EVENTS

	EL_MODULE_LOG

create
	make_from_file

feature {NONE} -- Initialization

	make_default
			--
		do
			create title.make_empty
		end

feature -- Access

	paragraph_count: INTEGER

	title: ZSTRING

feature {NONE} -- XPath match event handlers

	on_title
		do
			title := last_node.to_string
		end

	on_paragraph
		do
			paragraph_count := paragraph_count + 1
		end

feature {NONE} -- Implementation

	xpath_match_events: ARRAY [like Type_agent_mapping]
			--
		do
			Result := <<
				-- Fixed paths
--				[on_open, "/html/head/title/text()", agent do title := last_node.to_string end],
				[on_open, "/html/head/title/text()", agent on_title],

				-- Wild card paths
--				[on_open, "//p", agent do paragraph_count := paragraph_count + 1 end]
				[on_open, "//p", agent on_paragraph]
			>>
		end

end