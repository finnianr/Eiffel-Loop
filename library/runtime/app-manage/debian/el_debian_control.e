note
	description: "Summary description for {EL_DEBIAN_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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

	installed_size: INTEGER

	version: STRING

end
