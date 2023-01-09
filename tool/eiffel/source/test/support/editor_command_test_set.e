note
	description: "[
		Test set for editor command that ensure correct result for both UTF-8 and Latin-1 encodings
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-09 9:58:30 GMT (Monday 9th January 2023)"
	revision: "7"

deferred class
	EDITOR_COMMAND_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET
		undefine
			new_lio
		end

	EL_CRC_32_TESTABLE

	EL_MODULE_TUPLE

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("file_editing", agent test_file_editing)
		end

feature -- Tests

	test_file_editing
		do
			across file_list as file_path loop
				do_test ("edit_file", Checksum_table [file_path.item.base_name], agent edit_file, [file_path.item])
			end
		end

feature {NONE} -- Implementation

	adjusted_path (file_path: FILE_PATH): FILE_PATH
		do
			Result := file_path
		end

	checksum_table: EL_HASH_TABLE [NATURAL, ZSTRING]
		deferred
		end

	edit_file (file_path: FILE_PATH)
		local
			bom: BOOLEAN
		do
			bom := has_bom (file_path)
			new_edit (file_path).apply
			log.put_labeled_string ("Digest", plain_text_digest (adjusted_path (file_path)).to_base_64_string)
			log.put_new_line
			assert ("same bom", bom = has_bom (adjusted_path (file_path)))
		end

	new_edit (file_path: FILE_PATH): PROCEDURE
		deferred
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

	Name: TUPLE [
		copy_file_impl, mp3_convert_command, subject_line_decoder_test_set,
		job_duration_parser, subscription_delivery_email, id3_tag_frame_cpp_api: ZSTRING
	]
		do
			create Result
			Tuple.fill (Result,
				"el_copy_file_impl, el_mp3_convert_command, el_subject_line_decoder_test_set,%
				%job_duration_parser, subscription_delivery_email, tl_id3_tag_frame_cpp_api"
			)
		end

	Data_dir: DIR_PATH
		once
			Result := "test-data/sources/feature-edits"
		end

end