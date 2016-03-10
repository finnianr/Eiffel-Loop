note
	description: "Summary description for {ARCHIVE_FILE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-03-03 13:09:17 GMT (Tuesday 3rd March 2015)"
	revision: "4"

class
	ARCHIVE_FILE

inherit
	RAW_FILE
		rename
			file_exists as this_file_exists,
			path as file_path,
			make as make_file
		export
			{NONE} all
			{ANY} file_path
		end

	EL_MODULE_LOG

	EL_MODULE_ENVIRONMENT

create
	make

feature {NONE} -- Initialization

	make (directory_node: EL_XPATH_NODE_CONTEXT
		target_dir_path, archive_dir_path: EL_DIR_PATH
		a_backup_name: STRING

	)
			--
		local
			encrypted_archive_file: RAW_FILE
			encrypted_archive_file_path, archive_file_path: EL_FILE_PATH
			versions, gpg_key: EL_ELEMENT_ATTRIBUTE_TABLE
			last_step_target_path: STRING
			working_directory: EL_DIR_PATH
		do
			log.enter_with_args ("make", << target_dir_path, archive_dir_path, a_backup_name >>)
			archive_directory_path := archive_dir_path
			backup_name := a_backup_name
			target_directory_name := target_dir_path.base

			archive_file_path := backup_name

			directory_node.find_node ("versions")
			if directory_node.node_found then
				versions := directory_node.found_node.attributes
				if versions.has ("max") then
					save_version_no (versions.integer ("max"))
					archive_file_path.add_extension (Version_00.formatted (version_no))
				end
			end
			archive_file_path.add_extension ("tar.gz")

			last_step_target_path := target_dir_path.base
			create exclusion_list_file.make (directory_node, archive_directory_path, target_dir_path)
			create inclusion_list_file.make (directory_node, archive_directory_path, target_dir_path)

			working_directory := target_dir_path.parent
			Archive_command.set_working_directory (working_directory)
			log_or_io.put_path_field ("WORKING DIRECTORY", working_directory)
			log_or_io.put_new_line

			Archive_command.put_variables (<<
				[TAR_EXCLUDE, 			exclusion_list_file.file_path.name ],
				[TAR_INCLUDE, 			inclusion_list_file.file_path.name ],
				[TAR_NAME, 				(archive_dir_path + archive_file_path).to_string ],
				[TARGET_DIRECTORY, 	target_directory_name ]
			>> )

			Archive_command.execute

			make_open_read (archive_directory_path + archive_file_path)
			if exists then
				kilo_bytes := (count / 1024).rounded
				close
				directory_node.find_node ("gpg-key")

				if directory_node.node_found then
					gpg_key := directory_node.found_node.attributes

					if gpg_key.has ("recipient") then
						encrypted_archive_file_path := file_path
						encrypted_archive_file_path.add_extension ("gpg")
						create encrypted_archive_file.make_with_name (encrypted_archive_file_path)
						if encrypted_archive_file.exists then
							encrypted_archive_file.delete
						end
						Encryption_command.set_working_directory (Archive_directory_path)

						Encryption_command.put_string (GPG_KEY_ID, gpg_key ["recipient"])
						Encryption_command.put_string (TAR_NAME, archive_file_path.to_string)

						Encryption_command.execute
						delete

						make_with_name (encrypted_archive_file_path)
					end

				end
			end
			log.exit
		end

feature -- Access

	kilo_bytes: INTEGER

feature {NONE} -- Implementation

	save_version_no (max_version_no: INTEGER)
			-- Save a version number in a data file
		local
			version_data_file_path: EL_FILE_PATH
			version_data_file: PLAIN_TEXT_FILE
		do
			log.enter ("save_version_no")
			version_data_file_path := archive_directory_path + "version.txt"

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

	archive_directory_path: EL_DIR_PATH

	target_directory_name: STRING

	backup_name: STRING

	exclusion_list_file: EXCLUSION_LIST_FILE

	inclusion_list_file: INCLUSION_LIST_FILE

feature {NONE} -- tar archive command with variables

	TAR_EXCLUDE: STRING = "TAR_EXCLUDE"

	TAR_INCLUDE: STRING = "TAR_INCLUDE"

	TAR_NAME: STRING = "TAR_NAME"

	TARGET_DIRECTORY: STRING = "TARGET_DIRECTORY"

	Archive_command: EL_GENERAL_OS_COMMAND
			--
			-- --verbose
		once
			create Result.make ("[
				tar --create --auto-compress --dereference --file="$TAR_NAME" "$TARGET_DIRECTORY"
				--exclude-from="$TAR_EXCLUDE"
				--files-from="$TAR_INCLUDE"
			]")
		end

feature {NONE} -- gpg encryption command with variables

	GPG_KEY_ID: STRING = "GPG_KEY_ID"

	Encryption_command: EL_GENERAL_OS_COMMAND
			--
		once
			create Result.make ("[
				gpg --batch --encrypt --recipient $GPG_KEY_ID "$TAR_NAME"
			]")
		end

--	Encryption_command: EL_GPG_ENCRYPT_COMMAND
--			--
--		once
--			create Result.make_default
--		end

feature {NONE} -- Constants

	Version_00: FORMAT_INTEGER
			--
		once
			create Result.make (2)
			Result.zero_fill
		end

end
