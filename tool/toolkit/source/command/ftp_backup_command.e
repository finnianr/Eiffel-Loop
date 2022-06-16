note
	description: "Ftp backup command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-16 13:19:33 GMT (Thursday 16th June 2022)"
	revision: "8"

class
	FTP_BACKUP_COMMAND

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			element_node_fields as Empty_set
		redefine
			make_default, new_instance_functions, root_node_name
		end

	EL_APPLICATION_COMMAND
		undefine
			is_equal
		end

	EL_MODULE_DIRECTORY; EL_MODULE_LIO; EL_MODULE_USER_INPUT

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (config_file_path: FILE_PATH; a_ask_user_to_upload: BOOLEAN)
		do
			if config_file_path.is_absolute then
				file_path := config_file_path
			else
				file_path := Directory.current_working + config_file_path
			end
			ask_user_to_upload := a_ask_user_to_upload

			make_from_file (file_path)
			backup_list.do_all (agent {FTP_BACKUP}.set_absolute_target_dir (file_path.parent))
		end

	make_default
		do
			create backup_list.make (10)
			create archive_upload_list.make (0)
			new_ftp_backup := agent: FTP_BACKUP do create Result.make (Current) end
			Precursor
		end

feature -- Pyxis configured

	backup_list: EL_ARRAYED_LIST [FTP_BACKUP]

	file_path: FILE_PATH

	ftp_home_dir: DIR_PATH

	ftp_url: STRING

feature -- Access

	Description: STRING = "Create tar.gz backups and upload them with FTP protocol"

	archive_upload_list: EL_ARRAYED_LIST [EL_FTP_UPLOAD_ITEM]

feature -- Basic operations

	execute
		local
			website: EL_FTP_WEBSITE; mega_bytes: REAL
		do
			archive_upload_list.wipe_out

			across backup_list as backup loop
				backup.item.create_archive (archive_upload_list)
			end
			mega_bytes := (backup_list.sum_natural (agent {FTP_BACKUP}.total_byte_count) / 1000_000).truncated_to_real

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
		end

feature {NONE} -- Implementation

	new_instance_functions: EL_ARRAYED_LIST [FUNCTION [ANY]]
		-- array of functions returning a new value for result type
		do
			Result := << new_ftp_backup >>
		end

feature {NONE} -- Implementation: attributes

	ask_user_to_upload: BOOLEAN

	new_ftp_backup: FUNCTION [ANY]
		-- We need to be able to set the target of this result from `make'

feature {NONE} -- Constants

	Max_mega_bytes_to_send: REAL = 20.0

	Root_node_name: STRING = "backup_config"
end