note
	description: "File synchronization with USB connected device using MTP protocol and GVFS"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-22 19:36:04 GMT (Saturday 22nd July 2023)"
	revision: "7"

class
	FILE_SYNC_COMMAND

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			make_from_file as make,
			field_included as is_any_field
		export
			{EL_COMMAND_CLIENT} make
		redefine
			new_tuple_field_table, root_node_name
		end

	EL_APPLICATION_COMMAND
		undefine
			is_equal
		end

	EL_MODULE_LIO; EL_MODULE_OS; EL_MODULE_TUPLE; EL_MODULE_TRACK

feature -- Pyxis configured

	device: TUPLE [name: ZSTRING; destination_dir: DIR_PATH; is_windows_format: BOOLEAN]

	extension: STRING

	source_dir: DIR_PATH

	crc_block_size: INTEGER

feature -- Access

	Description: STRING = "File synchronization with USB connected device using MTP protocol"

feature -- Basic operations

	execute
		local
			sync_manager: EL_FILE_SYNC_MANAGER
		do
			lio.put_labeled_string (device.name, device.destination_dir)
			lio.put_new_line_x2

			if attached new_current_set as current_set then
				if current_set.is_empty then
					create sync_manager.make_empty (device.destination_dir, device.name, extension)
				else
					create sync_manager.make (current_set)
				end
				if sync_manager.has_changes and then attached new_medium as medium then
					lio.put_labeled_string ("Updating", device.name)
					lio.put_new_line
					sync_manager.track_update (medium, Console_display)
--					sync_manager.update (medium)
					lio.put_line ("Synchronized")
				else
					lio.put_labeled_string ("Synchronized with", device.name)
					lio.put_new_line
				end
			end
		end

feature {NONE} -- Implementation

	new_current_set: EL_MEMBER_SET [EL_FILE_SYNC_ITEM]
		local
			sync_item: EL_FILE_SYNC_ITEM
		do
			if attached OS.file_list (source_dir, "*." + extension) as file_list then
				file_list.sort_by_base (True)
				create Result.make (file_list.count)
				lio.put_substitution ("Reading %S %S file checksums", [file_list.count, extension.as_upper])
				lio.put_new_line_x2

				across file_list as list loop
					lio.put_index_labeled_string (list, "Score [%S]", list.item.base)
					lio.put_new_line
					create sync_item.make (source_dir, device.name, list.item, crc_block_size)
					Result.put (sync_item)
				end
				lio.put_new_line
			end
		end

	new_medium: EL_GVFS_FILE_SYNC_MEDIUM
		do
			create Result.make (device.name, device.is_windows_format)
			Result.set_remote_home (device.destination_dir)
		end

	new_tuple_field_table: like Default_tuple_field_table
		do
			Result := "[
				device:
					name, destination_dir, is_windows_format
			]"
		end

feature {NONE} -- Constants

	Element_node_fields: STRING = "device"

	Root_node_name: STRING = "file_sync"
end