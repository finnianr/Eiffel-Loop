note
	description: "Test class [$source EL_PYXIS_TO_XML_CONVERTER] from library `xdoc-scanning.ecf'"
	notes: "[
		Test sets conforming to [$source EL_EQA_REGRESSION_TEST_SET] (like this one) can only be run
		from a sub-application conforming to [$source EL_REGRESSION_AUTOTEST_SUB_APPLICATION]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-14 13:47:35 GMT (Friday 14th February 2020)"
	revision: "23"

class
	PYXIS_TO_XML_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET
		rename
			data_dir as Eiffel_loop_dir
		end

	EIFFEL_LOOP_TEST_CONSTANTS

	EL_EQA_REGRESSION_TEST_SET
		undefine
			on_prepare, on_clean
		end

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("conversion", agent test_conversion)
		end

feature -- Basic operations

	test_conversion
			--
		local
			name, file_name: STRING; checksum: NATURAL
		do
			name := "convert_pyxis_to_xml"
			-- 3 Feb 2020
			across file_list as file_path loop
				file_name := file_path.item.base
				do_test (name, Checksum_table [file_name], agent convert_pyxis_to_xml, [file_path.item])
			end
		end

feature {NONE} -- Implementation

	convert_pyxis_to_xml (a_file_path: EL_FILE_PATH)
			--
		local
			converter: EL_PYXIS_TO_XML_CONVERTER; source: EL_PLAIN_TEXT_LINE_SOURCE
		do
			create converter.make (a_file_path, create {EL_FILE_PATH})
			converter.execute
			create source.make_encoded (converter.source_encoding, converter.output_path)
			source.print_first (log, 20)
			source.close
		end

	source_file_list: EL_FILE_PATH_LIST
		do
			Result := OS.file_list (EL_test_data_dir.joined_dir_path ("pyxis"), "*.pyx")
		end

feature {NONE} -- Constants

	Checksum_table: EL_HASH_TABLE [NATURAL, STRING]
		once
			create Result.make_equal (11)
			Result ["build.eant.pyx"] := 1180250235
			Result ["configuration.xsd.pyx"] := 2478124049
			Result ["credits.pyx"] := 1328579128
			Result ["phrases.pyx"] := 822123689
			Result ["words.pyx"] := 2578918131
			Result ["XML XSL Example.xsl.pyx"] := 3678777816
		end

end
