note
	description: "Winzip self-extracting package build configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-27 10:48:22 GMT (Tuesday 27th April 2021)"
	revision: "1"

class
	WINZIP_SOFTWARE_PACKAGE

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			make_from_file as make
		redefine
			make
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

feature -- Access

	architectures: STRING

	architecture_list: EL_ARRAYED_LIST [INTEGER]
		do
			create Result.make (2)
			across architectures.split (',') as bit_count loop
				bit_count.item.left_adjust
				Result.extend (bit_count.item.to_integer)
			end
		end

	output_dir: EL_DIR_PATH

	languages: STRING

	language_list: EL_STRING_8_LIST
		do
			Result := languages
		end

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