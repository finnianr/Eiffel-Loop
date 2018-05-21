note
	description: "Declarative xpath processing test app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "5"

class
	DECLARATIVE_XPATH_PROCESSING_TEST_APP

inherit
	REGRESSION_TESTABLE_SUB_APPLICATION
		redefine
			Option_name
		end

create
	make

feature -- Basic operations

	test_run
			--
		do
			Test.do_file_test ("XML/creatable/linguistic-analysis.smil", agent test_smil, 1080262066)
			Test.do_file_test ("vtd-xml/bioinfo.xml", agent test_bioinfo, 1876270734)
--			Test.do_file_test ("XML/Hexagrams.xhtml", agent test_xhtml, 780707548)-- Doesn't work
--			Test.do_file_test ("XML/Hexagrams.utf8.xhtml", agent test_xhtml, 780707548)
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

	Option_name: STRING = "declarative_xpath"

	Description: STRING = "Test declarative xpath processing of XML document"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{DECLARATIVE_XPATH_PROCESSING_TEST_APP}, All_routines],
				[{SMIL_XPATH_MATCH_EVENTS}, All_routines],
				[{BIOINFO_XPATH_MATCH_EVENTS}, All_routines]
			>>
		end

end
