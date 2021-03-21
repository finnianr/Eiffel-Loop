note
	description: "[
		Set of files in a directory tree that can be synchronized with remote medium
		conforming to [$source EL_FILE_SYNC_MEDIUM]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-20 17:04:33 GMT (Saturday 20th March 2021)"
	revision: "3"

class
	EL_FILE_SYNC_MANAGER

inherit
	EL_FILE_SYNC_CONSTANTS

	EL_MODULE_FILE_SYSTEM

	EL_SHARED_DIRECTORY

create
	make

feature {NONE} -- Initialization

	make (a_local_home_dir: EL_DIR_PATH; a_extension: READABLE_STRING_GENERAL)
		local
			file_path: EL_FILE_PATH; crc_path_list: LIST [EL_FILE_PATH]
		do
			local_home_dir := a_local_home_dir; create extension.make_from_general (a_extension)
			crc_path_list := File_system.files_with_extension (local_home_dir, Crc_32, True)
			create previous_set.make_equal (crc_path_list.count)
			across crc_path_list as path loop
				file_path := path.item.relative_path (a_local_home_dir)
				file_path.replace_extension (extension)
				file_path.base.remove_head (1)
				previous_set.put (create {EL_FILE_SYNC_ITEM}.make (local_home_dir, file_path))
			end
			create current_set.make_equal (crc_path_list.count)
		end

feature -- Access

	extension: ZSTRING
		-- file extension

	local_home_dir: EL_DIR_PATH

	current_list: ARRAYED_LIST [EL_FILE_SYNC_ITEM]
		do
			Result := current_set.to_list
		end

feature -- Element change

	put_file (file_path: EL_FILE_PATH)
		do
			put (create {EL_FILE_SYNC_ITEM}.make (local_home_dir, file_path))
		end

	put (new: EL_FILE_SYNC_ITEM)
			--
		require else
			valid_home_dir: local_home_dir ~ new.home_dir
			valid_extension: new.file_path.extension ~ extension
		do
			if {ISE_RUNTIME}.dynamic_type (new) = File_sync_item_type_id then
				current_set.put (new)
			else
				current_set.put (new.bare_item)
			end
		end

	remove (item: EL_FILE_SYNC_ITEM)
		do
			current_set.prune (item)
		end

feature -- Basic operations

	update (medium: EL_FILE_SYNC_MEDIUM)
		local
			deleted_set, new_item_set: like previous_set
			local_dir: EL_DIR_PATH
		do
			deleted_set := previous_set.subset_exclude (agent current_set.has)
			-- remove files for deletion
			across deleted_set as set loop
				medium.remove_item (set.item)
				set.item.remove
			end
			-- remove empty directories
			across File_system.parent_set (new_file_list (deleted_set), False) as list loop
				-- order of descending step count
				local_dir := local_home_dir.joined_dir_path (list.item)
				if Directory.named (local_dir).is_empty then
					medium.remove_directory (list.item)
					File_system.remove_directory (local_dir)
				end
			end
			-- create new directories
			new_item_set := current_set.subset_exclude (agent previous_set.has)
			across File_system.parent_set (new_file_list (new_item_set), True) as list loop
				-- order of ascending step count
				medium.make_directory (list.item)
			end
			new_item_set.merge (current_set.subset_include (agent {EL_FILE_SYNC_ITEM}.is_modified))
			across new_item_set as set loop
				medium.copy_item (set.item)
				set.item.store
			end
			previous_set.wipe_out
			previous_set.merge (current_set)

		end

feature {NONE} -- Implementation

	new_file_list (item_set: EL_HASH_SET [EL_FILE_SYNC_ITEM]): EL_ARRAYED_LIST [EL_FILE_PATH]
		do
			create Result.make (item_set.count)
			across item_set as set loop
				Result.extend (set.item.file_path)
			end
		end

feature {NONE} -- Internal attributes

	previous_set: EL_HASH_SET [EL_FILE_SYNC_ITEM]

	current_set: EL_HASH_SET [EL_FILE_SYNC_ITEM]
end
