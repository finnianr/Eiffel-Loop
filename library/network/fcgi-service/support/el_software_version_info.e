note
	description: "Downloadable software version info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-16 10:52:16 GMT (Monday 16th November 2020)"
	revision: "2"

class
	EL_SOFTWARE_VERSION_INFO

inherit
	EVOLICITY_SERIALIZEABLE_AS_XML

create
	make

feature {NONE} -- Initialization

	make (download_dir: EL_DIR_PATH)
		do
			create software_version.make (download_dir)
			make_default
		end

feature {NONE} -- Internal attributes

	software_version: EL_CURRENT_SOFTWARE_VERSION

feature {NONE} -- Evolicity

	get_compact_version: NATURAL_32_REF
		do
			Result := software_version.compact_version.to_reference
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<  ["version",	agent get_compact_version] >>)
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