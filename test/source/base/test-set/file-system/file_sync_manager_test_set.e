note
	description: "Test classes [$source EL_FILE_SYNC_MANAGER] and [$source EL_LOCAL_FILE_SYNC_MEDIUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-27 18:27:25 GMT (Saturday 27th March 2021)"
	revision: "19"

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
			current_set: EL_MEMBER_SET [EL_FILE_SYNC_ITEM]
			sync_item: EL_FILE_SYNC_ITEM
		do
			create destination_list.make_filled (create {EL_FILE_PATH_LIST}.make_empty, 1, 4)
			create medium.make
			medium.set_remote_home (Copied_dir)

			lio.put_labeled_string ("Test", "adding new files")
			lio.put_new_line
			create current_set.make (7)
			across File_system.files_with_extension (Workarea_help_pages_dir, Text_extension, True) as path loop
				create sync_item.make (Workarea_help_pages_dir, Ftp_name, path.item)
				current_set.put (sync_item)
			end
			create manager.make (current_set)
			assert ("manager.has_changes", manager.has_changes)
			manager.update (medium)
			destination_list [1] := directory_contents (Copied_dir)
			assert ("synchronized", source_contents_list ~ destination_list [1])

			lio.put_labeled_string ("Test", "remove items in docs directory")
			lio.put_new_line
			across manager.current_list as list loop
				if list.item.file_path.has_step (Docs) then
					current_set.prune (list.item)
				end
			end

			create manager.make (current_set)
			assert ("manager.has_changes", manager.has_changes)
			manager.update (medium)
			destination_list [2] := directory_contents (Copied_dir)
			assert ("3 fewer items", destination_list [2].count + 3 = destination_list [1].count)
			assert ("synchronized", source_contents_list ~ destination_list [2])
			assert ("docs directory removed", not Help_pages_mint_docs_dir.exists)

			lio.put_labeled_string ("Test", "add back 1 file to docs directory")
			lio.put_new_line
			create sync_item.make (Workarea_help_pages_dir, Ftp_name, Help_pages_grub_error.relative_path (Help_pages_dir))
			current_set.put (sync_item)

			File_system.make_directory (Work_area_dir #+ Help_pages_mint_docs_dir)
			write_file (work_area_dir + Help_pages_grub_error)

			create manager.make (current_set)
			assert ("manager.has_changes", manager.has_changes)
			manager.update (medium)
			destination_list [3] := directory_contents (Copied_dir)
			assert ("1 item extra", destination_list [3].count - 1 = destination_list [2].count)
			assert ("synchronized", source_contents_list ~ destination_list [3])

			lio.put_labeled_string ("Test", "no changes made")
			lio.put_new_line
			create manager.make (current_set)
			assert ("not manager.has_changes", not manager.has_changes)
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

feature {NONE} -- Constants

	Copied_dir: EL_DIR_PATH
		once
			Result := Work_area_dir.joined_dir_path ("copied")
		end

	Ftp_name: STRING = "ftp"

	Text_extension: STRING = "txt"



end