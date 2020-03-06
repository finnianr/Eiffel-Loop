note
	description: "Test class [$source FEATURE_EDITOR_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-06 13:24:00 GMT (Friday 6th March 2020)"
	revision: "3"

class
	FEATURE_EDITOR_COMMAND_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET

	EL_EQA_REGRESSION_TEST_SET
		undefine
			on_prepare, on_clean
		end

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

	edit_file (file_path: EL_FILE_PATH)
		local
			command: FEATURE_EDITOR_COMMAND; bom: BOOLEAN
		do
			bom := has_bom (file_path)
			create command.make (file_path)
			command.execute
			log.put_labeled_string ("Digest", file_digest (file_path).to_base_64_string)
			log.put_new_line
			assert ("same bom", bom = has_bom (file_path))
		end

	source_file_list: EL_FILE_PATH_LIST
		do
			Result := OS.file_list (Data_dir, "*.e")
		end

	has_bom (file_path: EL_FILE_PATH): BOOLEAN
		local
			lines: EL_PLAIN_TEXT_LINE_SOURCE
		do
			create lines.make_latin (1, file_path)
			Result := lines.encoded_as_utf (8)
		end

feature {NONE} -- Constants

	Checksum_table: EL_HASH_TABLE [NATURAL, STRING]
		once
			create Result.make_equal (11)
			Result ["el_copy_file_impl.e"] := 2820257958
			Result ["el_mp3_convert_command.e"] := 4019820802

			-- Test insertions for: do_all (eval: EL_EQA_TEST_EVALUATOR)
			-- and test correct BOM marker for UTF-8 encoding
			Result ["el_subject_line_decoder_test_set.e"] := 4132782535

			Result ["job_duration_parser.e"] := 287350020
			Result ["subscription_delivery_email.e"] := 4210816405
		end

	Data_dir: EL_DIR_PATH
		once
			Result := "test-data/feature-edits"
		end
end
