note
	description: "[
		Manages a set of files in a common directory tree that can be synchronized with remote medium
		conforming to ${EL_FILE_SYNC_MEDIUM}
	]"
	notes: "[
		Each synchronizeable file has a ${NATURAL_32} CRC-32 checksum file associated with it. The
		checksums are stored a separate tree mirroring the file item locations.
				
			{${EL_FILE_SYNC_ITEM}}.digest_path
		
		This checksum determines if the sync-item has been modified.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-24 6:51:47 GMT (Thursday 24th August 2023)"
	revision: "15"

class
	EL_FILE_SYNC_MANAGER

inherit
	EL_FILE_SYNC_ROUTINES

	EL_SHARED_DIRECTORY; EL_MODULE_FILE_SYSTEM; EL_MODULE_LIO; EL_MODULE_USER_INPUT

	EL_MODULE_TRACK

	EL_SHARED_PROGRESS_LISTENER

	EL_ZSTRING_CONSTANTS

create
	make, make_empty

feature {NONE} -- Initialization

	make (a_current_set: like current_set)
		require
			at_least_one_item: a_current_set.count > 0
		do
			current_set := a_current_set
			a_current_set.start
			if not a_current_set.off and then attached a_current_set.iteration_item as first_item then
				local_home_dir := first_item.home_dir ; destination_name := first_item.destination_name
				extension := first_item.file_path.extension
				crc_block_size := first_item.crc_block_size
			else
				create local_home_dir
				destination_name := Empty_string; extension := Empty_string
			end

			previous_set := new_previous_set
		end

	make_empty (a_local_home_dir: DIR_PATH; a_destination_name, a_extension: READABLE_STRING_GENERAL)
		do
			local_home_dir := a_local_home_dir; destination_name := a_destination_name
			create extension.make_from_general (a_extension)
			create current_set.make (0)
			previous_set := new_previous_set
		end

feature -- Access

	crc_block_size: INTEGER
		-- count of leading bytes in file to add to CRC checksum

	current_list: ARRAYED_LIST [EL_FILE_SYNC_ITEM]
		do
			Result := current_set.to_list
		end

	destination_name: READABLE_STRING_GENERAL
		-- name for destination medium

	extension: ZSTRING
		-- file extension

	local_home_dir: DIR_PATH

feature -- Status query

	has_changes: BOOLEAN
		-- `True' if their are changes to be synchronized with medium
		do
			if not current_set.is_superset (previous_set) then
				Result := True
			else
				Result := across current_set as set some
					set.item.is_modified or else not previous_set.has (set.item)
				end
			end
		end

feature -- Basic operations

	track_update (medium: EL_FILE_SYNC_MEDIUM; display: EL_PROGRESS_DISPLAY)
		-- update with progress tracking
		local
			deleted_set, new_item_set: like current_set
			update_action: PROCEDURE
		do
			deleted_set := previous_set.subset_exclude (agent current_set.has)
			new_item_set := current_set.subset_exclude (agent previous_set.has)
			new_item_set.merge (current_set.subset_include (agent {EL_FILE_SYNC_ITEM}.is_modified))

			if not medium.is_open then
				medium.open
			end
			if display = Default_display then
				do_update (medium, deleted_set, new_item_set)
			else
				update_action := agent do_update (medium, deleted_set, new_item_set)
				Track.progress (display, deleted_set.count + new_item_set.count, update_action)
			end
			medium.close
			previous_set.wipe_out
			previous_set.merge (current_set)
		end

	update (medium: EL_FILE_SYNC_MEDIUM)
		-- update with no progress tracking
		do
			track_update (medium, Default_display)
		end

feature {NONE} -- Implementation

	do_copy_update (medium: EL_FILE_SYNC_MEDIUM; copy_item_set: like current_set)
		-- copy in groups of files from same location starting with locations with
		-- fewest number of steps (minimizes directory creation operations)
		local
			dir_group_table: EL_FUNCTION_GROUP_TABLE [EL_FILE_SYNC_ITEM, DIR_PATH]
			dir_list: EL_ARRAYED_LIST [DIR_PATH]
		do
			create dir_group_table.make_from_list (agent {EL_FILE_SYNC_ITEM}.location_dir, copy_item_set.to_list)
			create dir_list.make_from_array (dir_group_table.current_keys)
			dir_list.order_by (agent {DIR_PATH}.step_count, True)

			across dir_list as dir loop
				if dir_group_table.has_key (dir.item) then
					medium.make_directory (dir.item)
					across dir_group_table.found_list as list loop
						medium.copy_item (list.item)
						list.item.store
						progress_listener.notify_tick
					end
				end
			end
		end

	do_update (medium: EL_FILE_SYNC_MEDIUM; deleted_set, copy_item_set: like current_set)
		local
			local_dir, checksum_dir: DIR_PATH
		do
--			Do copy first because no point in removing directory only to immediately add back in again
			do_copy_update (medium, copy_item_set)

			-- remove files for deletion
			across deleted_set as set loop
				medium.remove_item (set.item)
				set.item.remove
			end
			-- remove empty directories
			checksum_dir := new_crc_sync_dir (local_home_dir, destination_name)
			across File_system.parent_set (new_file_list (deleted_set), False) as list loop
				-- order of descending step count
				local_dir := local_home_dir #+ list.item
				if Directory.named (local_dir).is_empty then
					medium.remove_directory (list.item)
					File_system.remove_directory (local_dir)
					progress_listener.notify_tick
				end
				-- Remove empty checksums directory
				local_dir := checksum_dir #+ list.item
				if Directory.named (local_dir).is_empty then
					File_system.remove_directory (local_dir)
				end
			end
		end

feature {NONE} -- Factory

	new_file_list (item_set: EL_MEMBER_SET [EL_FILE_SYNC_ITEM]): EL_ARRAYED_LIST [FILE_PATH]
		do
			create Result.make (item_set.count)
			across item_set as set loop
				Result.extend (set.item.file_path)
			end
		end

	new_previous_set: like current_set
		local
			file_path: FILE_PATH; current_table: HASH_TABLE [EL_FILE_SYNC_ITEM, FILE_PATH]
			sync_item: EL_FILE_SYNC_ITEM
		do
			create current_table.make_equal (current_set.count)
			across current_set as set loop
				current_table.extend (set.item, set.item.digest_path)
			end

			if attached new_crc_sync_dir (local_home_dir, destination_name) as checksum_dir then
				if checksum_dir.exists
					and then attached File_system.files_with_extension (checksum_dir, Crc_extension, True) as crc_path_list
				then
					create Result.make (crc_path_list.count)
					across crc_path_list as path loop
						if current_table.has_key (path.item) then
							Result.put (current_table.found_item)
						else
							file_path := path.item.relative_path (checksum_dir)
							file_path.replace_extension (extension)
							create sync_item.make (local_home_dir, destination_name, file_path, crc_block_size)
							Result.put (sync_item)
						end
					end
				else
					File_system.make_directory (checksum_dir)
					create Result.make (17)
				end
			end
		end

feature {NONE} -- Internal attributes

	current_set: EL_MEMBER_SET [EL_FILE_SYNC_ITEM]

	maximum_retry_count: INTEGER

	previous_set: EL_MEMBER_SET [EL_FILE_SYNC_ITEM]

end