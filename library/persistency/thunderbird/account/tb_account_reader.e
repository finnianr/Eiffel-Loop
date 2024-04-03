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
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-02 13:56:21 GMT (Tuesday 2nd April 2024)"
	revision: "33"

deferred class
	TB_ACCOUNT_READER

inherit
	EL_APPLICATION_COMMAND

	EL_BUILDABLE_FROM_PYXIS
		redefine
			make_default, make_from_file, building_action_table
		end

	EL_FILE_OPEN_ROUTINES

	EL_MODULE_LIO
	EL_MODULE_DIRECTORY
	EL_MODULE_FILE_SYSTEM
	EL_MODULE_OS

	EL_ZSTRING_CONSTANTS

feature {NONE} -- Initialization

	make_default
		do
			create account.make_empty
			create language.make_empty
			create folder_list.make (5)
			folder_list.compare_objects
			home_dir := "$HOME"
			home_dir.expand
			Precursor
		end

	make_from_file (a_file_path: FILE_PATH)
		local
			mail_dir_path: DIR_PATH
		do
			Precursor (a_file_path)
			lio.put_labeled_string ("Account", account)
			lio.put_new_line
			lio.put_path_field ("export %S", export_dir)
			lio.put_new_line

			mail_dir_path := home_dir
			mail_dir_path.append_step (".thunderbird")
			if attached open_lines (mail_dir_path + "profiles.ini", Utf_8) as profile_lines then
				profile_lines.enable_shared_item

				across profile_lines as line loop
					if line.item.starts_with (Path_equals) then
						mail_dir_path.append_step (line.item.split_list ('=').last)
					end
				end
				profile_lines.close
			end
			mail_dir_path.append_step ("Mail")
			mail_dir_path.append_step (account)
			mail_dir := mail_dir_path
			lio.put_path_field ("Mail %S", mail_dir)
			lio.put_new_line_x2
		end

feature -- Access

	account: STRING
		-- account name

	export_dir: DIR_PATH

	export_steps (mails_path: FILE_PATH): EL_PATH_STEPS
		local
			account_index, i: INTEGER; dot_sbd_step: ZSTRING
		do
			Result := mails_path.steps
			account_index := Result.index_of (account, 1)
			if account_index > 0 then
				Result.remove_head (account_index)
			end
			from i := 1 until i > Result.count loop
				if Result [i].ends_with (Dot_sbd_extension) then
					dot_sbd_step := Result [i]
					dot_sbd_step.remove_tail (Dot_sbd_extension.count)
					Result [i] := dot_sbd_step
				end
				i := i + 1
			end
			if language.is_empty then
				if not language_code_last then
					-- Put the language code at beginning, for example: help/en -> en/help
					Result.put_token_front (Result.last_token)
					Result.remove_tail (1)
				end
			else
				Result.remove_tail (1)
			end
		end

	folder_list: EL_ZSTRING_LIST
		-- .sbd folders

	home_dir: DIR_PATH

	language: STRING

	mail_dir: DIR_PATH

feature -- Status query

	language_code_last: BOOLEAN
		-- when true put the language code directory last in directory structure
		-- example: help/en

feature {NONE} -- Implementation

	is_folder_included (path: ZSTRING): BOOLEAN
		local
			folder_dir: DIR_PATH
		do
			if path.ends_with (Dot_sbd_extension) then
				folder_dir := path
				Result := not folder_list.is_empty implies folder_list.has (folder_dir.base_name)
			end
		end

	new_email_list (mails_path: FILE_PATH): TB_EMAIL_LIST
		do
			create Result.make (mails_path)
		end

feature {NONE} -- Build from XML

	Root_node_name: STRING = "thunderbird"

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			create Result.make (<<
				["@account",				agent do node.set_8 (account) end],
				["@language",				agent do node.set_8 (language) end],
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

note
	descendants: "[
			TB_ACCOUNT_READER*
				${TB_WWW_XHTML_CONTENT_EXPORTER}
				${TB_MULTI_LANG_ACCOUNT_READER*}
					${TB_MULTI_LANG_ACCOUNT_XHTML_BODY_EXPORTER}
					${TB_MULTI_LANG_ACCOUNT_XHTML_DOC_EXPORTER}
					${TB_MULTI_LANG_ACCOUNT_BOOK_EXPORTER}
	]"
end