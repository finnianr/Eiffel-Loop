note
	description: "Test recursive conversion of XML document to Eiffel and serialization back to XML."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-09 14:10:18 GMT (Sunday 9th February 2020)"
	revision: "6"

class
	RECURSIVE_XML_TO_EIFFEL_OBJECT_BUILDER_TEST_APP

inherit
	TEST_SUB_APPLICATION
		redefine
			option_name, log_filter
		end

create
	make

feature -- Basic operations

	test_run
			--
		do
			-- 9 Feb 2020
			Test.do_file_test ("vtd-xml/bioinfo.xml", agent test_read_bioinfo, 1721213976)
		end

feature {NONE} -- Implementation

	test_read_bioinfo (file_path: EL_FILE_PATH)
			--
		local
			bioinformatic_commands: BIOINFORMATIC_COMMANDS
		do
			log.enter ("test_read_bioinfo")
			create bioinformatic_commands.make_from_file (file_path)
			bioinformatic_commands.display
			log.exit
		end

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{like Current}, All_routines],
				[{BIOINFORMATIC_COMMANDS}, All_routines],
				[{BIOINFO_COMMAND}, All_routines],
				[{CONTAINER_PARAMETER}, All_routines],
				[{TITLE_PARAMETER}, All_routines],
				[{URL_PARAMETER}, All_routines],
				[{RULES_LIST_PARAMETER}, All_routines],
				[{DATA_PARAMETER}, All_routines],
				[{BOOLEAN_PARAMETER}, All_routines],
				[{INTEGER_PARAMETER}, All_routines],
				[{REAL_PARAMETER}, All_routines],
				[{CHOICE_PARAMETER}, All_routines],
				[{INTEGER_RANGE_LIST_PARAMETER}, All_routines],
				[{REAL_RANGE_LIST_PARAMETER}, All_routines],
				[{STRING_LIST_PARAMETER}, All_routines]
			>>
		end

feature {NONE} -- Constants

	Description: STRING = "Auto test recursive conversion of XML document to Eiffel and serialization back to XML"

	Option_name: STRING = "recursive_x2e_and_e2x"

end
