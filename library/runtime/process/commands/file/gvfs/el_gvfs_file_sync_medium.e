note
	description: "[
		[https://www.commandlinux.com/man-page/man7/gvfs.7.html GIO virtual file system]
		as file synchronized medium destination
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-08 10:49:39 GMT (Wednesday 8th May 2024)"
	revision: "3"

class
	EL_GVFS_FILE_SYNC_MEDIUM

inherit
	EL_FILE_SYNC_MEDIUM

	EL_GVFS_VOLUME
		rename
			extend_uri_root as set_remote_home,
			reset_uri_root as reset
		export
			{NONE} all
			{ANY} directory_exists, remove_directory, set_remote_home
		end

	EL_MODULE_FILE_SYSTEM; EL_MODULE_FILE

create
	make, make_default, make_with_mounts

feature -- Status query

	has_error: BOOLEAN
		do
		end

	is_open: BOOLEAN

feature -- Basic operations

	close
		do
			is_open := False
		end

	copy_item (item: EL_FILE_SYNC_ITEM)
		-- copy item
		do
			copy_file_to (item.source_path, item.file_path.parent)
		end

	open
		do
			is_open := True
		end

	remove_item (item: EL_FILE_SYNC_ITEM)
		-- remove old item
		do
			remove_file (item.file_path)
		end

end