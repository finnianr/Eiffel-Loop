note
	description: "Test class [$source FEATURE_EDITOR_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-06 12:23:28 GMT (Thursday 6th April 2023)"
	revision: "23"

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
		local
			source_path: FILE_PATH
		do
			source_path := Work_area_dir + Name.mp3_convert_command
			source_path.add_extension ("e")
			do_test ("edit_file", Checksum_table [source_path.base_name], agent edit_file, [source_path])
		end

	test_file_editing
		-- FEATURE_EDITOR_COMMAND_TEST_SET.file_editing
		do
			across file_list as path loop
				if not path.item.same_base (Name.mp3_convert_command) then
					do_test ("edit_file", Checksum_table [path.item.base_name], agent edit_file, [path.item])
				end
			end
		end

feature {NONE} -- Implementation

	adjusted_path (file_path: FILE_PATH): FILE_PATH
		do
			Result := file_path
		end

	edit_file (file_path: FILE_PATH)
		local
			bom: BOOLEAN; command: FEATURE_EDITOR_COMMAND
		do
			bom := has_bom (file_path)
			create command.make (file_path, False)
			command.execute
			log.put_labeled_string ("Digest", plain_text_digest (adjusted_path (file_path)).to_base_64_string)
			log.put_new_line
			assert ("same bom", bom = has_bom (adjusted_path (file_path)))
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
			Result [Name.mp3_convert_command] := 45425631

--			Test insertions for: make_named (<< ["name", agent test_<name>] >>))
--			and test correct BOM marker for UTF-8 encoding
			Result [Name.subject_line_decoder_test_set] := 1111299139

			Result [Name.job_duration_parser] := 2651641799
			Result [Name.subscription_delivery_email] := 1955610778

--			test frozen feature name sort
			Result [Name.id3_tag_frame_cpp_api] := 118099087

--			test clean-up of leading spaces after new-line
			Result [Name.pixmap_imp_drawable] := 1395307592
		end

	Data_dir: DIR_PATH
		once
			Result := "test-data/sources/feature-edits"
		end

	Name: TUPLE [
		copy_file_impl, mp3_convert_command, subject_line_decoder_test_set, job_duration_parser,
		subscription_delivery_email, id3_tag_frame_cpp_api, pixmap_imp_drawable: ZSTRING
	]
		do
			create Result
			Tuple.fill (Result,
				"el_copy_file_impl, el_mp3_convert_command, el_subject_line_decoder_test_set,%
				%job_duration_parser, subscription_delivery_email, tl_id3_tag_frame_cpp_api,%
				%ev_pixmap_imp_drawable"
			)
		end

end