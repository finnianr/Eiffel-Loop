note
	description: "Help pages test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:54:14 GMT (Monday 1st July 2019)"
	revision: "6"

deferred class
	HELP_PAGES_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET
		redefine
			new_file_tree
		end

	EL_EIFFEL_LOOP_TEST_CONSTANTS

feature {NONE} -- Implementation

	new_file_tree: like new_empty_file_tree
		do
			create Result.make (0)
			Result [{STRING_32} "Help-pages/Windows™/boot"] := <<
				"BootRec.exe.text", "bootrec_error_msg.text", "Bootrec.exe-tool.text"
			>>
			Result [Help_pages_bcd_dir] := <<
				{STRING_32} "bcd-setup.3.txt", {STRING_32} "bcd-setup.2.txt", {STRING_32} "bcdedit_import_error.txt",
				{STRING_32} "bcd-setup-€.txt"
			>>
			Result [{STRING_32} "Help-pages/Windows™"] := <<
				{STRING_32} "diskpart-2.txt", {STRING_32} "diskpart-€.txt",
				{STRING_32} "required-device-is-inaccessible-0xc000000e.txt"
			>>
			Result ["Help-pages/Ubuntu"] := <<
				"error.txt", "firmware-b43-installer.txt", "bcm-reinstall.txt"
			>>
			Result [Help_pages_mint_dir] := <<
				Wireless_notes_path.base.to_latin_1, "Broadcom missing.txt"
			>>
			Result [Help_pages_mint_docs_dir] := <<
				"Graphic.spec.txt", "grub.error.txt", "Intel HD-4000 framebuffer.txt"
			>>
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
