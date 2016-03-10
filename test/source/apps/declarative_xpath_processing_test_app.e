note
	description: "Summary description for {DECLARATIVE_XPATH_PROCESSING_TEST_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-07 13:12:01 GMT (Sunday 7th July 2013)"
	revision: "2"

class
	DECLARATIVE_XPATH_PROCESSING_TEST_APP

inherit
	TEST_APPLICATION
		redefine
			Option_name
		end

create
	make

feature -- Basic operations

	run
			--
		do
--			Test.do_file_test ("XML/creatable/linguistic-analysis.smil", agent test_smil, 1902646034)
--			Test.do_file_test ("vtd-xml/bioinfo.xml", agent test_bioinfo, 780707548)
--			Test.do_file_test ("XML/Hexagrams.xhtml", agent test_xhtml, 780707548)-- Doesn't work
			Test.do_file_test ("XML/Hexagrams.utf8.xhtml", agent test_xhtml, 780707548)
		end

feature -- Tests

	test_smil (file_path: EL_FILE_PATH)
			--
		local
			smil_match_events: SMIL_XPATH_MATCH_EVENTS
		do
			log.enter ("test_smil")
			create smil_match_events.make_from_file (file_path)
			log.exit
		end

	test_xhtml (file_path: EL_FILE_PATH)
			--
		local
			xhtml_match_events: XHTML_XPATH_MATCH_EVENTS
		do
			log.enter ("test_xhtml")
			create xhtml_match_events.make_from_file (file_path)
			log.put_string_field ("Title", xhtml_match_events.title)
			log.put_integer_field (" Paragraphs", xhtml_match_events.paragraph_count)
			log.put_new_line
			log.exit
		end

	test_bioinfo (file_path: EL_FILE_PATH)
			--
		local
			bioinfo_match_events: BIOINFO_XPATH_MATCH_EVENTS
		do
			log.enter ("test_bioinfo")
			create bioinfo_match_events.make_from_file (file_path)
			log.exit
		end

feature {NONE} -- Constants

	Option_name: STRING = "test_declarative_xpath"

	Description: STRING = "Test declarative xpath processing of XML document"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{DECLARATIVE_XPATH_PROCESSING_TEST_APP}, "*"],
				[{EL_TEST_ROUTINES}, "*"],
				[{EL_XPATH_MATCH_SCAN_SOURCE}, "*"],
				[{SMIL_XPATH_MATCH_EVENTS}, "*"],
				[{BIOINFO_XPATH_MATCH_EVENTS}, "*"]
			>>
		end

end
