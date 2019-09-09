note
	description: "DJ event publisher config"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-31 12:01:38 GMT (Saturday 31st August 2019)"
	revision: "6"

class
	DJ_EVENT_PUBLISHER_CONFIG

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make,
			xml_names as export_default,
			element_node_type as	Attribute_node,
			register_default_values as do_nothing
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

	ftp_url: ZSTRING

	ftp_user_home: ZSTRING

	ftp_destination_dir: ZSTRING

feature -- Status query

	upload: BOOLEAN

end
