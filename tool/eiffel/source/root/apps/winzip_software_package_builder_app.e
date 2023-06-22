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
	date: "2023-06-22 12:34:32 GMT (Thursday 22nd June 2023)"
	revision: "19"

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
				optional_argument ("dry_run", "Display commands without executing", No_checks)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH}, False)
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