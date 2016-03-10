note
	description: "Summary description for {FTP_BACKUP_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "7"

class
	FTP_BACKUP_APP

inherit
	EL_TESTABLE_COMMAND_LINE_SUB_APPLICATTION [FTP_BACKUP]
		rename
			command as ftp_command
		redefine
			Option_name, Installer, ftp_command
		end

	EL_MODULE_USER_INPUT

create
	make

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
			file_list: ARRAYED_LIST [EL_FILE_PATH]
		do
			create file_list.make_from_array (<< Directory.Working.joined_dir_path (data_path) + backup_name >>)
			create Result.make (file_list, False)
		end

feature {NONE} -- Implementation

	make_action: PROCEDURE [like ftp_command, like default_operands]
		do
			Result := agent ftp_command.make
		end

	default_operands: TUPLE [script_file_path_list: ARRAYED_LIST [EL_FILE_PATH]; ask_user_to_upload: BOOLEAN]
		do
			create Result
			Result.script_file_path_list := create {ARRAYED_LIST [EL_FILE_PATH]}.make (0)
			Result.ask_user_to_upload := False
		end

	argument_specs: ARRAY [like Type_argument_specification]
		do
			Result := <<
				required_existing_path_argument ("scripts", "List of files to backup (Must be the last parameter)"),
				optional_argument ("upload", "Upload the archive after creation")
			>>
		end

	ftp_command: FTP_BACKUP

feature {NONE} -- Constants

	Option_name: STRING = "ftp_backup"

	Description: STRING = "Tar directories and ftp them off site"

	Installer: EL_CONTEXT_MENU_SCRIPT_APPLICATION_INSTALLER
		once
			create Result.make ("Eiffel Loop/General utilities/ftp backup")
		end

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{FTP_BACKUP_APP}, "*"],
				[{ARCHIVE_FILE}, "*"],
				[{INCLUSION_LIST_FILE}, "*"],
				[{EXCLUSION_LIST_FILE}, "*"],
				[{EL_XPATH_ROOT_NODE_CONTEXT}, "*"],
				[{EL_FTP_PROTOCOL}, "*"],
				[{FTP_BACKUP}, "*"],
				[{EL_XPATH_NODE_CONTEXT_LIST}, "-*"],
				[{EL_XPATH_NODE_CONTEXT}, "-*"],
				[{EL_VTD_EXCEPTIONS}, "*"],
				[{EL_TEST_ROUTINES}, "*"]
			>>
		end

end
