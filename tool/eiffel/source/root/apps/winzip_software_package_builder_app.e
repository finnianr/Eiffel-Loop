note
	description: "Command line interface to [$source WINZIP_SOFTWARE_PACKAGE_BUILDER] command"
	notes: "[
		**Usage**

			el_eiffel -winzip_exe_builder -config <package-config-path> -pecf <pecf-path>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-06 18:16:12 GMT (Friday 6th August 2021)"
	revision: "8"

class
	WINZIP_SOFTWARE_PACKAGE_BUILDER_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [WINZIP_SOFTWARE_PACKAGE_BUILDER]
		redefine
			is_valid_platform, new_locale, Option_name, visible_types
		end

	PACKAGE_BUILD_CONSTANTS

	EL_FILE_OPEN_ROUTINES

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
				valid_required_argument ("config", "Path to build configuration file", << file_must_exist >>),
				valid_optional_argument ("pecf", "Path to Pyxis configuration file", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", default_pecf)
		end

	default_pecf: EL_FILE_PATH
		-- derive 'pecf' project config file from project.py if it exists
		local
			line, base: ZSTRING; s: EL_ZSTRING_ROUTINES
		do
			if Project_py.exists then
				if attached open_lines (Project_py, Latin_1) as lines then
					across lines as list until attached Result loop
						line := list.item
						if line.starts_with ("ecf") then
							across "%"'" as delimiter until attached base loop
								if	line.occurrences (delimiter.item) = 2 and then (" =").has (line.item (4).to_character_8) then
									base := line.substring_between (s.character_string (delimiter.item), s.character_string (delimiter.item), 1)
									base.insert_character ('p', base.last_index_of ('.', base.count) + 1)
								end
							end
							Result := base
							if not Result.exists then
								create Result
							end
						end
					end
					lines.close
				end
			else
				create Result
			end
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

	Description: STRING = "Build a software package as a self-extracting WinZip exe"

	Locale_dir: EL_DIR_PATH
		once
			Result := "resources/locales"
		end

	Option_name: STRING = "winzip_exe_builder"

end