note
	description: "[
		Test set for class ${EL_CREATEABLE_FROM_XPATH_MATCH_EVENTS}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "15"

class
	CREATEABLE_FROM_XPATH_MATCH_EVENTS_TEST_SET

inherit
	EIFFEL_LOOP_TEST_SET
		undefine
			new_lio
		end

	EL_CRC_32_TESTABLE

	EL_NODE_CONSTANTS undefine default_create end

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["createable_from_xpath_match_events",	agent test_createable_from_xpath_match_events],
				["document_node_xpath_matcher",			agent test_document_node_xpath_matcher]
			>>)
		end

feature -- Tests

	test_createable_from_xpath_match_events
		note
			testing: "covers/{EL_CREATEABLE_FROM_XPATH_MATCH_EVENTS}.build_from_file"
		do
			do_test ("create_bioinfo", 674821716, agent create_bioinfo, [])
			do_test ("create_smil", 496710526, agent create_smil, [])
		end

	test_document_node_xpath_matcher
		-- CREATEABLE_FROM_XPATH_MATCH_EVENTS_TEST_SET.test_document_node_xpath_matcher
		note
			testing: "[
				covers/{EL_DOCUMENT_NODE_XPATH_MATCHER}.scan_document,
				covers/{EL_EXPAT_XHTML_PARSER}.parse_string_and_set_error,
				covers/{EL_HTML_ROUTINES}.to_xml
			]"
		do
			do_test ("create_xhtml", 4188040180, agent create_xhtml, ["XML/Hexagrams.html"])
			do_test ("create_xhtml", 656333874, agent create_xhtml, ["XML/Hexagrams.utf8.html"])
		end

feature {NONE} -- Implementation

	create_bioinfo
			--
		local
			events: BIOINFO_XPATH_MATCH_EVENTS
		do
			create events.make_from_file ("vtd-xml/bioinfo.xml")
		end

	create_smil
			--
		local
			events: SMIL_XPATH_MATCH_EVENTS
		do
			create events.make_from_file ("XML/creatable/linguistic-analysis.smil")
		end

	create_xhtml (file_path: STRING)
			--
		local
			matcher: EL_DOCUMENT_NODE_XPATH_MATCHER
			title: ZSTRING; paragraph_count: INTEGER_REF
			XHTML_match_events: ARRAY [EL_XPATH_TO_AGENT_MAP]
		do
			create title.make_empty; create paragraph_count

			XHTML_match_events := <<
				-- Fixed paths
				[on_open, "/html/head/title/text()", agent on_title (?, title)],
				[on_open, "/html/head/meta/@content", agent on_meta_content],
				[on_open, "/html/body/h2/text()", agent on_heading],

				-- Wild card paths
				[on_open, "//p", agent on_paragraph (?, paragraph_count)]
			>>
			create matcher.make ({EL_EXPAT_XHTML_PARSER}, XHTML_match_events)
			matcher.scan_document (file_path)

			lio.put_string_field ("Title", title)
			lio.put_new_line
			lio.put_integer_field ("Paragraph count", paragraph_count.item)
			lio.put_new_line
		end

feature {NONE} -- XPath match event handlers

	on_heading (last_node: EL_DOCUMENT_NODE_STRING)
		do
			lio.put_string_field ("h2/text()", last_node.to_string)
			lio.put_new_line
		end

	on_meta_content (last_node: EL_DOCUMENT_NODE_STRING)
		do
			lio.put_string_field ("content", last_node.to_string.as_canonically_spaced)
			lio.put_new_line
		end

	on_paragraph (last_node: EL_DOCUMENT_NODE_STRING; count: INTEGER_REF)
		do
			count.set_item (count.item + 1)
		end

	on_title (last_node: EL_DOCUMENT_NODE_STRING; title: ZSTRING)
		do
			last_node.set (title)
		end

end