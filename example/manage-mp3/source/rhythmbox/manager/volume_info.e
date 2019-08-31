note
	description: "Volume info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-31 12:44:59 GMT (Saturday 31st August 2019)"
	revision: "1"

class
	VOLUME_INFO

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make,
			xml_names as export_default,
			element_node_type as	Attribute_node
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
