note
	description: "[
		Manager to install a directory of file items with common extension by HTTP download
		A related class [$source EL_RESOURCE_UPDATE_MANAGER] can be used to make an update
		manager that checks for an installs updates in a user directory.
	]"
	instructions: "[
		Use the class [source EL_UPDATEABLE_RESOURCE_SET] to to create a shared instance of the resource
		to be managed for use in your application. Define `resource_set' to make it accessible to a manager class.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:54:05 GMT (Monday 3rd January 2022)"
	revision: "10"

deferred class
	EL_RESOURCE_INSTALL_MANAGER

inherit
	EL_DOWNLOADEABLE_RESOURCE

	EL_MODULE_FILE_SYSTEM

	EL_SHARED_DATA_TRANSFER_PROGRESS_LISTENER

	EL_MODULE_LIO

	EL_SHARED_DIRECTORY
		rename
			Directory as Shared_directory
		end

feature {NONE} -- Initialization

	make
		do
			create last_download_name.make_empty
			download_complete_action := agent last_download_name.share
			create manifest.make_empty
		end

feature -- Access

	last_download_name: ZSTRING

	total_bytes: INTEGER
		do
			if manifest.is_empty then
				download_manifest
			end
			Result := manifest.total_byte_count
		end

feature -- Status query

	has_error: BOOLEAN

feature -- Basic operations

	download
		local
			web: like new_connection; file_path: FILE_PATH
			done: BOOLEAN; i: INTEGER
		do
			File_system.make_directory (target_dir)
			web := new_connection
			across manifest.query_if (agent is_updated) as file loop
				progress_listener.display.set_text (progress_template #$ [file.item.name])
				file_path := target_dir + file.item.name
				from i := 1; done := false until done or i > Maximum_tries loop
					web.open (url_file_item (file.item.name))
					if is_lio_enabled then
						lio.put_path_field ("Downloading", file_path)
						lio.put_new_line
					end
					web.download (file_path)
					web.close
					if download_succeeded (file_path) then
						File_system.set_file_modification_time (file_path, file.item.modification_time)
						done := True
					end
					i := i + 1
				end
				download_complete_action (file.item.name)
			end
			-- Update shared resource set
			resource_set.wipe_out
			resource_set.append (manifest)
			clean_up
		end

	download_manifest
		local
			xml: STRING
		do
			xml := manifest_xml
			if xml.is_empty then
				has_error := True
			else
				File_system.make_directory (target_dir)
				if Shared_directory.named (target_dir).is_writable then
					File_system.write_plain_text (target_dir + resource_set.manifest_name, xml)
				end
				create manifest.make_from_string (xml)
			end
		end

	print_updated
		local
			updated_list: like manifest.query_if
		do
			updated_list := manifest.query_if (agent is_updated)
			lio.put_line ("UPDATED RESOURCES")
			lio.put_new_line
			if updated_list.is_empty then
				lio.put_line ("none")
			else
				across updated_list as file loop
					lio.put_path_field ("", target_dir + file.item.name)
					lio.put_new_line
					print_date ("new modification_time", file.item.modification_time)
					print_date ("existing modification_time", existing_modification_time (file.item))
					lio.put_integer_field ("Size", file.item.byte_count)
					lio.put_new_line
					lio.put_new_line
				end
			end
		end

feature -- Element change

	set_download_complete_action (a_download_complete_action: like download_complete_action)
		do
			download_complete_action := a_download_complete_action
		end

feature {NONE} -- Implementation

	clean_up
		-- remove files not in manifest
		local
			name_set: like manifest.name_set
		do
			name_set := manifest.name_set
			across File_system.files_with_extension (target_dir, file_extension, False) as path loop
				if not name_set.has (path.item.base) then
					File_system.remove_file (path.item)
				end
			end
		end

	download_succeeded (file_path: FILE_PATH): BOOLEAN
		do
			Result := file_path.exists and then File_system.file_byte_count (file_path) > 0
		end

	existing_modification_time (item: EL_FILE_MANIFEST_ITEM): INTEGER
		do
			Result := modification_time (target_dir, item)
		end

	installed_dir: DIR_PATH
		-- directory for installed items
		do
			Result := resource_set.installed_dir
		end

	is_updated (item: EL_FILE_MANIFEST_ITEM): BOOLEAN
		do
			Result := item.modification_time > existing_modification_time (item)
		end

	manifest_name: ZSTRING
		do
			Result := resource_set.Manifest_name
		end

	manifest_xml: STRING
		local
			web: like new_connection
		do
			web := new_connection
			web.open (url_manifest)
			web.read_string_get
			web.close
			if web.last_string.has_substring ("</file-list>") then
				Result := web.last_string
			else
				create Result.make_empty
			end
		end

	modification_time (dir_path: DIR_PATH; item: EL_FILE_MANIFEST_ITEM): INTEGER
		local
			path: FILE_PATH
		do
			path := dir_path + item.name
			if path.exists then
				Result := path.modification_time
			end
		end

	new_connection: EL_HTTP_CONNECTION
		do
			create Result.make
		end

	print_date (name: STRING; modified: INTEGER)
		local
			date: DATE_TIME
		do
			create date.make_from_epoch (modified)
			lio.put_labeled_string (name, date.formatted_out ("dd mmm yyyy [0]hh:[0]mi:[0]ss"))
			lio.put_new_line
		end

	target_dir: DIR_PATH
		-- target directory to download items
		do
			Result := installed_dir
		end

	updated_dir: DIR_PATH
		-- directory for updated items
		do
			Result := resource_set.updated_dir
		end

	url_file_item (name: ZSTRING): ZSTRING
		do
			Result := url_template #$ [domain_name, name]
		end

	url_manifest: ZSTRING
		do
			Result := url_template #$ [domain_name, manifest_name]
		end

feature {NONE} -- Deferred implementation

	domain_name: STRING
		deferred
		end

	file_extension: STRING
		deferred
		end

	progress_template: ZSTRING
		deferred
		ensure
			has_place_holder: Result.has ('%S')
		end

	resource_set: EL_UPDATEABLE_RESOURCE_SET
		deferred
		end

	url_template: ZSTRING
		deferred
		end

feature {NONE} -- Internal attributes

	download_complete_action: PROCEDURE [READABLE_STRING_GENERAL]

	manifest: EL_FILE_MANIFEST_LIST

feature {NONE} -- Constants

	Maximum_tries: INTEGER
		once
			Result := 3
		end

end
