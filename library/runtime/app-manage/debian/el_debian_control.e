note
	description: "Debian package information file: `DEBIAN/control'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-09-28 12:13:46 GMT (Wednesday 28th September 2022)"
	revision: "3"

class
	EL_DEBIAN_CONTROL

inherit
	EVOLICITY_REFLECTIVE_SERIALIZEABLE
		rename
			escaped_field as unescaped_field,
			field_included as is_any_field,
			foreign_naming as eiffel_naming,
			make_from_template_and_output as make,
			getter_function_table as empty_function_table,
			Empty_string_8 as Template
		redefine
			make_default
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