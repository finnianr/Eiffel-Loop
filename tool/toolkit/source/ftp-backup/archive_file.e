note
	description: "Archive file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "12"

class
	ARCHIVE_FILE

inherit
	ANY

	EL_MODULE_FILE; EL_MODULE_FILE_SYSTEM; EL_MODULE_FORMAT; EL_MODULE_LOG

	EL_MODULE_ENVIRONMENT

	EL_FILE_OPEN_ROUTINES

create
	make

feature {NONE} -- Initialization

	make (a_backup: FTP_BACKUP)
			--
		local
			gpg_file_path: FILE_PATH; working_directory: DIR_PATH
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
			log.put_path_field ("WORKING DIRECTORY", working_directory)
			log.put_new_line

			Archive_command.put_variables (<<
				[Tar.exlude, 		exclusion_list_file.file_path],
				[Tar.include, 		inclusion_list_file.file_path],
				[Tar.file_path, 	file_path],
				[Tar.target_dir,	backup.target_dir.base]
			>> )

			lio.put_labeled_string ("Creating archive", file_path)
			lio.put_new_line
			Archive_command.execute

			if file_path.exists then
				byte_count := File.byte_count (file_path).to_natural_32
				if not backup.gpg_key.is_empty then
					gpg_file_path := file_path.twin
					gpg_file_path.add_extension ("gpg")
					if gpg_file_path.exists then
						File_system.remove_file (gpg_file_path)
					end
					Encryption_command.set_working_directory (archive_dir)

					Encryption_command.put_string (GPG.key_id, backup.gpg_key)
					Encryption_command.put_path (GPG.file_path, file_path)

					Encryption_command.execute
					File_system.remove_file (file_path)
					file_path := gpg_file_path
				end
			end
			log.exit
		end

feature -- Access

	byte_count: NATURAL

	file_path: FILE_PATH

feature {NONE} -- Implementation

	save_version_no (max_version_no: INTEGER)
			-- Save a version number in a data file
		local
			version_data_file_path: FILE_PATH
		do
			log.enter ("save_version_no")
			version_data_file_path := archive_dir + "version.txt"

			if version_data_file_path.exists and then attached open (version_data_file_path, Read) as l_file then
				l_file.read_integer
				version_no := l_file.last_integer + 1
				if version_no = max_version_no then
					version_no := 0
				end
				l_file.close
			else
				version_no := 0
			end
			if attached open (version_data_file_path, Write) as l_file then
				l_file.put_integer (version_no)
				l_file.close
			end
			log.put_integer_field ("version_no", version_no)
			log.put_new_line
			log.exit
		end

feature {NONE} -- Implementation: attributes

	backup: FTP_BACKUP

	version_no: INTEGER

	archive_dir: DIR_PATH
		do
			Result := backup.archive_dir
		end

	exclusion_list_file: EXCLUSION_LIST_FILE

	inclusion_list_file: INCLUSION_LIST_FILE

feature {NONE} -- tar archive command with variables

	Tar: TUPLE [file_path, target_dir, exlude, include: STRING]
		once
			create Result
		end

	Archive_command: EL_OS_COMMAND
		once
			create Result.make ("[
				tar --create --auto-compress --dereference --file $FILE_PATH "$TARGET_DIRECTORY"
				--exclude-from $EXCLUDE_FROM
				--files-from $FILE_FROM
			]")
			Result.fill_variables (Tar)
		end

feature {NONE} -- gpg encryption command with variables

	GPG: TUPLE [key_id, file_path: STRING]
		once
			create Result
		end

	Encryption_command: EL_OS_COMMAND
			--
		once
			create Result.make ("[
				gpg --batch --encrypt --recipient $KEY_ID $FILE_PATH
			]")
			Result.fill_variables (GPG)
		end

end