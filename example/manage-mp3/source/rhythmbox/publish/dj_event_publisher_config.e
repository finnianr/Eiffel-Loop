note
	description: "DJ event publisher config"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-31 10:03:13 GMT (Saturday 31st December 2022)"
	revision: "14"

class
	DJ_EVENT_PUBLISHER_CONFIG

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make,
			element_node_fields as Empty_set,
			field_included as is_any_field,
			xml_naming as eiffel_naming
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
			www_dir := Directory.home #+ "www"
			upload := True
		end

feature -- Access

	www_dir: DIR_PATH

	html_template: ZSTRING

	html_index_template: ZSTRING

	ftp_url: STRING

	ftp_user_home: DIR_PATH

	ftp_destination_dir: ZSTRING

feature -- Status query

	upload: BOOLEAN

end