note
	description: "Export Thunderbird HTML as XHTML for selected folders"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-27 17:25:31 GMT (Thursday 27th September 2018)"
	revision: "6"

deferred class
	EL_THUNDERBIRD_LOCALIZED_HTML_EXPORTER

inherit
	EL_THUNDERBIRD_EXPORTER
		rename
			make as make_exporter
		end

	EL_COMMAND

	EL_MODULE_COMMAND
	EL_MODULE_DIRECTORY
	EL_MODULE_FILE_SYSTEM
	EL_MODULE_OS

feature {NONE} -- Initialization

	make (
		a_account_name: ZSTRING; a_export_path, thunderbird_home_dir: EL_DIR_PATH
		a_included_folders: like included_folders
	)
		do
			make_exporter (a_account_name, a_export_path, thunderbird_home_dir)
			included_folders := a_included_folders
			included_folders.compare_objects
		end

feature -- Basic operations

	execute
		do
			across mail_folder_dir_list as subdir_path loop
				across OS.file_list (subdir_path.item, "*.msf") as file_path loop
					export_mails (file_path.item.without_extension)
				end
			end
		end

feature {NONE} -- Implementation

	export_dir_path (mails_path: EL_FILE_PATH): EL_DIR_PATH
		local
			relative_path_steps: EL_PATH_STEPS
		do
			relative_path_steps := mails_path.steps
			relative_path_steps.start
			from until relative_path_steps.first ~ account_name or relative_path_steps.is_empty loop
				relative_path_steps.remove
			end
			if not relative_path_steps.is_empty then
				relative_path_steps.remove
			end
			across relative_path_steps as step loop
				if step.item.ends_with (Dot_sbd_extension) then
					step.item.remove_tail (Dot_sbd_extension.count)
				end
			end
			if is_language_code_first then
				-- Put the language code at beginning, for example: help/en -> en/help
				relative_path_steps.put_front (relative_path_steps.last)
				relative_path_steps.finish
				relative_path_steps.remove
			end
			Result := export_path.joined_dir_steps (relative_path_steps)
		end

	new_exporter (output_dir: EL_DIR_PATH): EL_THUNDERBIRD_FOLDER_EXPORTER [EL_HTML_WRITER]
		deferred
		end

	export_mails (mails_path: EL_FILE_PATH)
		do
			lio.put_path_field ("Exporting", mails_path)
			lio.put_new_line
			new_exporter (export_dir_path (mails_path)).export_mails (mails_path)
		end

	mail_folder_dir_list: EL_ARRAYED_LIST [EL_DIR_PATH]
		local
			find_cmd: like Command.new_find_directories
		do
			find_cmd := Command.new_find_directories (mail_dir)
			find_cmd.set_depth (1 |..| 1)
			find_cmd.set_path_included_condition (agent is_folder_included)
			find_cmd.execute
			Result := find_cmd.path_list
		end

	is_folder_included (path: ZSTRING): BOOLEAN
		local
			folder_dir: EL_DIR_PATH
		do
			if path.ends_with (Dot_sbd_extension) then
				folder_dir := path
				Result := not included_folders.is_empty implies included_folders.has (folder_dir.base_sans_extension)
			end
		end

	is_language_code_first: BOOLEAN
		deferred
		end

feature {NONE} -- Internal attributes

	included_folders: EL_ZSTRING_LIST
		-- .sbd folders

feature -- Constants

	Dot_sbd_extension: ZSTRING
		once
			Result := ".sbd"
		end

end
