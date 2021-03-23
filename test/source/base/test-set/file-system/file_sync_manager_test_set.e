note
	description: "Test classes [$source EL_FILE_SYNC_MANAGER] and [$source EL_LOCAL_FILE_SYNC_MEDIUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-21 12:18:16 GMT (Sunday 21st March 2021)"
	revision: "17"

class
	FILE_SYNC_MANAGER_TEST_SET

inherit
	HELP_PAGES_TEST_SET
		undefine
			new_lio
		redefine
			on_prepare
		end

	EL_EQA_REGRESSION_TEST_SET
		undefine
			on_prepare, on_clean
		end

	EL_MODULE_TRACK

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("file_transfer", agent test_file_transfer)
		end

feature -- Tests

	test_file_transfer
		note
			testing: "covers/{EL_FILE_SYNC_ITEM_SET}.update"
		local
			manager: EL_FILE_SYNC_MANAGER; medium: EL_LOCAL_FILE_SYNC_MEDIUM
			destination_list: ARRAY [LIST [EL_FILE_PATH]]
		do
			create destination_list.make_filled (create {EL_FILE_PATH_LIST}.make_empty, 1, 4)
			create medium.make
			medium.set_remote_home (Copied_dir)
			manager := new_manager

			lio.put_labeled_string ("Test", "adding new files")
			lio.put_new_line
			manager.update (medium)
			destination_list [1] := directory_contents (Copied_dir)
			assert ("synchronized", source_contents_list ~ destination_list [1])

			lio.put_labeled_string ("Test", "remove items in docs directory")
			lio.put_new_line
			across manager.current_list as list loop
				if list.item.file_path.has_step (Docs) then
					manager.remove (list.item)
				end
			end
			manager.update (medium)
			destination_list [2] := directory_contents (Copied_dir)
			assert ("3 fewer items", destination_list [2].count + 3 = destination_list [1].count)
			assert ("synchronized", source_contents_list ~ destination_list [2])
			assert ("docs directory removed", not Help_pages_mint_docs_dir.exists)

			lio.put_labeled_string ("Test", "add back 1 file to docs directory")
			lio.put_new_line
			manager.put_file (Help_pages_grub_error.relative_path (Help_pages_dir))
			File_system.make_directory (Work_area_dir #+ Help_pages_mint_docs_dir)
			write_file (work_area_dir + Help_pages_grub_error)
			manager.update (medium)
			destination_list [3] := directory_contents (Copied_dir)
			assert ("1 item extra", destination_list [3].count - 1 = destination_list [2].count)
			assert ("synchronized", source_contents_list ~ destination_list [3])

			lio.put_labeled_string ("Test", "no changes made")
			lio.put_new_line
			manager.update (medium)
			destination_list [4] := directory_contents (Copied_dir)
			assert ("unchanged", destination_list [4].count = destination_list [3].count)
			assert ("synchronized", source_contents_list ~ destination_list [4])
		end

feature {NONE} -- Event handling

	on_prepare
		do
			Precursor {HELP_PAGES_TEST_SET}
		end

feature {NONE} -- Implementation

	source_contents_list: LIST [EL_FILE_PATH]
		do
			Result := directory_contents (Workarea_help_pages_dir)
		end

	directory_contents (a_dir_path: EL_DIR_PATH): LIST [EL_FILE_PATH]
		do
			Result := File_system.files_with_extension (a_dir_path, Text_extension, True)
			from Result.start until Result.after loop
				Result.replace (Result.item.relative_path (a_dir_path))
				Result.forth
			end
		end

	new_manager: EL_FILE_SYNC_MANAGER
		do
			create Result.make (Workarea_help_pages_dir, Text_extension)
			across File_system.files_with_extension (Workarea_help_pages_dir, Text_extension, True) as path loop
				Result.put_file (path.item.relative_path (Workarea_help_pages_dir))
			end
		end

feature {NONE} -- Constants

	Copied_dir: EL_DIR_PATH
		once
			Result := Work_area_dir.joined_dir_path ("copied")
		end

	Text_extension: STRING = "txt"

end