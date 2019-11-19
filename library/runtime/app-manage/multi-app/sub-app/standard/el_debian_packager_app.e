note
	description: "[
		Command line interface to class [$source EL_DEBIAN_PACKAGER]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-19 15:19:35 GMT (Tuesday 19th November 2019)"
	revision: "3"

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
			Result := agent {like command}.make ("DEBIAN", Default_output_dir, Default_package_dir)
		end

	control_template_must_exist: like always_valid
		do
			Result := ["A Debian control template file must exist", agent control_exists]
		end

	visible_types: ARRAY [TYPE [EL_MODULE_LIO]]
		do
			Result := << {EL_FIND_DIRECTORIES_COMMAND_IMP}, {EL_FIND_FILES_COMMAND_IMP} >>
		end

feature {NONE} -- Constants

	Default_output_dir: EL_DIR_PATH
		once
			Result := "build"
		end

	Default_package_dir: EL_DIR_PATH
		once
			Result := "build/linux-x86-64/package"
		end

	Description: STRING = "Create a Debian package in output directory for this application"

	Option_name: STRING = "debian_packager"

end
