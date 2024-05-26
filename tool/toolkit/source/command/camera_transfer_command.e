note
	description: "[
		Transfer multi-media files from USB connected camera device using MTP protocol and GVFS
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-26 9:41:25 GMT (Sunday 26th May 2024)"
	revision: "12"

class
	CAMERA_TRANSFER_COMMAND

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

	EL_MODULE_DATE_TIME; EL_MODULE_FILE; EL_MODULE_FILE_SYSTEM; EL_MODULE_LIO

	EL_MODULE_TUPLE

feature -- Pyxis configured

	alias_name: ZSTRING

	date_string_offset: INTEGER

	destination_dir: DIR_PATH

	device: TUPLE [name: ZSTRING; is_windows_format: BOOLEAN]

	extensions: STRING
		-- file extensions separated by ';'

	source_dir: DIR_PATH

feature -- Access

	Description: STRING = "Transfer multi-media files from USB connected camera device"

feature -- Basic operations

	execute
		local
			volume: EL_GVFS_VOLUME; extension: STRING
		do
			lio.put_string_field (device.name, source_dir.to_string)
			lio.put_new_line_x2

			create volume.make (device.name, device.is_windows_format)
			if volume.is_mounted then
				across extensions.split (';') as list loop
					extension := list.item
					lio.put_labeled_string ("Extension", extension)
					lio.put_new_line
					if extension.count > 0
						and then attached volume.file_list (source_dir, extension) as file_list
						and then file_list.count > 0
					then
						transfer (volume, file_list)
						lio.put_new_line
					else
						lio.put_line ("Nothing to transfer")
					end
				end
			else
				lio.put_line ("Device is not mounted")
				lio.put_new_line
			end
		end

feature {NONE} -- Factory

	new_date_parts (base: ZSTRING): EL_ZSTRING_LIST
		do
			create Result.make_from_substrings (base, date_string_offset + 1, << 4, 2, 2 >>)
		end

	new_date_sort (date_parts: EL_ZSTRING_LIST): ZSTRING
		require
			valid_character_count: date_parts.character_count = 8
		local
			month_name, year, month: ZSTRING; month_index: INTEGER
		do
			year := date_parts [1]
			month := date_parts [2]
			month_index := month.to_integer
			if Date_time.Months_text.valid_index (month_index) then
				month_name := Date_time.Months_text [month_index]
				month_name.to_proper
			else
				month_name := "???"
			end
			Result := Date_sort_template #$ [alias_name, year, month, month_name]
		end

	new_tuple_field_table: like Default_tuple_field_table
		do
			Result := "[
				device:
					name, is_windows_format
			]"
		end

feature {NONE} -- Implementation

	transfer (volume: EL_GVFS_VOLUME; file_list: EL_FILE_PATH_LIST)
		local
			copied_file_size: INTEGER; sorted_dir: DIR_PATH; file_path: FILE_PATH
		do
			across file_list as list loop
				if attached new_date_parts (list.item.base) as date_parts
					and then date_parts.character_count = 8
					and then attached volume.file_info (list.item) as info
				then
					lio.put_index_labeled_string (list, "Transfering %S", list.item.to_string)
					lio.put_new_line
					sorted_dir := destination_dir #+ new_date_sort (date_parts)
					lio.put_path_field ("to", sorted_dir)
					lio.put_new_line

					File_system.make_directory (sorted_dir)
					Volume.copy_file_from (list.item, sorted_dir)
					file_path := sorted_dir + list.item.base
					copied_file_size :=  File.byte_count (file_path)
					if info.size = copied_file_size then
						File.set_modification_time (file_path, info.modified)
						lio.put_line ("Copy OK")
						volume.remove_file (list.item)
					else
						lio.put_labeled_substitution (
							"Differing", "Actual: %S, Copied %S", [info.size, copied_file_size]
						)
						lio.put_new_line
					end
				else
					lio.put_path_field ("Ignoring file", list.item)
					lio.put_new_line
				end
			end
		end

feature {NONE} -- Constants

	Date_sort_template: ZSTRING
		once
			Result := "%S/%S/%S-%S"
		end

	Element_node_fields: STRING = "device"

	Root_node_name: STRING = "camera"

end