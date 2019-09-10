note
	description: "Volume info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-10 8:34:22 GMT (Tuesday 10th September 2019)"
	revision: "3"

class
	VOLUME_INFO

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make,
			element_node_type as	Attribute_node,
			xml_names as export_default
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			name := "."
			id3_version := 2.3
			is_windows_format := True
		end

feature -- Access

	destination_dir: EL_DIR_PATH

	id3_version: REAL

	is_windows_format: BOOLEAN

	name: ZSTRING

	type: ZSTRING

feature -- Conversion

	to_gvfs: EL_GVFS_VOLUME
		do
			create Result.make_with_volume (name, is_windows_format)
			Result.enable_path_translation
		end

feature -- Element change

	set_destination_dir (a_destination_dir: EL_DIR_PATH)
		do
			destination_dir := a_destination_dir
		end

	set_name (a_name: ZSTRING)
		do
			name := a_name
		end
end
