note
	description: "Summary description for {FTP_BACKUP_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-15 11:53:39 GMT (Sunday 15th October 2017)"
	revision: "7"

class
	FTP_BACKUP_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [FTP_BACKUP]
		rename
			command as ftp_command
		redefine
			Option_name, Installer, ftp_command, initialize
		end

	EL_MODULE_USER_INPUT

create
	make

feature {NONE} -- Initialization

	initialize
			--
		do
			Console.show ({EL_FTP_PROTOCOL})
			Precursor
		end

feature -- Test operations

	test_run
		do
--			Test.set_binary_file_extensions (<< "mp3" >>)

--			Test.do_file_tree_test ("bkup", agent test_gpg_normal_run (?, "rhythmdb.bkup"), 4026256056)
			Test.do_file_tree_test ("bkup", agent test_normal_run (?, "id3$.bkup"), 813868097)

			Test.print_checksum_list
		end

	test_gpg_normal_run (data_path: EL_DIR_PATH; backup_name: STRING)
			--
		local
			gpg_recipient: STRING
		do
			log.enter ("test_gpg_normal_run")
			ftp_command := test_backup (data_path, backup_name)

			gpg_recipient := User_input.line ("Enter an encryption recipient id for gpg")
			ftp_command.environment_variables.put_variable (gpg_recipient, "RECIPIENT")

			normal_run
			log.exit
		end

	test_normal_run (data_path: EL_DIR_PATH; backup_name: STRING)
			--
		do
			log.enter ("test_normal_run")
			ftp_command := test_backup (data_path, backup_name)
			normal_run
			log.exit
		end

	test_backup (data_path: EL_DIR_PATH; backup_name: STRING): FTP_BACKUP
		local
			file_list: EL_FILE_PATH_LIST
		do
			create file_list.make_from_array (<< Directory.Working.joined_dir_path (data_path) + backup_name >>)
			create Result.make (file_list, False)
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_required_argument (
					"scripts", "List of files to backup (Must be the last parameter)", << file_must_exist >>
				),
				optional_argument ("upload", "Upload the archive after creation")
			>>
		end

	default_make: PROCEDURE
		do
			Result := agent {like ftp_command}.make (create {EL_FILE_PATH_LIST}.make_with_count (0), False)
		end

	ftp_command: FTP_BACKUP

feature {NONE} -- Constants

	Option_name: STRING = "ftp_backup"

	Description: STRING = "Tar directories and ftp them off site"

	Installer: EL_APPLICATION_INSTALLER_I
		once
			Result := new_context_menu_installer ("Eiffel Loop/General utilities/ftp backup")
		end

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{FTP_BACKUP_APP}, All_routines],
				[{ARCHIVE_FILE}, All_routines],
				[{INCLUSION_LIST_FILE}, All_routines],
				[{EXCLUSION_LIST_FILE}, All_routines],
				[{FTP_BACKUP}, All_routines]
			>>
		end

end
