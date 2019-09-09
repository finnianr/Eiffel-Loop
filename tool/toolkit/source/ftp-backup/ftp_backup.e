note
	description: "Summary description for {FTP_BACKUP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FTP_BACKUP

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make,
			xml_names as export_default,
			element_node_type as	Attribute_node
		redefine
			on_context_exit, Except_fields
		end

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LOG

create
	make

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

	execute (config: BACKUP_CONFIG)
		require
			target_directory_exists: target_dir.exists
		local
			backup_name: ZSTRING; ftp_destination_directory: EL_DIR_PATH
			archive: ARCHIVE_FILE
		do
			log.enter ("execute")
			lio.put_path_field ("Backup", target_dir)
			lio.put_new_line

			archive_dir := config.file_path.parent.joined_dir_steps (<< Tar_gz, backup_name >>)
			File_system.make_directory (archive_dir)

			create archive.make (Current)
			total_byte_count := total_byte_count + archive.byte_count
			lio.put_path_field ("Creating archive", archive.file_path); lio.put_new_line

			if archive.file_path.exists and then not ftp_destination_path.is_empty then
				log.put_new_line
				log.put_labeled_string ("ftp-destination", ftp_destination_path)
				log.put_new_line
				config.archive_upload_list.extend (
					create {EL_FTP_UPLOAD_ITEM}.make (archive.file_path, ftp_destination_directory)
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
		end

	register_default_values
		once
			Default_value_table.extend_from_array (<<
				create {EL_ZSTRING_LIST}.make_empty
			>>)
		end

feature {NONE} -- Constants

	Except_fields: STRING
		once
			Result := Precursor + ", archive_dir, total_byte_count"
		end

	Tar_gz: ZSTRING
		once
			Result := "tar.gz"
		end
end
