note
	description: "USB file transfer using MTP protocol and GVFS"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-25 16:52:33 GMT (Saturday 25th March 2023)"
	revision: "1"

class
	FILE_TRANSFER_COMMAND

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

	EL_MODULE_LIO; EL_MODULE_OS

feature -- Pyxis configured

	device: TUPLE [name, destination_dir: ZSTRING]

	filter: ZSTRING

	source_dir: DIR_PATH

feature -- Access

	Description: STRING = "USB file transfer using MTP protocol and GVFS"

feature -- Basic operations

	execute
		do
			lio.put_labeled_string (device.name, device.destination_dir)
			lio.put_new_line_x2

			across OS.file_list (source_dir, filter) as list loop
				lio.put_path_field ("Page", list.item.relative_path (source_dir))
				lio.put_new_line
			end
		end

feature {NONE} -- Implementation

	new_tuple_field_names: like Default_tuple_field_names
		do
			create Result.make (<<
				["device", "name, destination_dir"]
			>>)
		end

feature {NONE} -- Constants

	Element_node_fields: STRING = "device"

	Root_node_name: STRING = "file_transfer"
end