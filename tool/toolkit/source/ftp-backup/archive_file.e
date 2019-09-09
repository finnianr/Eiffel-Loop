note
	description: "Archive file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-14 9:41:51 GMT (Friday 14th June 2019)"
	revision: "6"

class
	ARCHIVE_FILE

inherit
	RAW_FILE
		rename
			file_exists as this_file_exists,
			make as make_file
		export
			{NONE} all
		end

	EL_MODULE_FORMAT

	EL_MODULE_LOG

	EL_MODULE_ENVIRONMENT

create
	make

feature {NONE} -- Initialization

	make (backup: FTP_BACKUP)
			--
		local
			encrypted_archive_file: RAW_FILE
			encrypted_archive_file_path, archive_file_path: EL_FILE_PATH
			last_step_target_path: STRING
			working_directory: EL_DIR_PATH
		do
			log.enter_with_args ("make", [backup.target_dir, backup.archive_dir, backup.name])
			archive_dir := backup.archive_dir

			archive_file_path := backup.name
			if backup.max_versions > 0 then
				save_version_no (backup.max_versions)
				archive_file_path.add_extension (Format.integer_zero (version_no, 2))
			end
			archive_file_path.add_extension ("tar.gz")

			last_step_target_path := backup.target_dir.base
			create exclusion_list_file.make (backup)
			create inclusion_list_file.make (backup)

			working_directory := backup.target_dir.parent
			Archive_command.set_working_directory (working_directory)
			lio.put_path_field ("WORKING DIRECTORY", working_directory)
			lio.put_new_line

			Archive_command.put_variables (<<
				[TAR_EXCLUDE, 			exclusion_list_file.file_path ],
				[TAR_INCLUDE, 			inclusion_list_file.file_path ],
				[TAR_NAME, 				archive_dir + archive_file_path],
				[TARGET_DIRECTORY, 	backup.target_dir.base]
			>> )

			Archive_command.execute

			make_open_read (archive_dir + archive_file_path)
			if exists then
				byte_count := count.to_natural_32
				close
				if not backup.gpg_key.is_empty then
					encrypted_archive_file_path := file_path
					encrypted_archive_file_path.add_extension ("gpg")
					create encrypted_archive_file.make_with_name (encrypted_archive_file_path)
					if encrypted_archive_file.exists then
						encrypted_archive_file.delete
					end
					Encryption_command.set_working_directory (archive_dir)

					Encryption_command.put_string (GPG_KEY_ID, backup.gpg_key)
					Encryption_command.put_file_path (TAR_NAME, archive_file_path)

					Encryption_command.execute
					delete

					make_with_name (encrypted_archive_file_path)
				end
			end
			log.exit
		end

feature -- Access

	byte_count: NATURAL

	file_path: EL_FILE_PATH
		do
			Result := path
		end

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

	version_no: INTEGER

	archive_dir: EL_DIR_PATH

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
