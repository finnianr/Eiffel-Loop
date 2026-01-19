note
	description: "[
		Test set for class ${EL_CREATEABLE_FROM_XPATH_MATCH_EVENTS}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-05 12:47:11 GMT (Monday 5th May 2025)"
	revision: "18"

class
	CREATEABLE_FROM_XPATH_MATCH_EVENTS_TEST_SET

inherit
	READ_DATA_EQA_TEST_SET
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
			do_test ("create_bioinfo", 4142905961, agent create_bioinfo, ["bioinfo.xml"])
			do_test ("create_smil", 1820761195, agent create_smil, ["linguistic-analysis.smil"])
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
			do_test ("create_xhtml", 309870796, agent create_xhtml, ["Hexagrams.html"])
			do_test ("create_xhtml", 3435591434, agent create_xhtml, ["Hexagrams.utf8.html"])
		end

feature {NONE} -- Implementation

	create_bioinfo (name: STRING)
			--
		local
			events: BIOINFO_XPATH_MATCH_EVENTS
		do
			create events.make_from_file (Data_dir.vtd_xml + name)
		end

	create_smil (name: STRING)
			--
		local
			events: SMIL_XPATH_MATCH_EVENTS; creatable_dir: DIR_PATH
		do
			creatable_dir := Data_dir.xml #+ "creatable"
			create events.make_from_file (creatable_dir + name)
		end

	create_xhtml (name: STRING)
			--
		local
			matcher: EL_DOCUMENT_NODE_XPATH_MATCHER; title: ZSTRING; paragraph_count: INTEGER_REF
			XHTML_match_events: ARRAY [EL_XPATH_TO_AGENT_MAP]; file_path: FILE_PATH
		do
			create title.make_empty; create paragraph_count
			file_path := Data_dir.xml + name

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
			lio.put_string_field ("content", last_node.adjusted (False).as_canonically_spaced)
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