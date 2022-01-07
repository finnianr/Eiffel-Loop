note
	description: "Test class [$source PYXIS_ECF_PARSER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-07 16:29:26 GMT (Friday 7th January 2022)"
	revision: "13"

class
	PYXIS_ECF_PARSER_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET
		rename
			data_dir as EL_test_data_dir
		end

	EIFFEL_LOOP_TEST_CONSTANTS

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("conversion_to_pecf", agent test_conversion_to_pecf)
		end

feature -- Tests

	test_conversion_to_pecf
			--
		local
			converter: PYXIS_ECF_CONVERTER; source: EL_PLAIN_TEXT_LINE_SOURCE
		do
			create converter.make (file_list.first_path, create {FILE_PATH})
			converter.execute
			create source.make (converter.source_encoding.encoding, converter.output_path)
			source.print_first (lio, 50)
			source.close
			assert_same_digest_hexadecimal (converter.output_path, "F503CBB1EE8560D91F2B1B131057F509")
		end

feature {NONE} -- Implementation


	source_file_list: EL_FILE_PATH_LIST
		do
			Result := OS.file_list (EL_test_data_dir #+ "pyxis", "*.pecf")
		end

end