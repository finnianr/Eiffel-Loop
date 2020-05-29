note
	description: "Archive file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-28 9:52:03 GMT (Thursday 28th May 2020)"
	revision: "8"

class
	ARCHIVE_FILE

inherit
	ANY

	EL_MODULE_FORMAT

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LOG

	EL_MODULE_ENVIRONMENT

create
	make

feature {NONE} -- Initialization

	make (a_backup: FTP_BACKUP)
			--
		local
			gpg_file_path: EL_FILE_PATH; working_directory: EL_DIR_PATH
		do
			backup := a_backup
			log.enter_with_args ("make", [backup.target_dir, backup.archive_dir, backup.name])

			file_path := archive_dir + backup.name

			if backup.max_versions > 0 then
				save_version_no (backup.max_versions)
				file_path.add_extension (Format.integer_zero (version_no, 2))
			end
			file_path.add_extension ("tar.gz")

			create exclusion_list_file.make (backup)
			create inclusion_list_file.make (backup)

			working_directory := backup.target_dir.parent
			Archive_command.set_working_directory (working_directory)
			lio.put_path_field ("WORKING DIRECTORY", working_directory)
			lio.put_new_line

			Archive_command.put_variables (<<
				[TAR_EXCLUDE, 			exclusion_list_file.file_path ],
				[TAR_INCLUDE, 			inclusion_list_file.file_path ],
				[TAR_NAME, 				file_path],
				[TARGET_DIRECTORY, 	backup.target_dir.base]
			>> )

			lio.put_labeled_string ("Creating archive", file_path)
			lio.put_new_line
			Archive_command.execute

			if file_path.exists then
				byte_count := File_system.file_byte_count (file_path).to_natural_32
				if not backup.gpg_key.is_empty then
					gpg_file_path := file_path.twin
					gpg_file_path.add_extension ("gpg")
					if gpg_file_path.exists then
						File_system.remove_file (gpg_file_path)
					end
					Encryption_command.set_working_directory (archive_dir)

					Encryption_command.put_string (GPG_KEY_ID, backup.gpg_key)
					Encryption_command.put_path (TAR_NAME, file_path)

					Encryption_command.execute
					File_system.remove_file (file_path)
					file_path := gpg_file_path
				end
			end
			log.exit
		end

feature -- Access

	byte_count: NATURAL

	file_path: EL_FILE_PATH

feature {NONE} -- Implementation

	save_version_no (max_version_no: INTEGER)
			-- Save a version number in a data file
		local
			version_data_file_path: EL_FILE_PATH
			version_data_file: PLAIN_TEXT_FILE
		do
			log.enter ("save_version_no")
			version_data_file_path := archive_dir + "version.txt"

			create version_data_file.make_with_name (version_data_file_path)
			if version_data_file.exists then
				version_data_file.open_read
				version_data_file.read_integer
				version_no := version_data_file.last_integer + 1
				if version_no = max_version_no then
					version_no := 0
				end
			else
				version_no := 0
			end
			version_data_file.open_write
			version_data_file.put_integer (version_no)
			version_data_file.close
			log.put_integer_field ("version_no", version_no)
			log.put_new_line
			log.exit
		end

feature {NONE} -- Implementation: attributes

	backup: FTP_BACKUP

	version_no: INTEGER

	archive_dir: EL_DIR_PATH
		do
			Result := backup.archive_dir
		end

	exclusion_list_file: EXCLUSION_LIST_FILE

	inclusion_list_file: INCLUSION_LIST_FILE

feature {NONE} -- tar archive command with variables

	TAR_EXCLUDE: STRING = "TAR_EXCLUDE"

	TAR_INCLUDE: STRING = "TAR_INCLUDE"

	TAR_NAME: STRING = "TAR_NAME"

	TARGET_DIRECTORY: STRING = "TARGET_DIRECTORY"

	Archive_command: EL_OS_COMMAND
			--
			-- --verbose
		once
			create Result.make ("[
				tar --create --auto-compress --dereference --file $TAR_NAME "$TARGET_DIRECTORY"
				--exclude-from $TAR_EXCLUDE
				--files-from $TAR_INCLUDE
			]")
		end

feature {NONE} -- gpg encryption command with variables

	GPG_KEY_ID: STRING = "GPG_KEY_ID"

	Encryption_command: EL_OS_COMMAND
			--
		once
			create Result.make ("[
				gpg --batch --encrypt --recipient $GPG_KEY_ID "$TAR_NAME"
			]")
		end

end
