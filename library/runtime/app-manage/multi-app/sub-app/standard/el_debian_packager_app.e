note
	description: "[
		Command line interface to class [$source EL_DEBIAN_PACKAGER]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-26 12:52:29 GMT (Thursday 26th September 2019)"
	revision: "2"

class
	EL_DEBIAN_PACKAGER_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [EL_DEBIAN_PACKAGER]
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
				valid_optional_argument ("template", "Debian template directory", << control_template_must_exist >>),
				valid_optional_argument ("output", "Debian output directory", << directory_must_exist >>),
				valid_optional_argument ("package", "Build package directory", << directory_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("DEBIAN", Directory.current_working, Default_package_dir)
		end

	control_template_must_exist: like always_valid
		do
			Result := [
				"A Debian control template file must exist", agent (path: EL_DIR_PATH): BOOLEAN
				do
					Result := (path + Control).exists
				end
			]
		end

	visible_types: ARRAY [TYPE [EL_MODULE_LIO]]
		do
			Result := << {EL_FIND_DIRECTORIES_COMMAND_IMP}, {EL_FIND_FILES_COMMAND_IMP} >>
		end

feature {NONE} -- Constants

	Default_package_dir: EL_DIR_PATH
		once
			Result := "build/linux-x86-64/package"
		end

	Description: STRING = "Create a Debian package in output directory for this application"

	Option_name: STRING = "debian_packager"

end
