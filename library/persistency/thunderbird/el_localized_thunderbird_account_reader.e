note
	description: "[
		Reads Thunderbird HTML email documents from a selected account where content folders
		are organized with sub-folders named as 2 letter language code to hold localized versions
		of documents.
		
			foo/en
			foo/de
			foo/fr
			
			bar/en
			bar/de
			bar/fr
			
		Each document folder is read and processed by a class conforming to [$source EL_THUNDERBIRD_FOLDER_READER]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-12 17:12:02 GMT (Friday 12th October 2018)"
	revision: "7"

deferred class
	EL_LOCALIZED_THUNDERBIRD_ACCOUNT_READER

inherit
	EL_THUNDERBIRD_ACCOUNT_READER
		redefine
			make_default
		end

	EL_COMMAND

	EL_MODULE_COMMAND
	EL_MODULE_DIRECTORY
	EL_MODULE_FILE_SYSTEM
	EL_MODULE_OS

feature {NONE} -- Initialization

	make_default
		do
			Precursor
		end

feature -- Basic operations

	execute
		local
			mails_path: EL_FILE_PATH
		do
			across mail_folder_dir_list as subdir_path loop
				across OS.file_list (subdir_path.item, "*.msf") as path loop
					mails_path := path.item.without_extension
					if not language.is_empty implies mails_path.base.same_string (language) then
						export_mails (mails_path)
					end
				end
			end
		end

feature {NONE} -- Implementation

	export_dir_path (mails_path: EL_FILE_PATH): EL_DIR_PATH
		local
			steps: EL_PATH_STEPS
		do
			steps := mails_path.steps
			steps.start
			from until steps.first.same_string (account) or steps.is_empty loop
				steps.remove
			end
			if not steps.is_empty then
				steps.remove
			end
			across steps as step loop
				if step.item.ends_with (Dot_sbd_extension) then
					step.item.remove_tail (Dot_sbd_extension.count)
				end
			end
			if language.is_empty then
				if is_language_code_first then
					-- Put the language code at beginning, for example: help/en -> en/help
					steps.put_front (steps.last)
					steps.finish
					steps.remove
				end
			else
				steps.finish; steps.remove
			end
			Result := export_dir.joined_dir_steps (steps)
		end

	new_reader (a_output_dir: EL_DIR_PATH): EL_THUNDERBIRD_FOLDER_READER
		deferred
		end

	export_mails (mails_path: EL_FILE_PATH)
		do
			lio.put_path_field ("Reading", mails_path)
			lio.put_new_line
			new_reader (export_dir_path (mails_path)).read_mails (mails_path)
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

	is_language_code_first: BOOLEAN
		deferred
		end

end
