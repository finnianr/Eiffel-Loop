note
	description: "Command line interface to [$source WINZIP_SOFTWARE_PACKAGE] command"
	notes: "[
		**Usage**

			el_eiffel -winzip_exe_builder -config <package-config-path> -pecf <pecf-path>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "17"

class
	WINZIP_SOFTWARE_PACKAGE_BUILDER_APP

inherit
	EL_COMMAND_LINE_APPLICATION [WINZIP_SOFTWARE_PACKAGE]
		undefine
			make_solitary
		redefine
			is_valid_platform, Option_name, visible_types
		end

	EL_LOCALIZED_APPLICATION
		redefine
			new_locale
		end

create
	make

feature -- Status query

	is_valid_platform: BOOLEAN
		do
			Result := {PLATFORM}.is_windows or True
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				config_argument ("Path to build configuration file"),
				optional_argument ("pecf", "Path to Pyxis configuration file", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		local
			project: SCONS_PROJECT_PY_CONFIG
		do
			create project.make
			Result := agent {like command}.make ("", project.pecf_path)
		end

	new_locale: EL_DEFAULT_LOCALE
		do
			if Locale_dir.exists then
				create {EL_ENGLISH_DEFAULT_LOCALE} Result.make_resources
			end
		end

	visible_types: TUPLE [WINZIP_CREATE_SELF_EXTRACT_COMMAND, EL_OS_COMMAND]
		do
			create Result
		end

feature {NONE} -- Constants

	Locale_dir: DIR_PATH
		once
			Result := "resources/locales"
		end

	Option_name: STRING = "winzip_exe_builder"

end