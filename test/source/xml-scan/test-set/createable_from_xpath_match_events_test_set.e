note
	description: "[
		Test set for class [$source EL_CREATEABLE_FROM_XPATH_MATCH_EVENTS]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-26 17:42:20 GMT (Wednesday 26th July 2023)"
	revision: "11"

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
		note
			testing: "covers/{EL_DOCUMENT_NODE_XPATH_MATCHER}.scan_document"
		do
			do_test ("create_xhtml", 2030572575, agent create_xhtml, ["XML/Hexagrams.xhtml"])
			do_test ("create_xhtml", 507394204, agent create_xhtml, ["XML/Hexagrams.utf8.xhtml"])
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

				-- Wild card paths
				[on_open, "//p", agent on_paragraph (?, paragraph_count)]
			>>
			create matcher.make ({EL_EXPAT_XML_PARSER}, XHTML_match_events)
			matcher.scan_document (file_path)

			lio.put_string_field ("Title", title)
			lio.put_new_line
			lio.put_integer_field ("Paragraph count", paragraph_count.item)
			lio.put_new_line
		end

feature {NONE} -- XPath match event handlers

	on_paragraph (last_node: EL_DOCUMENT_NODE_STRING; count: INTEGER_REF)
		do
			count.set_item (count.item + 1)
		end

	on_title (last_node: EL_DOCUMENT_NODE_STRING; title: ZSTRING)
		do
			last_node.set (title)
		end

end