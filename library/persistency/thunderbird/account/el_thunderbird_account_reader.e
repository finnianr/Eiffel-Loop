note
	description: "[
		Reads Thunderbird HTML email documents from a selected account
		and configured by a Pyxis document.

			pyxis-doc:
				version = 1.0; encoding = "UTF-8"

			thunderbird:
				account = "<email account name>"; export_dir = "<export path>"
				language = "<optional language code"
				folders:
					"<folder name 1>"
					"<folder name 2>"
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-25 18:58:43 GMT (Tuesday 25th December 2018)"
	revision: "8"

class
	EL_THUNDERBIRD_ACCOUNT_READER

inherit
	EL_BUILDABLE_FROM_PYXIS
		redefine
			make_default, make_from_file, building_action_table
		end

	EL_MODULE_LIO

	EL_ZSTRING_CONSTANTS

feature {NONE} -- Initialization

	make_default
		do
			create account.make (0)
			create language.make_empty
			create folder_list.make (5)
			folder_list.compare_objects
			home_dir := "$HOME"
			home_dir.expand
			Precursor
		end

	make_from_file (a_file_path: EL_FILE_PATH)
		local
			profile_lines: EL_FILE_LINE_SOURCE; mail_dir_path_steps: EL_PATH_STEPS
		do
			Precursor (a_file_path)
			lio.put_labeled_string ("Account", account)
			lio.put_new_line
			lio.put_path_field ("export", export_dir)
			lio.put_new_line

			mail_dir_path_steps := home_dir
			mail_dir_path_steps.extend (".thunderbird")
			create profile_lines.make (mail_dir_path_steps.as_directory_path + "profiles.ini")
			across profile_lines as line loop
				if line.item.starts_with (Path_equals) then
					mail_dir_path_steps.extend (line.item.split ('=').last)
				end
			end
			mail_dir_path_steps.extend ("Mail")
			mail_dir_path_steps.extend (account)
			mail_dir := mail_dir_path_steps
			lio.put_path_field ("Mail", mail_dir)
			lio.put_new_line_x2
		end

feature -- Access

	export_steps (mails_path: EL_FILE_PATH): EL_PATH_STEPS
		do
			Result := mails_path.steps
			from until Result.is_empty or else Result.first.same_string (account) loop
				Result.remove_head (1)
			end
			if not Result.is_empty then
				Result.remove_head (1)
			end
			across Result as step loop
				if step.item.ends_with (Dot_sbd_extension) then
					step.item.remove_tail (Dot_sbd_extension.count)
				end
			end
			if language.is_empty then
				if not language_code_last then
					-- Put the language code at beginning, for example: help/en -> en/help
					Result.put_front (Result.last)
					Result.remove_tail (1)
				end
			else
				Result.remove_tail (1)
			end
		end

	export_dir: EL_DIR_PATH

feature {NONE} -- Internal attributes

	account: STRING
		-- account name

	folder_list: EL_ZSTRING_LIST
		-- .sbd folders

	home_dir: EL_DIR_PATH

	language: STRING

	language_code_last: BOOLEAN
		-- when true put the language code directory last in directory structure
		-- example: help/en

	mail_dir: EL_DIR_PATH

feature {NONE} -- Implementation

	is_folder_included (path: ZSTRING): BOOLEAN
		local
			folder_dir: EL_DIR_PATH
		do
			if path.ends_with (Dot_sbd_extension) then
				folder_dir := path
				Result := not folder_list.is_empty implies folder_list.has (folder_dir.base_sans_extension)
			end
		end

feature {NONE} -- Build from XML

	Root_node_name: STRING = "thunderbird"

	building_action_table: EL_PROCEDURE_TABLE
			--
		do
			create Result.make (<<
				["@account",				agent do account := node end],
				["@language",				agent do language := node end],
				["@home_dir",				agent do home_dir := node.to_expanded_dir_path end],
				["@export_dir",			agent do export_dir := node.to_expanded_dir_path end],
				["@language_code_last", agent do language_code_last := node end],
				["folders/text()", 		agent do folder_list.extend (node) end]
			>>)
		end

feature {NONE} -- Constants

	Dot_sbd_extension: ZSTRING
		once
			Result := ".sbd"
		end

	Path_equals: ZSTRING
		once
			Result := "Path="
		end

end
