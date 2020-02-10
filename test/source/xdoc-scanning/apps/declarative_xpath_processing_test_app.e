note
	description: "Test class [$source EL_CREATEABLE_FROM_XPATH_MATCH_EVENTS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-09 14:05:30 GMT (Sunday 9th February 2020)"
	revision: "8"

class
	DECLARATIVE_XPATH_PROCESSING_TEST_APP

inherit
	TEST_SUB_APPLICATION
		redefine
			Option_name, log_filter
		end

create
	make

feature -- Basic operations

	test_run
			--
		do
			Test.do_file_test ("XML/creatable/linguistic-analysis.smil", agent test_smil, 2924425149)
			Test.do_file_test ("vtd-xml/bioinfo.xml", agent test_bioinfo, 342540672)
			Test.do_file_test ("XML/Hexagrams.xhtml", agent test_xhtml, 3124129911)
			Test.do_file_test ("XML/Hexagrams.utf8.xhtml", agent test_xhtml, 2042718884)
		end

feature -- Tests

	test_bioinfo (file_path: EL_FILE_PATH)
			--
		local
			bioinfo_match_events: BIOINFO_XPATH_MATCH_EVENTS
		do
			log.enter ("test_bioinfo")
			create bioinfo_match_events.make_from_file (file_path)
			log.exit
		end

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

feature {NONE} -- Implementation

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{DECLARATIVE_XPATH_PROCESSING_TEST_APP}, All_routines],
				[{SMIL_XPATH_MATCH_EVENTS}, All_routines],
				[{BIOINFO_XPATH_MATCH_EVENTS}, All_routines]
			>>
		end

feature {NONE} -- Constants

	Description: STRING = "Test declarative xpath processing of XML document"

	Option_name: STRING = "declarative_xpath"

end
