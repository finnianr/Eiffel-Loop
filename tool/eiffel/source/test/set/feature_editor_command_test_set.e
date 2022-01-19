note
	description: "Test class [$source FEATURE_EDITOR_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-19 9:47:24 GMT (Wednesday 19th January 2022)"
	revision: "15"

class
	FEATURE_EDITOR_COMMAND_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET
		undefine
			new_lio
		end

	EL_CRC_32_TEST_ROUTINES

	EL_ENCODING_CONSTANTS

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("file_editing", agent test_file_editing)
		end

feature -- Tests

	test_file_editing
		do
			across file_list as file_path loop
				do_test ("edit_file", Checksum_table [file_path.item.base], agent edit_file, [file_path.item])
			end
		end

feature {NONE} -- Implementation

	edit_file (file_path: FILE_PATH)
		local
			command: FEATURE_EDITOR_COMMAND; bom: BOOLEAN
		do
			bom := has_bom (file_path)
			create command.make (file_path)
			command.execute
			log.put_labeled_string ("Digest", plain_text_digest (file_path).to_base_64_string)
			log.put_new_line
			assert ("same bom", bom = has_bom (file_path))
		end

	source_file_list: EL_FILE_PATH_LIST
		do
			Result := OS.file_list (Data_dir, "*.e")
		end

	has_bom (file_path: FILE_PATH): BOOLEAN
		local
			lines: EL_PLAIN_TEXT_LINE_SOURCE
		do
			create lines.make (Latin_1, file_path)
			Result := lines.encoded_as_utf (8)
		end

feature {NONE} -- Constants

	Checksum_table: EL_HASH_TABLE [NATURAL, STRING]
		once
			create Result.make_equal (11)
			Result ["el_copy_file_impl.e"] := os_checksum (3882863469, 1333359779)
			Result ["el_mp3_convert_command.e"] := os_checksum (3362452, 1836232641)

--			Test insertions for: do_all (eval: EL_EQA_TEST_EVALUATOR)
--			and test correct BOM marker for UTF-8 encoding
			Result ["el_subject_line_decoder_test_set.e"] := os_checksum (323797391, 1852503677)

			Result ["job_duration_parser.e"] := os_checksum (2651641799, 497238340)
			Result ["subscription_delivery_email.e"] := os_checksum (1955610778, 2725163138)

--			test frozen feature name sort
			Result ["tl_id3_tag_frame_cpp_api.e"] := os_checksum (118099087, 399186481)
		end

	Data_dir: DIR_PATH
		once
			Result := "test-data/sources/feature-edits"
		end
end
