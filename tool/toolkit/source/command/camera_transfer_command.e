note
	description: "[
		Transfer multi-media files from USB connected camera device using MTP protocol and GVFS
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-26 15:00:01 GMT (Sunday 26th May 2024)"
	revision: "13"

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
		-- offset in file name to characters specifying a date formatted as "yyyymm"

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
			volume: EL_GVFS_CAMERA_VOLUME
		do
			lio.put_string_field (device.name, source_dir.to_string)
			lio.put_new_line_x2

			create volume.make (alias_name, device.name, device.is_windows_format)
			volume.set_date_string_offset (date_string_offset)
			if volume.is_mounted then
				across extensions.split (';') as list loop
					volume.do_collated_transfer (source_dir, destination_dir, list.item)
				end
			else
				lio.put_line ("Device is not mounted")
				lio.put_new_line
			end
		end

feature {NONE} -- Factory

	new_tuple_field_table: like Default_tuple_field_table
		do
			Result := "[
				device:
					name, is_windows_format
			]"
		end

feature {NONE} -- Constants

	Element_node_fields: STRING = "device"

	Root_node_name: STRING = "camera"

end