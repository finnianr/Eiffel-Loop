note
	description: "FTP backup command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-25 9:24:47 GMT (Friday 25th August 2023)"
	revision: "12"

class
	FTP_BACKUP_COMMAND

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			field_included as is_any_field
		redefine
			new_instance_functions, root_node_name
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

feature -- Pyxis configured

	backup_list: EL_ARRAYED_LIST [FTP_BACKUP]

	file_path: FILE_PATH

	ftp_site: EL_FTP_CONFIGURATION

feature -- Access

	Description: STRING = "Create tar.gz backups and upload them with FTP protocol"

	archive_upload_list: EL_ARRAYED_LIST [EL_FTP_UPLOAD_ITEM]

feature -- Basic operations

	execute
		local
			website: EL_FTP_WEBSITE; sum_mega_bytes: REAL
		do
			archive_upload_list.wipe_out

			across backup_list as backup loop
				backup.item.create_archive (archive_upload_list)
			end
			sum_mega_bytes := backup_list.sum_real (agent {FTP_BACKUP}.size_megabytes)

			lio.put_new_line
			if sum_mega_bytes > Max_mega_bytes_to_send then
				lio.put_string ("WARNING, total backup size ")
				lio.put_real (sum_mega_bytes)
				lio.put_string (" megabytes exceeds limit (")
				lio.put_real (Max_mega_bytes_to_send)
				lio.put_string (")")
				lio.put_new_line
			end

			if ask_user_to_upload then
				if User_input.approved_action_y_n ("Copy files offsite?") then
					ftp_site.authenticate (Void)

					create website.make (ftp_site)
					website.login
					if website.is_logged_in then
						website.do_ftp_upload (archive_upload_list)
					end
				end
			end
		end

feature {NONE} -- Implementation

	new_instance_functions: like Default_initial_values
		-- array of functions returning a new value for result type
		do
			create Result.make_from_array (<<
				agent: FTP_BACKUP do create Result.make (Current) end
			>>)
		end

feature {NONE} -- Internal attributes

	ask_user_to_upload: BOOLEAN

feature {NONE} -- Constants

	Element_node_fields: STRING = "backup_list"

	Max_mega_bytes_to_send: REAL = 20.0

	Root_node_name: STRING = "backup_config"
end