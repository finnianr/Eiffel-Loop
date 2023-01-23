note
	description: "[
		Multi-language Thunderbird email account reader.

		Reads Thunderbird HTML email documents from a selected account where content folders
		are organized with sub-folders named as 2 letter language code to hold localized versions
		of documents.
		
			foo/en
			foo/de
			foo/fr
			
			bar/en
			bar/de
			bar/fr
			
		Each document folder is read and processed by a class conforming to [$source TB_FOLDER_READER]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-23 14:47:36 GMT (Monday 23rd January 2023)"
	revision: "17"

deferred class
	TB_MULTI_LANG_ACCOUNT_READER

inherit
	TB_ACCOUNT_READER
		export
			{EL_COMMAND_CLIENT} make_from_file
		redefine
			make_default
		end

feature {NONE} -- Initialization

	make_default
		do
			Precursor
		end

feature -- Basic operations

	execute
		local
			mails_path: FILE_PATH; found_count: INTEGER
		do
			if attached new_mail_folder_dir_list as dir_list then
				across folder_list as folder loop
					dir_list.find_first_equal (folder.item + Dot_sbd_extension, agent {DIR_PATH}.base)
					if dir_list.found then
						found_count := found_count + 1
					else
						lio.put_labeled_string (folder.item, "not found")
						lio.put_new_line
					end
				end
				if found_count = folder_list.count then
					across dir_list as subdir_path loop
						across OS.file_list (subdir_path.item, "*.msf") as path loop
							mails_path := path.item.without_extension
							if not language.is_empty implies mails_path.same_base (language) then
								lio.put_path_field ("Reading", mails_path)
								lio.put_new_line
								new_reader.read_mails (mails_path)
							end
						end
					end
				else
					lio.put_new_line
					lio.put_line ("CONFIGURATION ERROR: not all folders found")
				end
			end
		end

feature {NONE} -- Implementation

	new_mail_folder_dir_list: EL_ARRAYED_LIST [DIR_PATH]
		do
			if attached OS.find_directories_command (mail_dir) as cmd then
				cmd.set_depth (1 |..| 1)
				cmd.set_predicate_filter (agent is_folder_included)
				cmd.execute
				Result := cmd.path_list
			end
		end

	new_reader: TB_FOLDER_READER
		deferred
		end

end

