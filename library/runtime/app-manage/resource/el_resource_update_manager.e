note
	description: "[
		Manager to update a directory of file items with common extension by HTTP download.
		Updates are installed in a user directory.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-10 10:54:06 GMT (Thursday 10th January 2019)"
	revision: "2"

deferred class
	EL_RESOURCE_UPDATE_MANAGER

inherit
	EL_RESOURCE_INSTALL_MANAGER
		rename
			make as make_default
		redefine
			target_dir, existing_modification_time, download
		end

	EL_MODULE_NAMING

feature {NONE} -- Initialization

	make (a_server_manifest_date: INTEGER)
		do
			make_default
			server_manifest_date := a_server_manifest_date
		end

feature -- Basic operations

	extend (download_list: LIST [EL_DOWNLOADEABLE_RESOURCE])
		do
			download_manifest
			if not has_error then
				download_list.extend (Current)
			end
		end

	download
		do
			Precursor
			File_system.make_directory (date_file_path.parent)
			File_system.write_plain_text (date_file_path, server_manifest_date.out)
		end

feature -- Status query

	has_update: BOOLEAN
		-- The server has a newer manifest
		do
			Result := server_manifest_date > local_manifest_date
		end

feature {NONE} -- Implementation

	date_file_path: EL_FILE_PATH
		do
			Result := updated_dir + (Naming.class_as_lower_kebab (Current, 0, 1) + ".date")
		end

	existing_modification_time (item: EL_FILE_MANIFEST_ITEM): INTEGER
		do
			Result := Precursor (item)
			if Result = 0 then
				Result := modification_time (installed_dir, item)
			end
		end

	local_manifest_date: INTEGER
		do
			if date_file_path.exists then
				Result := File_system.plain_text (date_file_path).to_integer
			end
		end

	target_dir: EL_DIR_PATH
		-- target directory to download items
		do
			Result := updated_dir
		end

feature {NONE} -- Internal attributes

	server_manifest_date: INTEGER

end
