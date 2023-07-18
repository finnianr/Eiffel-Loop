note
	description: "FTP backup"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-18 16:31:36 GMT (Tuesday 18th July 2023)"
	revision: "15"

class
	FTP_BACKUP

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			element_node_fields as Empty_set,
			field_included as is_any_field,
			xml_naming as eiffel_naming
		redefine
			on_context_exit, new_transient_fields
		end

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make (a_config: FTP_BACKUP_COMMAND)
		do
			config := a_config
			make_default
		end

feature -- Access

	archive_dir: DIR_PATH

	exclude_list: EL_ZSTRING_LIST

	ftp_destination_path: ZSTRING

	gpg_key: ZSTRING

	include_list: EL_ZSTRING_LIST

	max_versions: INTEGER

	name: ZSTRING

	target_dir: DIR_PATH

	total_byte_count: NATURAL

feature -- Element change

	set_absolute_target_dir (config_dir: DIR_PATH)
		do
			if not target_dir.is_absolute then
				target_dir := config_dir #+ target_dir
			end
		end

feature -- Basic operations

	create_archive (archive_upload_list: LIST [EL_FTP_UPLOAD_ITEM])
		require
			target_directory_exists: target_dir.exists
		local
			archive: ARCHIVE_FILE
		do
			lio.put_path_field ("Backup", target_dir)
			lio.put_new_line

			File_system.make_directory (archive_dir)

			create archive.make (Current)
			total_byte_count := total_byte_count + archive.byte_count

			if archive.file_path.exists and then not ftp_destination_path.is_empty then
				lio.put_new_line
				lio.put_labeled_string ("ftp_destination", ftp_destination_path)
				lio.put_new_line
				archive_upload_list.extend (create {EL_FTP_UPLOAD_ITEM}.make (archive.file_path, ftp_destination_path))
			end
		end

feature {NONE} -- Implementation

	new_transient_fields: STRING
		do
			Result := Precursor + ", total_byte_count, config"
		end

	on_context_exit
		do
			if name.is_empty then
				name := target_dir.base
			end
			archive_dir := config.file_path.parent.joined_dir_steps (<< Tar_gz, name >>)
		end

feature {NONE} -- Internal attributes

	config: FTP_BACKUP_COMMAND

feature {NONE} -- Constants

	Tar_gz: ZSTRING
		once
			Result := "tar.gz"
		end
end