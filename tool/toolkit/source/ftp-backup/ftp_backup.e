note
	description: "FTP backup"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-26 14:24:44 GMT (Saturday 26th June 2021)"
	revision: "5"

class
	FTP_BACKUP

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			xml_names as export_default,
			element_node_type as	Attribute_node
		redefine
			on_context_exit, Transient_fields
		end

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LOG

create
	make

feature {NONE} -- Initialization

	make (a_config: BACKUP_CONFIG)
		do
			config := a_config
			make_default
		end

feature -- Access

	archive_dir: EL_DIR_PATH

	exclude_list: EL_ZSTRING_LIST

	ftp_destination_path: ZSTRING

	gpg_key: ZSTRING

	include_list: EL_ZSTRING_LIST

	max_versions: INTEGER

	name: ZSTRING

	target_dir: EL_DIR_PATH

	total_byte_count: NATURAL

feature -- Element change

	set_absolute_target_dir (config_dir: EL_DIR_PATH)
		do
			if not target_dir.is_absolute then
				target_dir := config_dir.joined_dir_path (target_dir)
			end
		end

feature -- Basic operations

	execute
		require
			target_directory_exists: target_dir.exists
		local
			archive: ARCHIVE_FILE
		do
			log.enter ("execute")
			lio.put_path_field ("Backup", target_dir)
			lio.put_new_line

			File_system.make_directory (archive_dir)

			create archive.make (Current)
			total_byte_count := total_byte_count + archive.byte_count

			if archive.file_path.exists and then not ftp_destination_path.is_empty then
				log.put_new_line
				log.put_labeled_string ("ftp_destination", ftp_destination_path)
				log.put_new_line
				config.archive_upload_list.extend (
					create {EL_FTP_UPLOAD_ITEM}.make (archive.file_path, ftp_destination_path)
				)
			end
			log.exit
		end

feature {NONE} -- Implementation

	on_context_exit
		do
			if name.is_empty then
				name := target_dir.base
			end
			archive_dir := config.file_path.parent.joined_dir_steps (<< Tar_gz, name >>)
		end

feature {NONE} -- Internal attributes

	config: BACKUP_CONFIG

feature {NONE} -- Constants

	Transient_fields: STRING
		once
			Result := "total_byte_count, config"
		end

	Tar_gz: ZSTRING
		once
			Result := "tar.gz"
		end
end