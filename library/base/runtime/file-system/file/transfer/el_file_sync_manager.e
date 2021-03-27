note
	description: "[
		Manages a set of files in a common directory tree that can be synchronized with remote medium
		conforming to [$source EL_FILE_SYNC_MEDIUM]
	]"
	notes: "[
		Each synchronizeable file has a 4-byte CRC-32 checksum file associated with it. The name of this
		file is derived from the main file by prepending a dot and replacing the extension with `crc32'.
		This checksum determines if the sync-file has been modified.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-25 17:37:15 GMT (Thursday 25th March 2021)"
	revision: "5"

class
	EL_FILE_SYNC_MANAGER

inherit
	EL_FILE_SYNC_ROUTINES

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LIO

	EL_SHARED_DIRECTORY

	EL_SHARED_PROGRESS_LISTENER

	EL_MODULE_TRACK

	EL_MODULE_USER_INPUT

create
	make

feature {NONE} -- Initialization

	make (a_local_home_dir: EL_DIR_PATH; a_destination_name, a_extension: READABLE_STRING_GENERAL)
		local
			file_path: EL_FILE_PATH
		do
			local_home_dir := a_local_home_dir; destination_name := a_destination_name
			create extension.make_from_general (a_extension)
			if attached new_crc_name_dir (a_local_home_dir, a_destination_name) as checksum_dir then
				if checksum_dir.exists
					and then attached File_system.files_with_extension (checksum_dir, Crc_extension, True) as crc_path_list
				then
					create previous_set.make (crc_path_list.count)
					across crc_path_list as path loop
						file_path := path.item.relative_path (checksum_dir)
						file_path.replace_extension (extension)
						previous_set.put (create {EL_FILE_SYNC_ITEM}.make (local_home_dir, a_destination_name, file_path))
					end
				else
					File_system.make_directory (checksum_dir)
					create previous_set.make (17)
				end
			end
			create current_set.make (previous_set.count)
			maximum_retry_count := Default_maximum_retry_count
		end

feature -- Access

	current_list: ARRAYED_LIST [EL_FILE_SYNC_ITEM]
		do
			Result := current_set.to_list
		end

	destination_name: READABLE_STRING_GENERAL
		-- name for destination medium

	extension: ZSTRING
		-- file extension

	local_home_dir: EL_DIR_PATH

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

feature -- Element change

	put (new: EL_FILE_SYNC_ITEM)
			--
		require else
			valid_home_dir: local_home_dir ~ new.home_dir
			valid_extension: new.file_path.extension ~ extension
		do
			current_set.put (new)
		end

	put_file (file_path: EL_FILE_PATH)
		do
			put (create {EL_FILE_SYNC_ITEM}.make (local_home_dir, destination_name, file_path))
		end

	remove (item: EL_FILE_SYNC_ITEM)
		do
			current_set.prune (item)
		end

	set_maximum_retry_count (a_maximum_retry_count: INTEGER)
		do
			maximum_retry_count := a_maximum_retry_count
		end

feature -- Basic operations

	track_update (medium: EL_FILE_SYNC_MEDIUM; display: EL_PROGRESS_DISPLAY)
		-- update with progress tracking
		require
			medium_closed: not medium.is_open
		local
			deleted_set, new_item_set: like current_set
			make_directory_list: LIST [EL_DIR_PATH]; update_action: PROCEDURE
		do
			deleted_set := previous_set.subset_exclude (agent current_set.has)
			new_item_set := current_set.subset_exclude (agent previous_set.has)
			make_directory_list := File_system.parent_set (new_file_list (new_item_set), True)
			new_item_set.merge (current_set.subset_include (agent {EL_FILE_SYNC_ITEM}.is_modified))

			medium.open
			if display = Default_display then
				do_update (medium, deleted_set, new_item_set, make_directory_list)
			else
				update_action := agent do_update (medium, deleted_set, new_item_set, make_directory_list)
				Track.progress (display, 1 + new_item_set.count, update_action)
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

	apply (medium: EL_FILE_SYNC_MEDIUM; action: PROCEDURE)
		-- apply action to medium recovering from possible exceptions
		require
			valid_target: action.target = medium
		local
			retry_count: INTEGER
		do
			if retry_count > maximum_retry_count then
				retry_count := 0
				lio.put_labeled_string ("Operation", action.out)
				lio.put_new_line
				lio.put_substitution ("failed %S times", [maximum_retry_count])
				User_input.press_enter
			else
				action.apply
			end
		rescue
			retry_count := retry_count + 1
			medium.reset
			retry
		end

	do_update (
		medium: EL_FILE_SYNC_MEDIUM; deleted_set, copy_item_set: like current_set; make_directory_list: LIST [EL_DIR_PATH]
	)
		local
			local_dir, checksum_dir: EL_DIR_PATH
		do
			-- remove files for deletion
			across deleted_set as set loop
				apply (medium, agent medium.remove_item (set.item))
				set.item.remove
			end
			-- remove empty directories
			checksum_dir := new_crc_name_dir (local_home_dir, destination_name)
			across File_system.parent_set (new_file_list (deleted_set), False) as list loop
				-- order of descending step count
				local_dir := local_home_dir #+ list.item
				if Directory.named (local_dir).is_empty then
					apply (medium, agent medium.remove_directory (list.item))
					File_system.remove_directory (local_dir)
				end
				-- Remove empty checksums directory
				local_dir := checksum_dir #+ list.item
				if Directory.named (local_dir).is_empty then
					File_system.remove_directory (local_dir)
				end
			end
			-- create new directories
			across make_directory_list as list loop
				-- order of ascending step count
				apply (medium, agent medium.make_directory (list.item))
			end
			progress_listener.notify_tick -- One tick for completing all quick operations

			across copy_item_set as set loop
				apply (medium, agent medium.copy_item (set.item))
				set.item.store
				progress_listener.notify_tick
			end
		end

	new_file_list (item_set: EL_MEMBER_SET [EL_FILE_SYNC_ITEM]): EL_ARRAYED_LIST [EL_FILE_PATH]
		do
			create Result.make (item_set.count)
			across item_set as set loop
				Result.extend (set.item.file_path)
			end
		end

feature {NONE} -- Internal attributes

	current_set: EL_MEMBER_SET [EL_FILE_SYNC_ITEM]

	previous_set: EL_MEMBER_SET [EL_FILE_SYNC_ITEM]

	maximum_retry_count: INTEGER

feature {NONE} -- Constants

	Default_maximum_retry_count: INTEGER = 3
end