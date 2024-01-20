note
	description: "[
		Manager to install/update a directory of file items with common extension by HTTP download
		A related class ${EL_RESOURCE_UPDATE_MANAGER} can be used to make an update
		manager that checks for an installs updates in a user directory.
	]"
	instructions: "[
		Implement the function `resource_set: ${EL_UPDATEABLE_RESOURCE_SET}' to provide the following data
		
		1. file extension of installed resource files
		2. installation directory for this resource
		3. user directory for any update to the resource set
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "18"

deferred class
	EL_RESOURCE_INSTALL_MANAGER

inherit
	EL_DOWNLOADEABLE_RESOURCE

	EL_MODULE_FILE; EL_MODULE_FILE_SYSTEM; EL_MODULE_LIO

	EL_SHARED_DATA_TRANSFER_PROGRESS_LISTENER

	EL_SHARED_DIRECTORY
		rename
			Directory as Shared_directory
		end

feature {NONE} -- Initialization

	make_install
		local
			time: EL_TIME_ROUTINES
		do
			create last_download_name.make_empty
			download_complete_action := agent last_download_name.share
			create manifest.make_empty
			server_manifest_date := time.unix_now (True)
			target_dir := resource_set.installed_dir
			location_options := << target_dir >>
		end

	make_update (a_server_manifest_date: INTEGER)
		do
			make_install
			server_manifest_date := a_server_manifest_date
			target_dir := resource_set.updated_dir
			location_options := << target_dir, resource_set.installed_dir >>
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

	has_update: BOOLEAN
		-- The server has a newer manifest
		do
			Result := server_manifest_date > first_non_zero (agent local_manifest_date)
		end

feature -- Basic operations

	download
		local
			web: like new_connection; file_path: FILE_PATH
			done: BOOLEAN; i: INTEGER; uri: EL_URI_ROUTINES
		do
			File_system.make_directory (target_dir)
			web := new_connection
			across manifest.query_if (agent is_updated) as l_file loop
				progress_listener.display.set_text (progress_template #$ [l_file.item.name])
				file_path := target_dir + l_file.item.name
				from i := 1; done := false until done or i > Maximum_tries loop
					web.open (url_file_item (uri.encoded_path_element (l_file.item.name, True)))
					if is_lio_enabled then
						lio.put_path_field ("Downloading %S", file_path)
						lio.put_new_line
					end
					web.download (file_path)
					web.close
					if download_succeeded (file_path) then
						File.set_modification_time (file_path, l_file.item.modification_time)
						done := True
					end
					i := i + 1
				end
				download_complete_action (l_file.item.name)
			end
			File_system.make_directory (date_file_path.parent)
			File.write_text (date_file_path, server_manifest_date.out)

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
					File.write_text (target_dir + resource_set.manifest_name, xml)
				end
				create manifest.make_from_string (xml)
			end
		end

	append_to (download_list: LIST [EL_DOWNLOADEABLE_RESOURCE])
		do
			download_manifest
			if not has_error then
				download_list.extend (Current)
			end
		end

	print_updated
		local
			updated_list: like manifest.query_if
			l_file: EL_FILE_MANIFEST_ITEM
		do
			updated_list := manifest.query_if (agent is_updated)
			lio.put_line ("UPDATED RESOURCES")
			lio.put_new_line
			if updated_list.is_empty then
				lio.put_line ("none")
			else
				across updated_list as list loop
					l_file := list.item
					lio.put_path_field ("%S", target_dir + l_file.name)
					lio.put_new_line
					print_date ("new modification_time", l_file.modification_time)
					print_date ("existing modification_time", first_non_zero (agent l_file.named_path_modification_time))
					lio.put_integer_field ("Size", l_file.byte_count)
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
		do
			if attached resource_set.file_extension as extension
				and then attached manifest.name_set as name_set
			then
				across File_system.files_with_extension (target_dir, extension, False) as path loop
					if not name_set.has (path.item.base) then
						File_system.remove_file (path.item)
					end
				end
			end
		end

	date_file_path: FILE_PATH
		do
			Result := target_dir + resource_set.manifest_name
			Result.replace_extension ("date")
		end

	download_succeeded (file_path: FILE_PATH): BOOLEAN
		do
			Result := file_path.exists and then File.byte_count (file_path) > 0
		end

	first_non_zero (a_modification_time: FUNCTION [DIR_PATH, INTEGER]): INTEGER
		-- first `a_modification_time' that returns value > 0 for `location_options'
		do
			across location_options as dir until Result > 0 loop
				Result := a_modification_time (dir.item)
			end
		end

	is_updated (item: EL_FILE_MANIFEST_ITEM): BOOLEAN
		do
			Result := item.modification_time > first_non_zero (agent item.named_path_modification_time)
		end

	local_manifest_date (location_dir: DIR_PATH): INTEGER
		do
			if attached (location_dir + date_file_path.base) as file_path and then file_path.exists then
				Result := File.plain_text (file_path).to_integer
			end
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

	url_file_item (encoded_name: READABLE_STRING_8): ZSTRING
		do
			Result := url_template #$ [domain_name, encoded_name]
		end

	url_manifest: ZSTRING
		do
			Result := url_template #$ [domain_name, resource_set.Manifest_name]
		end

feature {NONE} -- Deferred implementation

	domain_name: STRING
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

	location_options: ARRAY [DIR_PATH]

	manifest: EL_FILE_MANIFEST_LIST

	server_manifest_date: INTEGER

	target_dir: DIR_PATH
		-- target directory to download items

feature {NONE} -- Constants

	Maximum_tries: INTEGER
		once
			Result := 3
		end

end