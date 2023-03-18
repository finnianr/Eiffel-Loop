note
	description: "[
		Test set for class [$source EL_CREATEABLE_FROM_XPATH_MATCH_EVENTS]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-18 15:04:53 GMT (Saturday 18th March 2023)"
	revision: "10"

class
	CREATEABLE_FROM_XPATH_MATCH_EVENTS_TEST_SET

inherit
	EIFFEL_LOOP_TEST_SET
		undefine
			new_lio
		end

	EL_CRC_32_TESTABLE

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["match_events",	agent test_match_events]
			>>)
		end

feature -- Tests

	test_match_events
		do
			do_test ("create_bioinfo", 3460070361, agent create_bioinfo, [])
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
			lio.put_string_field ("Title", events.title)
			lio.put_new_line
			lio.put_integer_field ("Paragraph count", events.paragraph_count)
			lio.put_new_line
		end

end