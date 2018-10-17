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
	date: "2018-10-17 11:19:15 GMT (Wednesday 17th October 2018)"
	revision: "8"

deferred class
	EL_LOCALIZED_THUNDERBIRD_ACCOUNT_READER

inherit
	EL_THUNDERBIRD_ACCOUNT_READER
		export
			{EL_COMMAND_CLIENT} make_from_file
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
						lio.put_path_field ("Reading", mails_path)
						lio.put_new_line
						new_reader.read_mails (mails_path)
					end
				end
			end
		end

feature {NONE} -- Implementation

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

	new_reader: EL_THUNDERBIRD_FOLDER_READER
		deferred
		end

end
