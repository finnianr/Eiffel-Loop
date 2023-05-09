note
	description: "[
		Transfer multi-media files from USB connected camera device using MTP protocol and GVFS
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-09 17:18:12 GMT (Tuesday 9th May 2023)"
	revision: "6"

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
			new_tuple_field_names, root_node_name
		end

	EL_APPLICATION_COMMAND
		undefine
			is_equal
		end

	EL_MODULE_LIO; EL_MODULE_OS; EL_MODULE_TUPLE

feature -- Pyxis configured

	device: TUPLE [name: ZSTRING; is_windows_format: BOOLEAN]

	destination_dir: DIR_PATH

	extension: STRING

	source_dir: DIR_PATH

feature -- Access

	Description: STRING = "Transfer multi-media files from USB connected camera device"

feature -- Basic operations

	execute
		local
			volume: EL_GVFS_VOLUME
		do
			lio.put_labeled_string (device.name, source_dir)
			lio.put_new_line_x2

			create volume.make (device.name, device.is_windows_format)
			across volume.file_list (source_dir, extension) as list loop
				lio.put_integer_field (list.item.to_string, volume.file_size (list.item))
				lio.put_new_line
			end
		end

feature {NONE} -- Implementation

	new_tuple_field_names: like Default_tuple_field_names
		do
			create Result.make (<<
				["device", "name, is_windows_format"]
			>>)
		end

feature {NONE} -- Constants

	Element_node_fields: STRING = "device"

	Root_node_name: STRING = "camera"
end