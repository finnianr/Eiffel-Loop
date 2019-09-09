note
	description: "Summary description for {BACKUP_CONFIG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BACKUP_CONFIG

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			make_from_file as make
		redefine
			make, make_default
		end

	EL_MODULE_DIRECTORY

	EL_MODULE_LIO

	EL_MODULE_USER_INPUT

create
	make

feature {NONE} -- Initialization

	make (a_file_path: EL_FILE_PATH)
		do
			if a_file_path.is_absolute then
				file_path := a_file_path
			else
				file_path := Directory.current_working + a_file_path
			end
			Precursor (file_path)
			backup_list.do_all (agent {FTP_BACKUP}.set_absolute_target_dir (file_path.parent))
		end

	make_default
		do
			create backup_list.make (5)
			create archive_upload_list.make
			Precursor
		end

feature -- Access

	backup_list: EL_ARRAYED_LIST [FTP_BACKUP]

	file_path: EL_FILE_PATH

	ftp_home_dir: EL_DIR_PATH

	ftp_url: ZSTRING

feature -- Basic operations

	backup_all (ask_user_to_upload: BOOLEAN)
		local
			website: EL_FTP_WEBSITE; mega_bytes: REAL
			summator: EL_CHAIN_SUMMATOR [FTP_BACKUP, NATURAL]
		do
			backup_list.do_all (agent {FTP_BACKUP}.execute (Current))
			create summator
			mega_bytes := (summator.sum (backup_list, agent {FTP_BACKUP}.total_byte_count) / 1000_000).truncated_to_real

			if not ftp_url.is_empty and not ftp_home_dir.is_empty then
				lio.put_new_line
				if mega_bytes > Max_mega_bytes_to_send then
					lio.put_string ("WARNING, total backup size ")
					lio.put_real (mega_bytes)
					lio.put_string (" megabytes exceeds limit (")
					lio.put_real (Max_mega_bytes_to_send)
					lio.put_string (")")
					lio.put_new_line
				end
			end

			if ask_user_to_upload then
				lio.put_string ("Copy files offsite? (y/n) ")
				if User_input.entered_letter ('y') then
					create website.make (ftp_url, ftp_home_dir)
					website.login
					if website.is_logged_in then
						website.do_ftp_upload (archive_upload_list)
					end
				end
			end
		end

feature {NONE} -- Implementation

	register_default_values
		once
			Default_value_table.extend_from_array (<<
				create {FTP_BACKUP}.make
			>>)
		end

feature {FTP_BACKUP} -- Internal attributes

	archive_upload_list: LINKED_LIST [EL_FTP_UPLOAD_ITEM]

feature {NONE} -- Constants

	Max_mega_bytes_to_send: REAL = 20.0

end
