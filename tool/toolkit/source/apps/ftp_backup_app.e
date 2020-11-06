note
	description: "Ftp backup app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-05 18:35:19 GMT (Thursday 5th November 2020)"
	revision: "19"

class
	FTP_BACKUP_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [FTP_BACKUP_COMMAND]
		rename
			command as ftp_command
		redefine
			Option_name, ftp_command, initialize
		end

	EL_INSTALLABLE_SUB_APPLICATION
		rename
			desktop_menu_path as Default_desktop_menu_path,
			desktop_launcher as Default_desktop_launcher
		end

	EL_MODULE_USER_INPUT

	EL_MODULE_EXECUTION_ENVIRONMENT

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

	test_gpg_normal_run (file_path: EL_FILE_PATH)
			--
		local
			gpg_recipient: STRING
		do
			log.enter ("test_gpg_normal_run")
			gpg_recipient := User_input.line ("Enter an encryption recipient id for gpg")
			Execution_environment.put (gpg_recipient, "RECIPIENT")

			create ftp_command.make (file_path, False)

			normal_run
			log.exit
		end

	test_normal_run (file_path: EL_FILE_PATH)
			--
		do
			log.enter ("test_normal_run")
			create ftp_command.make (file_path, False)
			normal_run
			log.exit
		end

	test_run
		do
			Test.set_excluded_file_extensions (<< "gz" >>) -- tar files are date stamped therefore must be excluded
			Test.do_file_test ("bkup/id3-1.bkup", agent test_normal_run, 2260245724)
			Test.do_file_test ("bkup/id3-2.bkup", agent test_normal_run, 3403517712)
			Test.do_file_test ("bkup/id3-3.bkup", agent test_normal_run, 1379707871)
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument (
					"config", "Path to configuration file", << file_must_exist >>
				),
				optional_argument ("upload", "Upload the archive after creation")
			>>
		end

	default_make: PROCEDURE [like ftp_command]
		do
			Result := agent {like ftp_command}.make (create {EL_FILE_PATH}, False)
		end

	extra_log_filter_list: EL_LOG_FILTER_LIST [
		ARCHIVE_FILE,
		INCLUSION_LIST_FILE,
		EXCLUSION_LIST_FILE,
		BACKUP_CONFIG
	]
		do
			create Result.make
		end

feature {NONE} -- Internal attributes

	ftp_command: FTP_BACKUP_COMMAND

feature {NONE} -- Constants

	Description: STRING = "Create tar.gz backups and ftp them off site"

	Desktop: EL_DESKTOP_ENVIRONMENT_I
		once
			Result := new_context_menu_desktop ("Eiffel Loop/General utilities/ftp backup")
		end

	Option_name: STRING = "ftp_backup"

end