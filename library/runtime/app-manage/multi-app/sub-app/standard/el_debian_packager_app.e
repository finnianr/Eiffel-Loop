note
	description: "[
		Command line interface to class [$source EL_DEBIAN_PACKAGER]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-24 9:15:49 GMT (Tuesday   24th   September   2019)"
	revision: "1"

class
	EL_DEBIAN_PACKAGER_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [EL_DEBIAN_PACKAGER]

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_optional_argument ("template", "Debian template directory", << control_template_must_exist >>),
				valid_optional_argument ("output", "Debian output directory", << directory_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("DEBIAN", Directory.current_working)
		end

	control_template_must_exist: like always_valid
		do
			Result := [
				"A Debian control template file must exist", agent (path: EL_DIR_PATH): BOOLEAN
				do
					Result := (path + "control").exists
				end
			]
		end

feature {NONE} -- Constants

	Description: STRING = "Create a Debian package in output directory for this application"

end
