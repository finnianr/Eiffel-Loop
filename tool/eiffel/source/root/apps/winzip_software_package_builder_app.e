note
	description: "Command line interface to [$source CREATE_SELF_EXTRACTING_EXE] command"
	notes: "[
		**Usage**

			el_eiffel -winzip_exe_builder -config <pecf-path> -arch <cpu-bits-list> -targets <installer | exe> -output <dir-path>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-10-22 12:33:17 GMT (Thursday 22nd October 2020)"
	revision: "3"

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
				valid_required_argument ("config", "Path to Pyxis configuration file", << file_must_exist, root_class_must_exist >>),
				valid_optional_argument ("arch", "List of architectures (32, 64)", << must_be_32_or_64 >>),
				valid_optional_argument ("targets", "List of targets: (installer, exe)", << must_be_installer_or_exe >>),
				optional_argument ("output", "Output directory for installer package")
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", "64", "exe, installer", "build")
		end

	new_locale: EL_DEFERRED_LOCALE_I
		do
			if Locale_dir.exists then
				create {EL_ENGLISH_DEFAULT_LOCALE_IMP} Result.make_resources
			else
				Result := Precursor
			end
		end

	root_class_must_exist: like always_valid
		do
			Result := ["Root class %"source/application_root.e%" must exist", agent root_class_exists]
		end

	must_be_32_or_64: like always_valid
		do
			Result := ["Listed architecture must be 32 or 64", agent valid_architecture_list]
		end

	must_be_installer_or_exe: like always_valid
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