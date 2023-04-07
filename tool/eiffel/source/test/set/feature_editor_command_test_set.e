note
	description: "Test class [$source FEATURE_EDITOR_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-07 8:34:16 GMT (Friday 7th April 2023)"
	revision: "24"

class
	FEATURE_EDITOR_COMMAND_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET
		undefine
			new_lio
		end

	EL_CRC_32_TESTABLE

	EL_MODULE_TUPLE

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["file_editing", agent test_file_editing],
				["adjust_manifest_tuple_tabs", agent test_adjust_manifest_tuple_tabs]
			>>)
		end

feature -- Tests

	test_adjust_manifest_tuple_tabs
		note
			testing: "covers/{SETTER_SHORTHAND_FEATURE}.expand_shorthand",
						"covers/{CLASS_FEATURE}.adjust_manifest_tuple_tabs"
		do
			across file_list as path loop
				if across Manifest_test_list as list some path.item.base_matches (list.item, False) end then
					do_test ("edit_file", Checksum_table [path.item.base_name], agent edit_file, [path.item])
				end
			end
		end

	test_file_editing
		-- FEATURE_EDITOR_COMMAND_TEST_SET.file_editing
		do
			across file_list as path loop
				if across Manifest_test_list as list all not path.item.base_matches (list.item, False) end then
					do_test ("edit_file", Checksum_table [path.item.base_name], agent edit_file, [path.item])
				end
			end
		end

feature {NONE} -- Implementation

	edit_file (file_path: FILE_PATH)
		local
			bom: BOOLEAN; command: FEATURE_EDITOR_COMMAND
		do
			bom := has_bom (file_path)
			create command.make (file_path, False)
			command.execute
			log.put_labeled_string ("Digest", plain_text_digest (file_path).to_base_64_string)
			log.put_new_line
			assert ("same bom", bom = has_bom (file_path))
		end

	has_bom (file_path: FILE_PATH): BOOLEAN
		local
			lines: EL_PLAIN_TEXT_LINE_SOURCE
		do
			create lines.make (Latin_1, file_path)
			Result := lines.encoded_as_utf (8)
		end

	source_file_list: EL_FILE_PATH_LIST
		do
			Result := OS.file_list (Data_dir, "*.e")
		end

feature {NONE} -- Constants

	Checksum_table: EL_HASH_TABLE [NATURAL, ZSTRING]
		once
			create Result.make_equal (11)
			Result [Name.copy_file_impl] := 4276247644
			Result [Manifest_test.mp3_convert_command] := 45425631

--			Test insertions for: make_named (<< ["name", agent test_<name>] >>))
--			and test correct BOM marker for UTF-8 encoding
			Result [Manifest_test.subject_line_decoder_test_set] := 2132604965

			Result [Name.job_duration_parser] := 2651641799
			Result [Manifest_test.subscription_delivery_email] := 1992120725

--			test frozen feature name sort
			Result [Name.id3_tag_frame_cpp_api] := 118099087

--			test clean-up of leading spaces after new-line
			Result [Name.pixmap_imp_drawable] := 1395307592
		end

	Data_dir: DIR_PATH
		once
			Result := "test-data/sources/feature-edits"
		end

	Manifest_test: TUPLE [mp3_convert_command, subject_line_decoder_test_set, subscription_delivery_email: ZSTRING]
		-- contains manifest tuple requiring alignment
		once
			create Result
			Tuple.fill (Result, "el_mp3_convert_command, el_subject_line_decoder_test_set, subscription_delivery_email")
		end

	Manifest_test_list: EL_ZSTRING_LIST
		once
			create Result.make_from_tuple (Manifest_test)
		end

	Name: TUPLE [copy_file_impl, job_duration_parser, id3_tag_frame_cpp_api, pixmap_imp_drawable: ZSTRING]
		do
			create Result
			Tuple.fill (Result,
				"el_copy_file_impl, job_duration_parser, tl_id3_tag_frame_cpp_api, ev_pixmap_imp_drawable"
			)
		end

end