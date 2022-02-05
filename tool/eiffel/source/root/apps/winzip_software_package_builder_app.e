note
	description: "Command line interface to [$source WINZIP_SOFTWARE_PACKAGE] command"
	notes: "[
		**Usage**

			el_eiffel -winzip_exe_builder -config <package-config-path> -pecf <pecf-path>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 14:46:40 GMT (Saturday 5th February 2022)"
	revision: "13"

class
	WINZIP_SOFTWARE_PACKAGE_BUILDER_APP

inherit
	EL_COMMAND_LINE_APPLICATION [WINZIP_SOFTWARE_PACKAGE]
		redefine
			is_valid_platform, new_locale, Option_name, visible_types
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
				required_argument ("config", "Path to build configuration file", << file_must_exist >>),
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

	new_locale: EL_DEFERRED_LOCALE_I
		do
			if Locale_dir.exists then
				create {EL_ENGLISH_DEFAULT_LOCALE_IMP} Result.make_resources
			else
				Result := Precursor
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