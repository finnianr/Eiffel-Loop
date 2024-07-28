note
	description: "[
		Compile a manifest list of Pyxis locale translation files into a directory `locales' binary data files.
		For example:
		
			locales/en
			locales/de
			locales/fr
	]"
	notes: "[
		The file manifest list is compiled in two ways:
		
		1. If the `a_source_tree_dir' argument exists then all `*.pyx' files under that directory are
		added to manifest list.
		
		2. If the `a_manifest_path' argument exists then the lines are iterated ignoring empty lines and lines
		starting with the # symbol.
		
		Lines expanded as paths with extension ''pyx'' are added to manifest, but if the path ends with a '/'
		character, the path is treated like a `a_source_tree_dir' argument.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-28 8:41:03 GMT (Sunday 28th July 2024)"
	revision: "25"

class
	PYXIS_TRANSLATION_TREE_COMPILER

inherit
	EL_APPLICATION_COMMAND

	EL_PYXIS_TREE_COMPILER
		rename
			make as make_compiler
		redefine
			make_default, source_changed
		end

	EL_MODULE_FILE_SYSTEM

	EL_ZSTRING_CONSTANTS EL_LOCALE_CONSTANTS

	EL_SHARED_KEY_LANGUAGE

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_manifest_path: FILE_PATH; a_source_tree_dir, a_output_dir: DIR_PATH)
		do
			make_compiler (a_manifest_path, a_source_tree_dir)
			File_system.make_directory (a_output_dir)
			create locales.make (a_output_dir)
		end

	make_default
		do
			create locales.make_default
			create translations_table.make_equal (7, agent new_translation_items_list)
			Precursor
		end

feature -- Access

	Description: STRING = "Compile tree of Pyxis translation files into multiple locale files"

	translations_table: EL_AGENT_CACHE_TABLE [EL_TRANSLATION_ITEMS_LIST, STRING]

feature {NONE} -- Implementation

	check_missing_translations (pyxis_table: EL_PYXIS_ML_TRANSLATION_TABLE)
		do
			if attached pyxis_table.missing_translation_list as list and then list.count > 0 then
				from list.start until list.after loop
					lio.put_new_line
					lio.put_string ("** ")
					lio.put_string_field ("Missing", list.item)
					list.forth
				end
			end
		end

	compile_tree
		local
			language: STRING; build_path: FILE_PATH; all_items_list: EL_TRANSLATION_ITEMS_LIST
			pyxis_table: EL_PYXIS_ML_TRANSLATION_TABLE
		do
			lio.put_line ("Compiling locales..")

			if attached new_build_path_list as build_path_list
				and attached new_relative_source_path_list as relative_path_list
			then
				across new_source_path_list as path loop
					build_path := build_path_list [path.cursor_index]
					File_system.make_directory (build_path.parent)

					if is_source_updated (path.item, build_path) then
						lio.put_path_field ("Updating", relative_path_list [path.cursor_index])
						create pyxis_table.make_from_file (path.item)
						check_missing_translations (pyxis_table)

						create all_items_list.make_from_file (build_path)
						all_items_list.wipe_out
						pyxis_table.append_to_items_list (all_items_list)
						all_items_list.store
					else
						lio.put_path_field ("Reading", build_path)
						create all_items_list.make_from_file (build_path)
					end
					lio.put_new_line
					across all_items_list as list loop
						if attached list.item as translation
							and then translation.has_language
							and then attached translations_table.item (translation.language) as items_list
						then
							translation.remove_language
							items_list.extend (translation)
						end
					end
				end
			end
			across translations_table as table loop
				language := table.item.file_path.base_name
				lio.put_integer_field ("Storing " + language, table.item.count)
				table.item.store
				lio.put_new_line
			end
			translations_table.search (Key_language)
			if attached found_list as list and then attached list.to_table (Key_language) as en_table then
				same_list_and_table_count := list.count - en_table.duplicate_count = en_table.count
				if en_table.has_duplicates then
					en_table.print_duplicates
				end
			end
		ensure then
			same_count: same_list_and_table_count
		end

	found_list: EL_TRANSLATION_ITEMS_LIST
		do
			Result := translations_table.found_item
		end

	is_source_updated (source_path, compiled_path: FILE_PATH): BOOLEAN
		do
			Result := compiled_path.exists implies source_path.modification_time > compiled_path.modification_time
		end

	new_build_path_list: EL_FILE_PATH_LIST
		do
			if attached new_relative_source_path_list as list then
				create Result.make (list.count)
				from list.start until list.after loop
					Result.extend (Localization_build_dir + list.path)
					Result.last_path.replace_extension (Dat)
					list.forth
				end
			end
		end

	new_translation_items_list (a_language: STRING): EL_TRANSLATION_ITEMS_LIST
		do
			if attached locales.new_locale_path (a_language) as file_path then
				lio.put_path_field ("Creating %S", file_path)
				lio.put_new_line
				if file_path.exists then
					File_system.remove_file (file_path)
				end
				create Result.make_from_file (file_path)
			end
		end

	output_modification_time: INTEGER
		do
			across locales as locale loop
				if locale.item.modification_time > Result then
					Result := locale.item.modification_time
				end
			end
		end

	source_changed: BOOLEAN
		do
			if attached new_build_path_list as build_path_list then
				Result := across new_source_path_list as list some
					is_source_updated (list.item, build_path_list [list.cursor_index])
				end
			end
		end

feature {NONE} -- Internal attributes

	locales: EL_LOCALE_TABLE

	same_list_and_table_count: BOOLEAN

feature {EL_LOCALIZATION_TEST} -- Constants

	Dat: ZSTRING
		once
			Result := "dat"
		end

	Localization_build_dir: DIR_PATH
		once
			Result := "build/localization"
		end

end