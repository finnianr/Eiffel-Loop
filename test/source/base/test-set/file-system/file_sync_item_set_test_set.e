note
	description: "Test classes [$source EL_FILE_SYNC_ITEM_SET] and [$source EL_LOCAL_FILE_SYNC_MEDIUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-20 17:17:35 GMT (Saturday 20th March 2021)"
	revision: "16"

class
	FILE_SYNC_ITEM_SET_TEST_SET

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
			sync_set: EL_FILE_SYNC_ITEM_SET; medium: EL_LOCAL_FILE_SYNC_MEDIUM
			source_list, destination_list: LIST [EL_FILE_PATH]
		do
			create medium.make
			medium.set_remote_home (Copied_dir)
			sync_set := new_sync_set

			sync_set.update (medium)
			source_list := File_system.files_with_extension (Workarea_help_pages_dir, Text_extension, True)
			destination_list := File_system.files_with_extension (Copied_dir, Text_extension, True)
			assert ("synchronized", source_list ~ destination_list)
		end

feature {NONE} -- Event handling

	on_prepare
		do
			Precursor {HELP_PAGES_TEST_SET}
		end

feature {NONE} -- Implementation

	new_sync_set: EL_FILE_SYNC_ITEM_SET
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