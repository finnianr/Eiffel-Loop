note
	description: "Downloadable software version info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 13:39:37 GMT (Sunday 22nd September 2024)"
	revision: "5"

class
	EL_SOFTWARE_VERSION_INFO

inherit
	EVOLICITY_SERIALIZEABLE_AS_XML

create
	make

feature {NONE} -- Initialization

	make (a_software_version: EL_CURRENT_SOFTWARE_VERSION)
		do
			software_version := a_software_version
			make_default
		end

feature {NONE} -- Internal attributes

	software_version: EL_CURRENT_SOFTWARE_VERSION

feature {NONE} -- Evolicity

	getter_function_table: like getter_functions
			--
		do
			create Result.make_assignments (<<
				["version",	agent: NATURAL_32_REF do Result := software_version.compact_version_ref end]
			>>)
		end

	Template: STRING
		once
			Result := "[
				<?xml version = "1.0" encoding = "UTF-8"?>
				<info>
					<version>$version</version>
				</info>
			]"
		end
end