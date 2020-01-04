note
	description: "[
		Command line interface to class [$source EL_DEBIAN_PACKAGER_I]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-02 13:38:28 GMT (Thursday 2nd January 2020)"
	revision: "7"

class
	EL_DEBIAN_PACKAGER_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [EL_DEBIAN_PACKAGER_IMP]
		redefine
			Option_name, visible_types
		end

	EL_DEBIAN_CONSTANTS

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_optional_argument ("debian", "DEBIAN directory", << control_template_must_exist >>),
				optional_argument ("output", "Debian output directory"),
				valid_optional_argument ("package", "Build package directory", << directory_must_exist >>)
			>>
		end

	control_exists (path: EL_DIR_PATH): BOOLEAN
		do
			Result := (path + Control).exists
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("DEBIAN", Default_package_dir.parent, Default_package_dir)
		end

	control_template_must_exist: like always_valid
		do
			Result := ["A Debian control template file must exist", agent control_exists]
		end

	visible_types: TUPLE [EL_FIND_DIRECTORIES_COMMAND_IMP, EL_FIND_FILES_COMMAND_IMP]
		do
			create Result
		end

feature {NONE} -- Constants

	Default_package_dir: EL_DIR_PATH
		once
			Result := "build/linux-x86-64/package"
		end

	Description: STRING = "Create a Debian package in output directory for this application"

	Option_name: STRING = "debian_packager"

end
