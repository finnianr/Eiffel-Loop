note
	description: "Winzip self-extracting package build configuration"
	notes: "[
		**Example**

			pyxis-doc:
				version = 1.0; encoding = "UTF-8"

			winzip_software_package:
				output_dir = "$EIFFEL/myching-server/www/download"
				build_exe = true; build_installers = true

				architecture_list:
					item:
						32
					item:
						64

				language_list:
					item:
						"en"
					item:
						"de"

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-30 8:37:53 GMT (Friday 30th April 2021)"
	revision: "4"

class
	WINZIP_SOFTWARE_PACKAGE

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			make_from_file as make
		redefine
			make, make_default
		end

	EL_MODULE_DIRECTORY

	EL_MODULE_DEFERRED_LOCALE

create
	make

feature {NONE} -- Initialization

	make (a_file_path: EL_FILE_PATH)
			--
		do
			Precursor (a_file_path)
			if not output_dir.is_absolute then
				output_dir := Directory.current_working.joined_dir_path (output_dir)
			end
		end

	make_default
		do
			Precursor
			create architecture_list.make (2)
			create language_list.make (2)
		end

feature -- Conversion

	architectures: ZSTRING
		do
			Result := architecture_list.comma_separated_string
		end

	languages: STRING
		do
			Result := language_list.comma_separated_string
		end

feature -- Access

	architecture_list: EL_ARRAYED_LIST [INTEGER]

	output_dir: EL_DIR_PATH

	language_list: EL_STRING_8_LIST

feature -- Status query

	build_exe: BOOLEAN

	build_installers: BOOLEAN

	valid_languages: BOOLEAN
		do
			Result := across language_list as list all Locale.all_languages.has (list.item) end
		end

	valid_architectures: BOOLEAN
		do
			Result := across architecture_list as n all (32 |..| 64).has (n.item) end
		end

end