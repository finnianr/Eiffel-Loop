note
	description: "[
		Multi-lingual (ML) Thunderbird email account reader.

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
	date: "2021-07-10 8:35:45 GMT (Saturday 10th July 2021)"
	revision: "11"

deferred class
	EL_ML_THUNDERBIRD_ACCOUNT_READER

inherit
	EL_THUNDERBIRD_ACCOUNT_READER
		export
			{EL_COMMAND_CLIENT} make_from_file
		redefine
			make_default
		end

	EL_COMMAND

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
						lio.put_path_field ("Reading", mails_path)
						lio.put_new_line
						new_reader.read_mails (mails_path)
					end
				end
			end
		end

feature {NONE} -- Implementation

	mail_folder_dir_list: EL_ARRAYED_LIST [EL_DIR_PATH]
		do
			if attached OS.find_directories_command (mail_dir) as cmd then
				cmd.set_depth (1 |..| 1)
				cmd.set_predicate_filter (agent is_folder_included)
				cmd.execute
				Result := cmd.path_list
			end
		end

	new_reader: EL_THUNDERBIRD_FOLDER_READER
		deferred
		end

end