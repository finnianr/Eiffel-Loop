note
	description: "Test recursive conversion of XML document to Eiffel and serialization back to XML."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:31 GMT (Tuesday 2nd September 2014)"
	revision: "3"

class
	RECURSIVE_XML_TO_EIFFEL_OBJECT_BUILDER_TEST_APP

inherit
	TEST_APPLICATION

create
	make

feature -- Basic operations

	test_run
			--
		do
			Test.do_file_test ("vtd-xml/bioinfo.xml", agent test_read_bioinfo, 1823215752) -- Jan 2015
		end

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

feature {NONE} -- Constants

	Option_name: STRING = "test_recursive_x2e_and_e2x"

	Description: STRING = "Auto test recursive conversion of XML document to Eiffel and serialization back to XML"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{RECURSIVE_XML_TO_EIFFEL_OBJECT_BUILDER_TEST_APP}, All_routines],
				[{EL_TEST_ROUTINES}, All_routines],
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

end
