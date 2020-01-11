note
	description: "Xml to pyxis app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-11 12:34:48 GMT (Saturday 11th January 2020)"
	revision: "12"

class
	XML_TO_PYXIS_TEST_APP

inherit
	TEST_SUB_APPLICATION

create
	make

feature -- Tests

	test_run
			--
		do
			-- Jan 2020
			Test.do_file_test (XML_dir + "uuid.ecf", agent test_xml_to_pyxis, 4126336762)
			Test.do_file_test (XML_dir + "XML XSL Example.xsl", agent test_xml_to_pyxis, 2811006303)
			Test.do_file_test (XML_dir + "configuration.xsd", agent test_xml_to_pyxis, 1148975586)
			Test.do_file_test (XML_dir + "kernel.xace", agent test_xml_to_pyxis, 3178325651)
			Test.do_file_test (XML_dir + "Rhythmbox.bkup", agent test_xml_to_pyxis, 939816975)
		end

feature -- Test

	test_xml_to_pyxis (file_path: EL_FILE_PATH)
			--
		local
			converter: EL_XML_TO_PYXIS_CONVERTER
		do
			create converter.make (file_path)
			converter.execute
		end

feature {NONE} -- Implementation

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{like Current}, All_routines]
			>>
		end

feature {NONE} -- Constants

	Description: STRING = "Test conversions of XML file to Pyxis format"

	XML_dir: EL_DIR_PATH
		once
			Result := "XML"
		end

end
