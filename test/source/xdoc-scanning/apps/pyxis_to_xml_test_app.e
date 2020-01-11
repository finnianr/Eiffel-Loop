note
	description: "Test conversion of Pyxis format file to XML"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-11 13:41:17 GMT (Saturday 11th January 2020)"
	revision: "18"

class
	PYXIS_TO_XML_TEST_APP

inherit
	TEST_SUB_APPLICATION
		redefine
			visible_types
		end

create
	make

feature -- Basic operations

	test_run
			--
		do
			-- Jan 2020
			Test.do_file_test ("pyxis/localization/words.pyx", agent test_pyxis_to_xml, 859438784)
			Test.do_file_test ("pyxis/configuration.xsd.pyx", agent test_pyxis_to_xml, 2320431585)
			Test.do_file_test ("pyxis/XML XSL Example.xsl.pyx", agent test_pyxis_to_xml, 3778948581)
		end

feature -- Tests

	test_pyxis_to_xml (a_file_path: EL_FILE_PATH)
			--
		local
			converter: EL_PYXIS_TO_XML_CONVERTER
		do
			create converter.make (a_file_path, create {EL_FILE_PATH})
			converter.execute
		end

feature {NONE} -- Implementation

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{PYXIS_TO_XML_TEST_APP}, All_routines]
			>>
		end

	visible_types: TUPLE [EL_PYXIS_TO_XML_CONVERTER]
		do
			create Result
		end

feature {NONE} -- Constants

	Description: STRING = "Test conversion of Pyxis format file to XML"

end
