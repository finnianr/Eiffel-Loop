note
	description: "[
		Set of files in a directory tree that can be synchronized with remote medium
		conforming to [$source EL_FILE_SYNC_MEDIUM]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-19 18:58:30 GMT (Friday 19th March 2021)"
	revision: "1"

class
	EL_FILE_SYNC_ITEM_SET

inherit
	EL_HASH_SET [EL_FILE_SYNC_ITEM]
		rename
			make as make_set
		redefine
			extend, put
		end

	EL_FILE_SYNC_CONSTANTS undefine copy, is_equal end

	EL_MODULE_FILE_SYSTEM

	EL_SHARED_DIRECTORY

create
	make

feature {NONE} -- Initialization

	make (a_local_home_dir: EL_DIR_PATH; a_extension: ZSTRING)
		local
			file_path: EL_FILE_PATH; crc_path_list: LIST [EL_FILE_PATH]
		do
			local_home_dir := a_local_home_dir; extension := a_extension
			crc_path_list := File_system.files_with_extension (local_home_dir, Crc_32)
			create previous_set.make (crc_path_list.count)
			across crc_path_list as path loop
				file_path := path.item.relative_path (a_local_home_dir)
				file_path.replace_extension (extension)
				file_path.base.remove_head (1)
				previous_set.put (create {EL_FILE_SYNC_ITEM}.make (local_home_dir, file_path))
			end
		end

feature -- Access

	extension: ZSTRING
		-- file extension

	local_home_dir: EL_DIR_PATH

feature -- Element change

	put_file (file_path: EL_FILE_PATH)
		do
			put (create {EL_FILE_SYNC_ITEM}.make (local_home_dir, file_path))
		end

	extend, put (new: EL_FILE_SYNC_ITEM)
			--
		require else
			valid_home_dir: local_home_dir ~ new.home_dir
			valid_extension: new.file_path.extension ~ extension
		do
			if {ISE_RUNTIME}.dynamic_type (new) = File_sync_item_type_id then
				put (new)
			else
				put (new.bare_item)
			end
		end

feature -- Basic operations

	update (medium: EL_FILE_SYNC_MEDIUM)
		local
			deleted_set, new_item_set: like previous_set
			local_dir: EL_DIR_PATH local_path: EL_FILE_PATH
		do
			deleted_set := previous_set.subset_exclude (agent has)

			-- remove files for deletion
			across deleted_set as set loop
				medium.remove_item (set.item)
				local_path := local_dir + set.item.file_path
				if local_path.exists then
					File_system.remove_file (local_path)
				end
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
			new_item_set := subset_exclude (agent previous_set.has)
			across File_system.parent_set (new_file_list (new_item_set), True) as list loop
				-- order of ascending step count
				medium.make_directory (list.item)
			end
			new_item_set.merge (subset_include (agent {EL_FILE_SYNC_ITEM}.is_modified))
			across new_item_set as set loop
				medium.copy_item (set.item)
			end
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
end