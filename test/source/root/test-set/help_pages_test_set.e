note
	description: "Generate psuedo help files from file paths in `data/txt/help-files.txt'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-10 9:24:20 GMT (Saturday 10th July 2021)"
	revision: "14"

deferred class
	HELP_PAGES_TEST_SET

inherit
	EL_GENERATED_FILE_DATA_TEST_SET
		redefine
			file_path_list
		end

	EIFFEL_LOOP_TEST_CONSTANTS

feature {NONE} -- Implementation

	file_path_list: ZSTRING
		-- Manifest of files to be created relative to `work_area_dir' separated by newline character
		do
			create Result.make_from_utf_8 (File_system.plain_text (EL_test_data_dir + "txt/help-files.txt"))
		end

feature {NONE} -- Help directories

	Help_pages_dir: EL_DIR_PATH
		once
			Result := "Help-pages"
		end

	Help_pages_bcd_dir: EL_DIR_PATH
		once
			Result := Help_pages_windows_dir #+ "bcd"
		end

	Help_pages_mint_dir: EL_DIR_PATH
		once
			Result := help_pages_dir #+ "Mint"
		end

	Help_pages_mint_docs_dir: EL_DIR_PATH
		once
			Result := Help_pages_mint_dir #+ "docs"
		end

	Help_pages_windows_dir: EL_DIR_PATH
		once
			Result := help_pages_dir #+ {STRING_32} "Windows™"
		end

	Workarea_help_pages_dir: EL_DIR_PATH
		once
			Result := work_area_path (help_pages_dir)
		end

feature {NONE} -- Constants

	Docs: ZSTRING
		once
			Result := "docs"
		end

	Help_pages_wireless_notes_path: EL_FILE_PATH
		once
			Result := Help_pages_mint_dir + "wireless_notes.txt"
		end

	Help_pages_grub_error: EL_FILE_PATH
		once
			Result := Help_pages_mint_docs_dir + "grub.error.txt"
		end

end