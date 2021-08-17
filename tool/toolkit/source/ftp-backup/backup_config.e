note
	description: "Backup config"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-16 13:39:34 GMT (Monday 16th August 2021)"
	revision: "5"

class
	BACKUP_CONFIG

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			make_from_file as make,
			element_node_type as	Attribute_node
		redefine
			make, make_default, new_instance_functions
		end

	EL_MODULE_DIRECTORY

	EL_MODULE_LOG

	EL_MODULE_USER_INPUT

create
	make, make_default

feature {NONE} -- Initialization

	make (a_file_path: EL_FILE_PATH)
		do
			if a_file_path.is_absolute then
				file_path := a_file_path
			else
				file_path := Directory.current_working + a_file_path
			end
			create backup_list.make (10)
			new_ftp_backup.set_target (Current)
			Precursor (file_path)
			backup_list.do_all (agent {FTP_BACKUP}.set_absolute_target_dir (file_path.parent))
		end

	make_default
		do
			create archive_upload_list.make
			Precursor
		end

feature -- Access

	backup_list: EL_ARRAYED_LIST [FTP_BACKUP]

	file_path: EL_FILE_PATH

	ftp_home_dir: EL_DIR_PATH

	ftp_url: STRING

feature -- Basic operations

	backup_all (ask_user_to_upload: BOOLEAN)
		local
			website: EL_FTP_WEBSITE; mega_bytes: REAL
			summator: EL_CHAIN_SUMMATOR [FTP_BACKUP, NATURAL]
		do
			log.enter ("backup_all")
			across backup_list as backup loop
				backup.item.execute
			end
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
				if User_input.approved_action_y_n ("Copy files offsite?") then
					create website.make ([ftp_url, ftp_home_dir])
					website.login
					if website.is_logged_in then
						website.do_ftp_upload (archive_upload_list)
					end
				end
			end
			log.exit
		end

feature {NONE} -- Implementation

	new_instance_functions: EL_ARRAYED_LIST [FUNCTION [ANY]]
		-- array of functions returning a new value for result type
		do
			Result := <<
				new_ftp_backup
			>>
		end

	new_ftp_backup: FUNCTION [ANY]
		-- We need to be able to set the target of this result from `make'
		once
			Result := agent: FTP_BACKUP do create Result.make (Current) end
		end

feature {FTP_BACKUP} -- Internal attributes

	archive_upload_list: LINKED_LIST [EL_FTP_UPLOAD_ITEM]

feature {NONE} -- Constants

	Max_mega_bytes_to_send: REAL = 20.0

end