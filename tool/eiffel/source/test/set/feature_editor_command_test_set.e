note
	description: "Test class ${FEATURE_EDITOR_COMMAND}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-07 10:26:37 GMT (Wednesday 7th May 2025)"
	revision: "35"

class
	FEATURE_EDITOR_COMMAND_TEST_SET

inherit
	COPIED_SOURCES_TEST_SET
		rename
			selected_files as no_selected_files
		undefine
			new_lio
		redefine
			on_prepare
		end

	EL_CRC_32_TESTABLE

	EL_MODULE_FILE; EL_MODULE_TUPLE

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["adjust_manifest_tuple_tabs", agent test_adjust_manifest_tuple_tabs],
				["cleanup_of_leading_spaces",	 agent test_cleanup_of_leading_spaces],
				["file_editing",					 agent test_file_editing],
				["frozen_feature_name_sort",	 agent test_frozen_feature_name_sort],
				["make_named_array",				 agent test_make_named_array]
			>>)
		end

	on_prepare
		do
			Precursor
			create path_table.make_equal (file_list.count)
			across file_list  as list loop
				path_table.extend (list.item, list.item.base_name)
			end
		end

feature -- Tests

	test_adjust_manifest_tuple_tabs
		-- FEATURE_EDITOR_COMMAND_TEST_SET.test_adjust_manifest_tuple_tabs
		note
			testing: "[
				covers/{CONSTANT_FEATURE}.expand_shorthand,
				covers/{SETTER_SHORTHAND_FEATURE}.expand_shorthand,
				covers/{MAKE_ROUTINE_FEATURE}.expand_shorthand,
				covers/{ROUTINE_FEATURE}.expand_shorthand,
				covers/{CLASS_FEATURE}.adjust_manifest_tuple_tabs
			]"
		do
			across to_list (Tuple_manifest_file) as list loop
				do_test ("edit_file", Checksum_table [list.item], agent edit_file, [list.item])
			end
		end

	test_cleanup_of_leading_spaces
		-- test clean-up of leading spaces after new-line
		note
			testing: "covers/{CLASS_LEADING_SPACE_EDITOR}.replace_spaces"
		do
			do_test ("edit_file", Checksum_table [Pixmap_imp_drawable], agent edit_file, [Pixmap_imp_drawable])
		end

	test_file_editing
		-- FEATURE_EDITOR_COMMAND_TEST_SET.file_editing
		do
			across to_list (Name) as list loop
				do_test ("edit_file", Checksum_table [list.item], agent edit_file, [list.item])
			end
		end

	test_frozen_feature_name_sort
		do
			do_test ("edit_file", Checksum_table [Id3_tag_frame_cpp_api], agent edit_file, [Id3_tag_frame_cpp_api])
		end

	test_make_named_array
		-- FEATURE_EDITOR_COMMAND_TEST_SET.make_named_array
		--	Test insertions for: make_named (<< ["name", agent test_<name>] >>))
		--	and test correct BOM marker for UTF-8 encoding
		note
			testing: "[
				covers/{GENERATE_MAKE_ROUTINE_FOR_EQA_TEST_SET}.expand_shorthand,
				covers/{CLASS_FEATURE}.adjust_manifest_tuple_tabs
			]"
		local
			source_path: FILE_PATH; source_name: ZSTRING
		do
			source_name := Subject_line_decoder_test_set
			source_path := new_source_path (source_name)

			assert ("has bom", File.has_utf_8_bom (source_path))

			do_test ("edit_file", Checksum_table [source_name], agent edit_file, [source_name])
			assert ("same bom", File.has_utf_8_bom (source_path))
		end

feature {NONE} -- Implementation

	edit_file (source_name: ZSTRING)
		local
			command: FEATURE_EDITOR_COMMAND; source_path: FILE_PATH
		do
			source_path := new_source_path (source_name)
			assert_32 (source_path.base_name + " exists", source_path.exists)
			create command.make (source_path, False)
			command.execute
			log.put_labeled_string ("Digest", plain_text_digest (source_path).to_base_64_string)
			log.put_new_line
		end

	new_source_path (source_name: ZSTRING): FILE_PATH
		do
			if path_table.has_key (source_name) then
				Result := path_table.found_item
			else
				create Result
			end
		ensure
			not_empty: not Result.is_empty
		end

	sources_list: ARRAY [DIR_PATH]
		do
			Result := << Source.feature_edits_dir >>
		end

	to_list (name_tuple: TUPLE): EL_ZSTRING_LIST
		do
			create Result.make_from_tuple (name_tuple)
		end

feature {NONE} -- Internal attributes

	path_table: EL_ZSTRING_HASH_TABLE [FILE_PATH]

feature {NONE} -- File sets

	Id3_tag_frame_cpp_api: ZSTRING
		once
			Result := "tl_id3_tag_frame_cpp_api"
		end

	Name: TUPLE [copy_file_impl, job_duration_parser, os_command_test_set: ZSTRING]
		do
			create Result
			Tuple.fill (Result, "el_copy_file_impl, job_duration_parser, os_command_test_set")
		end

	Pixmap_imp_drawable: ZSTRING
		once
			Result := "ev_pixmap_imp_drawable"
		end

	Subject_line_decoder_test_set: ZSTRING
		once
			Result := "el_subject_line_decoder_test_set"
		end

	Tuple_manifest_file: TUPLE [mp3_convert_command, subscription_delivery_email: ZSTRING]
		-- contains manifest tuple requiring alignment
		once
			create Result
			Tuple.fill (Result, "el_mp3_convert_command, subscription_delivery_email")
		end

feature {NONE} -- Constants

	Checksum_table: EL_ZSTRING_HASH_TABLE [NATURAL]
		once
			create Result.make_equal (11)
			Result [Name.copy_file_impl] := 2668348354
			Result [Name.job_duration_parser] := 3823255307
			Result [Name.os_command_test_set] := 181748489

			Result [Tuple_manifest_file.mp3_convert_command] := 1338607062
			Result [Tuple_manifest_file.subscription_delivery_email] := 1320393160

			Result [Id3_tag_frame_cpp_api] := 1015425037
			Result [Subject_line_decoder_test_set] := 3227206339
			Result [Pixmap_imp_drawable] := 3427172657
		end

end