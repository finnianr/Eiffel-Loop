note
	description: "[
		Test set for class [$source EL_CREATEABLE_FROM_XPATH_MATCH_EVENTS]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	CREATEABLE_FROM_XPATH_MATCH_EVENTS_TEST_SET

inherit
	EIFFEL_LOOP_TEST_SET

	EL_CRC_32_TEST_ROUTINES

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("match_events",	agent test_match_events)
		end

feature -- Tests

	test_match_events
		do
			do_test ("create_bioinfo", 729106667, agent create_bioinfo, [])
			do_test ("create_smil", 2182301393, agent create_smil, [])
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
			events: XHTML_XPATH_MATCH_EVENTS
		do
			create events.make_from_file (file_path)
			log.put_string_field ("Title", events.title)
			log.put_new_line
			log.put_integer_field ("Paragraph count", events.paragraph_count)
			log.put_new_line
		end

end