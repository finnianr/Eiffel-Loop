note
	description: "Summary description for {FTP_BACKUP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-12 12:04:41 GMT (Friday 12th May 2017)"
	revision: "3"

class
	FTP_BACKUP

inherit
	EL_COMMAND

	EL_MODULE_EVOLICITY_TEMPLATES

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_DIRECTORY

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_LOG

	EL_MODULE_USER_INPUT

create
	make, default_create

feature {EL_COMMAND_LINE_SUB_APPLICATION} -- Initialization

	make (a_script_file_path_list: like script_file_path_list; a_ask_user_to_upload: BOOLEAN)
		do
			script_file_path_list  := a_script_file_path_list; ask_user_to_upload := a_ask_user_to_upload
			create archive_and_destination_paths.make
			create environment_variables.make_from_string_table (Execution_environment.starting_environment_variables)
		end

feature -- Access

	environment_variables: EVOLICITY_CONTEXT_IMP

feature -- Status query

	ask_user_to_upload: BOOLEAN

feature -- Basic operations

	backup_all
			--
		local
			target_directory_path: EL_DIR_PATH
		do
			log.enter ("backup_all")
			across root_node.context_list ("/backup-script/directory") as l_directory loop
				if l_directory.node.has ("path")  then
					target_directory_path := l_directory.node.string_32_at_xpath ("path")

					if not target_directory_path.is_absolute then
						target_directory_path := script_file_path.parent.joined_dir_path (target_directory_path)
					end

					if target_directory_path.exists then
						backup_directory (l_directory.node, target_directory_path)
					else
						lio.put_path_field ("ERROR: no such directory", target_directory_path)
						lio.put_new_line
					end
				else
					lio.put_line ("ERROR: missing path node")
				end
			end
			log.exit
		end

	backup_directory (directory_node: EL_XPATH_NODE_CONTEXT; target_directory_path: EL_DIR_PATH)
			--
		require
			target_directory_path_exists: target_directory_path.exists
		local
			backup_name: STRING
			archive_dir_path, ftp_destination_directory: EL_DIR_PATH
			archive_file_path: EL_FILE_PATH
			archive_file: ARCHIVE_FILE
		do
			log.enter ("backup_directory")
			lio.put_path_field ("Backup", target_directory_path)
			lio.put_new_line

			backup_name := directory_node.string_at_xpath ("name")
			if backup_name.is_empty then
				backup_name := target_directory_path.base
			end

			archive_dir_path := script_file_path.parent.joined_dir_steps (<< "tar.gz", backup_name >>)
			File_system.make_directory (archive_dir_path)

			create archive_file.make (directory_node, target_directory_path, archive_dir_path, backup_name)
			total_kilo_bytes := total_kilo_bytes + archive_file.kilo_bytes
			archive_file_path := archive_file.file_path
			lio.put_path_field ("Creating archive", archive_file_path); lio.put_new_line

			if archive_file_path.exists then
				 ftp_destination_directory := directory_node.string_32_at_xpath ("ftp-destination-path")

				if not ftp_destination_directory.is_empty then
					log.put_new_line
					log.put_path_field ("ftp-destination", ftp_destination_directory)
					log.put_new_line
					archive_and_destination_paths.extend (
						create {EL_FTP_UPLOAD_ITEM}.make (archive_file_path, ftp_destination_directory)
					)
				end
			end
			log.exit
		end

	execute
			--
		local
			total_size_mega_bytes: REAL; ftp_site_node: EL_XPATH_NODE_CONTEXT
			website: EL_FTP_WEBSITE
		do
			across script_file_path_list as l_path loop
				script_file_path := l_path.item
				if not script_file_path.is_absolute then
					script_file_path := Directory.current_working + script_file_path
				end
				set_root_node (script_file_path)
				backup_all
				total_size_mega_bytes := (total_kilo_bytes / 1000).truncated_to_real

				root_node.find_node ("/backup-script/ftp-site")
				if root_node.node_found then
					ftp_site_node := root_node.found_node
					lio.put_new_line
					if total_size_mega_bytes > Max_mega_bytes_to_send then
						lio.put_string ("WARNING, total backup size ")
						lio.put_real (total_size_mega_bytes)
						lio.put_string (" megabytes exceeds limit (")
						lio.put_real (Max_mega_bytes_to_send)
						lio.put_string (")")
						lio.put_new_line
					end
				end
			end
			if ask_user_to_upload then
				lio.put_string ("Copy files offsite? (y/n) ")
				if User_input.entered_letter ('y') then
					create website.make_from_node (ftp_site_node)
					website.login
					if website.is_logged_in then
						website.do_ftp_upload (archive_and_destination_paths)
					end
				end
			end
		end

feature -- Element change

	set_root_node (file_path: EL_FILE_PATH)
			--
		local
			xml_generator: EL_PYXIS_XML_TEXT_GENERATOR
			pyxis_medium, xml_out_medium: EL_ZSTRING_IO_MEDIUM
		do
			create pyxis_medium.make_open_write (1024)
			Evolicity_templates.put_from_file (file_path)
			Evolicity_templates.merge (file_path, environment_variables, pyxis_medium)

			create xml_out_medium.make_open_write (pyxis_medium.text.count)

			create xml_generator.make
			pyxis_medium.close
			pyxis_medium.open_read
			xml_generator.convert_stream (pyxis_medium, xml_out_medium)

			create root_node.make_from_string (xml_out_medium.text)
		end

	set_script_file_path (a_script_file_path: like script_file_path)
		do
			script_file_path  := a_script_file_path
		end

feature {NONE} -- Implementation: attributes

	archive_and_destination_paths: LINKED_LIST [EL_FTP_UPLOAD_ITEM]

	root_node: EL_XPATH_ROOT_NODE_CONTEXT

	script_file_path: EL_FILE_PATH

	script_file_path_list: ARRAYED_LIST [EL_FILE_PATH]

	total_kilo_bytes: INTEGER

feature {NONE} -- Constants

	Max_mega_bytes_to_send: REAL = 20.0

end
