note
	description: "[
		Command line interface to create object conforming to interface ${EL_DEBIAN_PACKAGER_I}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-26 7:48:18 GMT (Monday 26th June 2023)"
	revision: "15"

class
	EL_DEBIAN_PACKAGER_APP

inherit
	EL_COMMAND_LINE_APPLICATION [EL_DEBIAN_PACKAGER_IMP]
		undefine
			is_valid_platform
		redefine
			Option_name, visible_types
		end

	EL_UNIX_APPLICATION

	EL_DEBIAN_CONSTANTS

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				optional_argument ("debian", "DEBIAN directory", << control_template_must_exist >>),
				optional_argument ("output", "Debian output directory", No_checks),
				optional_argument ("package", "Build package directory", << directory_must_exist >>)
			>>
		end

	control_exists (path: DIR_PATH): BOOLEAN
		do
			Result := (path + Name.control).exists
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("DEBIAN", Default_package_dir.parent, Default_package_dir)
		end

	control_template_must_exist: like No_checks.item
		do
			Result := ["A Debian control template file must exist", agent control_exists]
		end

	visible_types: TUPLE [EL_FIND_DIRECTORIES_COMMAND_IMP, EL_FIND_FILES_COMMAND_IMP]
		do
			create Result
		end

feature {NONE} -- Constants

	Default_package_dir: DIR_PATH
		once
			Result := "build/linux-x86-64/package"
		end

	Option_name: STRING = "debian_packager"

end