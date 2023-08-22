note
	description: "DJ event publisher config"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-22 14:49:34 GMT (Tuesday 22nd August 2023)"
	revision: "15"

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

	ftp_site: EL_FTP_CONFIGURATION

	ftp_destination_dir: ZSTRING

feature -- Status query

	upload: BOOLEAN

end