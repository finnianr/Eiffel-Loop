note
	description: "DJ event publisher config"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-23 10:26:43 GMT (Tuesday 23rd March 2021)"
	revision: "8"

class
	DJ_EVENT_PUBLISHER_CONFIG

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make,
			xml_names as export_default,
			element_node_type as	Attribute_node
		redefine
			make
		end

	EL_MODULE_DIRECTORY

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			www_dir := Directory.home.joined_dir_path ("www")
			upload := True
		end

feature -- Access

	www_dir: EL_DIR_PATH

	html_template: ZSTRING

	html_index_template: ZSTRING

	ftp_url: STRING

	ftp_user_home: EL_DIR_PATH

	ftp_destination_dir: ZSTRING

feature -- Status query

	upload: BOOLEAN

end