note
	description: "Test recursive conversion of XML document to Eiffel and serialization back to XML."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-22 16:23:23 GMT (Saturday 22nd June 2013)"
	revision: "2"

class
	RECURSIVE_XML_TO_EIFFEL_OBJECT_BUILDER_TEST_APP

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
			Test.do_file_test ("vtd-xml/bioinfo.xml", agent test_read_bioinfo, 2324937273)
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

feature {NONE} -- Implementation


feature {NONE} -- Constants

	Option_name: STRING = "test_recursive_x2e_and_e2x"

	Description: STRING = "Auto test recursive conversion of XML document to Eiffel and serialization back to XML"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{RECURSIVE_XML_TO_EIFFEL_OBJECT_BUILDER_TEST_APP}, "*"],
				[{EL_TEST_ROUTINES}, "*"],
				[{BIOINFORMATIC_COMMANDS}, "*"],
				[{BIOINFO_COMMAND}, "*"],
				[{CONTAINER_PARAMETER}, "*"],
				[{TITLE_PARAMETER}, "*"],
				[{URL_PARAMETER}, "*"],
				[{RULES_LIST_PARAMETER}, "*"],
				[{DATA_PARAMETER}, "*"],
				[{BOOLEAN_PARAMETER}, "*"],
				[{INTEGER_PARAMETER}, "*"],
				[{REAL_PARAMETER}, "*"],
				[{CHOICE_PARAMETER}, "*"],
				[{INTEGER_RANGE_LIST_PARAMETER}, "*"],
				[{REAL_RANGE_LIST_PARAMETER}, "*"],
				[{STRING_LIST_PARAMETER}, "*"]

			>>
		end

end
