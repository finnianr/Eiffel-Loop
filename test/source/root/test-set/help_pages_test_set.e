note
	description: "Generate psuedo text files from file paths in `data/txt/help-files.txt'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-19 18:33:07 GMT (Friday 19th March 2021)"
	revision: "10"

deferred class
	HELP_PAGES_TEST_SET

inherit
	EL_GENERATED_FILE_DATA_TEST_SET
		redefine
			new_file_tree
		end

	EIFFEL_LOOP_TEST_CONSTANTS

feature {NONE} -- Implementation

	new_file_tree: like new_empty_file_tree
		do
			create Result.make (0)
			Result [{STRING_32} "Help-pages/Windows™/boot"] :=
				"BootRec.exe.text, bootrec_error_msg.text, Bootrec.exe-tool.text"

			Result [Help_pages_bcd_dir] :=
				{STRING_32} "bcd-setup.3.txt, bcd-setup.2.txt, bcdedit_import_error.txt, bcd-setup-€.txt"

			Result [{STRING_32} "Help-pages/Windows™"] :=
				{STRING_32} "diskpart-2.txt, diskpart-€.txt, required-device-is-inaccessible.txt"

			Result ["Help-pages/Ubuntu"] :=
				"error.txt, firmware-b43-installer.txt, bcm-reinstall.txt"

			Result [Help_pages_mint_dir] :=  Wireless_notes_path.base + ", Broadcom missing.txt"
			Result [Help_pages_mint_docs_dir] :=  "Graphic.spec.txt, grub.error.txt, Intel HD-4000 framebuffer.txt"
		end

feature {NONE} -- Constants

	Help_pages: ZSTRING
		once
			Result := "Help-pages"
		end

	Help_pages_bcd_dir: EL_DIR_PATH
		once
			Result := Help_pages + {STRING_32} "/Windows™/bcd"
		end

	Help_pages_mint_dir: EL_DIR_PATH
		once
			Result := Help_pages + "/Mint"
		end

	Help_pages_mint_docs_dir: EL_DIR_PATH
		once
			Result := Help_pages_mint_dir.joined_dir_path ("docs")
		end

	Windows_dir: EL_DIR_PATH
		once
			Result := Help_pages + {STRING_32} "/Windows™"
		end

	Wireless_notes_path: EL_FILE_PATH
		once
			Result := Help_pages_mint_dir + "wireless_notes.txt"
		end

end