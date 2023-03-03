note
	description: "[
		Version information in Eiffel configuration XML node: `/system/target [1]/version'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-03 15:01:09 GMT (Friday 3rd March 2023)"
	revision: "17"

class
	SYSTEM_VERSION

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			field_included as is_any_field,
			element_node_fields as Empty_set,
			xml_naming as eiffel_naming
		end

create
	make_default

feature -- Access

	company: ZSTRING

	product: ZSTRING
		-- product name

feature -- Version

	build: NATURAL
		-- build number

	major: NATURAL

	minor: NATURAL

	release: NATURAL

	software: EL_SOFTWARE_VERSION
		do
			create Result.make_parts (major, minor, release, build)
		end

feature -- Element change

	set_version (a_version: EL_SOFTWARE_VERSION)
		do
			build := a_version.build
			major := a_version.major
			minor := a_version.minor
			release := a_version.maintenance
		end

end