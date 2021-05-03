note
	description: "Test class [$source PYXIS_ECF_PARSER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-02 12:38:38 GMT (Sunday 2nd May 2021)"
	revision: "7"

class
	PYXIS_ECF_PARSER_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET
		rename
			data_dir as EL_test_data_dir
		undefine
			new_lio
		end

	EL_EQA_REGRESSION_TEST_SET
		undefine
			on_prepare, on_clean
		end

	EL_MODULE_DIGEST


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
		do
			do_test ("convert_pecf_to_ecf", os_checksum (1944519556, 1281513760), agent convert_pecf_to_ecf, [file_list.first_path])
		end

feature {NONE} -- Implementation

	convert_pecf_to_ecf (a_file_path: EL_FILE_PATH)
			--
		local
			converter: PYXIS_ECF_CONVERTER; source: EL_PLAIN_TEXT_LINE_SOURCE
		do
			create converter.make (a_file_path, create {EL_FILE_PATH})
			converter.execute
			create source.make (converter.source_encoding.encoding, converter.output_path)
			source.print_first (log, 50)
			source.close
			log.put_labeled_string ("MD5 sum", Digest.md5_file (converter.output_path).to_hex_string)
			log.put_new_line
		end

	source_file_list: EL_FILE_PATH_LIST
		do
			Result := OS.file_list (EL_test_data_dir.joined_dir_path ("pyxis"), "*.pecf")
		end

end