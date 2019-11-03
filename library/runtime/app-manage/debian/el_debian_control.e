note
	description: "Debian package information file: `DEBIAN/control'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-26 13:52:31 GMT (Thursday 26th September 2019)"
	revision: "1"

class
	EL_DEBIAN_CONTROL

inherit
	EVOLICITY_REFLECTIVE_SERIALIZEABLE
		rename
			escaped_field as unescaped_field,
			export_name as export_default,
			field_included as is_any_field,
			make_from_template_and_output as make,
			getter_function_table as empty_function_table
		redefine
			make_default
		end

	EL_STRING_8_CONSTANTS
		rename
			Empty_string_8 as Template
		end

	EL_MODULE_BUILD_INFO

create
	make

feature {NONE} -- Initialization

	make_default
		do
			version := Build_info.version.string
			Precursor
		end

feature -- Access

	installed_size: NATURAL

	version: STRING

feature -- Element change

	set_installed_size (a_installed_size: NATURAL)
		do
			installed_size := a_installed_size
		end

end
