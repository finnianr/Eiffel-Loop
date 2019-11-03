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
	date: "2019-09-22 8:52:44 GMT (Sunday 22nd September 2019)"
	revision: "4"

deferred class
	EL_RESOURCE_INSTALL_MANAGER

inherit
	EL_DOWNLOADEABLE_RESOURCE

	EL_MODULE_FILE_SYSTEM

	EL_SHARED_DATA_TRANSFER_PROGRESS_LISTENER

	EL_MODULE_LIO

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
			Result := manifest.total_byte_count
		end

feature -- Status query

	has_error: BOOLEAN

feature -- Basic operations

	download
		local
			web: like new_connection; file_path: EL_FILE_PATH
		do
			File_system.make_directory (target_dir)
			web := new_connection
			across manifest.query_if (agent is_updated) as file loop
				progress_listener.display.set_text (progress_template #$ [file.item.name])
				file_path := target_dir + file.item.name
				web.open (url_file_item (file.item.name))
				web.download (file_path)
				web.close
				File_system.set_file_modification_time (file_path, file.item.modification_time)
				download_complete_action (file.item.name)
			end
			-- Update shared resource set
			resource_set.wipe_out
			resource_set.append (manifest)
			clean_up
		end

	download_manifest
		local
			web: like new_connection
		do
			web := new_connection
			web.open (url_manifest)
			web.read_string_get
			web.close
			if web.last_string.has_substring ("</file-list>") then
				File_system.make_directory (target_dir)
				File_system.write_plain_text (target_dir + resource_set.manifest_name, web.last_string)
				create manifest.make_from_string (web.last_string)
			else
				has_error := True
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
			across File_system.files_with_extension (target_dir, file_extension) as path loop
				if not name_set.has (path.item.base) then
					File_system.remove_file (path.item)
				end
			end
		end

	existing_modification_time (item: EL_FILE_MANIFEST_ITEM): INTEGER
		do
			Result := modification_time (target_dir, item)
		end

	installed_dir: EL_DIR_PATH
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

	modification_time (dir_path: EL_DIR_PATH; item: EL_FILE_MANIFEST_ITEM): INTEGER
		local
			path: EL_FILE_PATH
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

	target_dir: EL_DIR_PATH
		-- target directory to download items
		do
			Result := installed_dir
		end

	url_manifest: ZSTRING
		do
			Result := url_template #$ [domain, manifest_name]
		end

	url_file_item (name: ZSTRING): ZSTRING
		do
			Result := url_template #$ [domain, name]
		end

	updated_dir: EL_DIR_PATH
		-- directory for updated items
		do
			Result := resource_set.updated_dir
		end

feature {NONE} -- Deferred implementation

	domain: STRING
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

	download_complete_action: PROCEDURE [ZSTRING]

	manifest: EL_FILE_MANIFEST_LIST

end
