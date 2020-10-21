note
	description: "Command line interface to [$source CREATE_SELF_EXTRACTING_EXE] command"
	notes: "[
		**Usage**

			el_toolkit -create_self_extracting_exe -config <file-path>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-10-21 9:23:32 GMT (Wednesday 21st October 2020)"
	revision: "2"

class
	WINZIP_SOFTWARE_PACKAGE_BUILDER_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [WINZIP_SOFTWARE_PACKAGE_BUILDER]
		redefine
			is_valid_platform, new_locale, Option_name
		end

	WINZIP_SOFTWARE_COMMON

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
				valid_required_argument ("config", "Path to Pyxis configuration file", << file_must_exist >>),
				valid_optional_argument ("arch", "List of architectures (32, 64)", << valid_architectures >>),
				valid_optional_argument ("targets", "List of targets: (installer, exe)", << valid_targets >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", "64", "exe, installer")
		end

	new_locale: EL_DEFERRED_LOCALE_I
		do
			if Locale_dir.exists then
				create {EL_ENGLISH_DEFAULT_LOCALE_IMP} Result.make_resources
			else
				Result := Precursor
			end
		end

	valid_architectures: like always_valid
		do
			Result := ["Listed architecture must be 32 or 64", agent valid_architecture_list]
		end

	valid_targets: like always_valid
		do
			Result := ["Listed target must be 'installer' or 'exe'", agent valid_target_list]
		end

feature {NONE} -- Constants

	Description: STRING = "Build a software package as a self-extracting WinZip exe"

	Locale_dir: EL_DIR_PATH
		once
			Result := "resources/locales"
		end

	Option_name: STRING = "winzip_exe_builder"

end