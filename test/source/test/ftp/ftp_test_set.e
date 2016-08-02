note
	description: "Summary description for {FTP_TEST_SET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-18 11:31:34 GMT (Monday 18th July 2016)"
	revision: "1"

class
	FTP_TEST_SET

inherit
	HELP_PAGES_TEST_SET
		redefine
			on_prepare, on_clean
		end

	EL_SHARED_FILE_PROGRESS_LISTENER
		undefine
			default_create
		end

feature -- Tests

	test_ftp
		do
--			basic_tests
			ftp_sync_test
		end

feature {NONE} -- Implementation

	basic_tests
		local
			dir: EL_DIR_PATH; file_path: EL_FILE_PATH
		do
			log.enter ("basic_tests")

			dir := "Köln/Hauptbahnhof"
			ftp.change_home_dir
			ftp.make_directory (dir)
			assert ("Exists", ftp.directory_exists (dir))
			ftp.remove_directory (dir)
			ftp.remove_directory (dir.parent)
			assert ("Does not exist", not ftp.directory_exists (dir.parent))

			file_path := Help_pages_mint_dir + "Broadcom missing.txt"
			ftp.upload (create {EL_FTP_UPLOAD_ITEM}.make (Work_area_dir + file_path, Help_pages_mint_dir))
			assert ("Remote file exists", ftp.file_exists (file_path))
			ftp.delete_file (file_path)
			assert ("Remote file does not exist", not ftp.file_exists (file_path))
			ftp.remove_directory (Help_pages_mint_dir)
			ftp.remove_directory (Help_pages_mint_dir.parent)

			log.exit
		end

	ftp_sync_test
		local
			sync: EL_FTP_SYNC; file_list: EL_ARRAYED_LIST [EL_FILE_PATH]
		do
			log.enter ("ftp_sync_test")

			set_progress_listener (create {EL_CONSOLE_FILE_PROGRESS}.make)

			ftp.change_home_dir
			create sync.make (ftp, Ftp_sync_path, Work_area_dir)
			create file_list.make (file_set.count)
			across file_set as file loop
				file_list.extend (file.item.relative_path (Work_area_dir))
				sync.extend_modified (file_list.last)
			end

			progress_listener.set_text ("Synchronizing with " + ftp.address.host)
			track_progress (progress_listener, agent sync.upload (file_list), agent do_nothing)

			assert ("files exist", across file_list as path all ftp.file_exists (path.item) end)

			file_list.wipe_out
			sync.upload (file_list)
			assert ("Directory deleted", not ftp.directory_exists (Help_pages_mint_dir.parent))
			log.exit
		end

feature {NONE} -- Events

	on_clean
		do
			Precursor
			ftp.close
		end

	on_prepare
		local
			ftp_site: LIST [STRING]
		do
			Precursor
			ftp_site := OS.File_system.plain_text ("data/ftp-site.txt").split ('%N')
			create ftp.make_write (create {FTP_URL}.make (ftp_site.first))
			ftp.set_home_directory (ftp_site.last)

			ftp.open
			ftp.login
		end

feature {NONE} -- Implementation

	ftp: EL_FTP_PROTOCOL

feature {NONE} -- Constants

	Ftp_sync_path: EL_FILE_PATH
		once
			Result := Work_area_dir + "ftp.sync"
		end

end