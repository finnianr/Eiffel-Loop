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
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:52:09 GMT (Monday 3rd January 2022)"
	revision: "14"

class
	PYXIS_TRANSLATION_TREE_COMPILER

inherit
	EL_PYXIS_TREE_COMPILER
		rename
			make as make_compiler
		redefine
			make_default
		end

	EL_BUILDABLE_FROM_PYXIS
		redefine
			make_default
		end

	EL_ZSTRING_CONSTANTS

	EL_LOCALE_CONSTANTS

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_manifest_path: FILE_PATH; a_source_tree_dir, a_output_dir: DIR_PATH)
		do
			make_compiler (a_manifest_path, a_source_tree_dir)
			File_system.make_directory (a_output_dir)
			create locales.make (a_output_dir)
			create translations_table.make (<< [English_id, new_translations_list (English_id)] >>)
			translations_table.search (English_id)
		end

	make_default
		do
			create locales.make_default
			create translations_table
			item_id := Empty_string
			Precursor {EL_PYXIS_TREE_COMPILER}
			Precursor {EL_BUILDABLE_FROM_PYXIS}
		end

feature -- Access

	translations_table: EL_HASH_TABLE [EL_TRANSLATION_ITEMS_LIST, STRING]

feature {NONE} -- Implementation

	compile_tree
		do
			lio.put_line ("Compiling locales..")
			build_from_lines (merged_lines)
			across translations_table as translations loop
				translations.item.store
			end
		end

	new_output_modification_time: EL_DATE_TIME
		do
			Result := Zero_time
			across locales as locale loop
				if locale.item.modification_date_time > Result then
					Result := locale.item.modification_date_time
				end
			end
		end

	new_translations_list (lang_id: STRING): like translations_list
		do
			create Result.make_from_file (locales.new_locale_path (lang_id))
			lio.put_path_field ("Creating", Result.file_path)
			lio.put_new_line
		end

	translations_list: EL_TRANSLATION_ITEMS_LIST
		do
			Result := translations_table.found_item
		end

feature {NONE} -- Internal attributes

	item_id: ZSTRING

	locales: EL_LOCALE_TABLE

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
		local
			text_xpath: STRING
		do
			create Result.make (<<
				["item/@id", 									agent do item_id := node.to_string end],
				["item/translation/@lang", 				agent set_translation_list_from_node],
				["item/translation/text()",		 		agent extend_text_normal]
			>>)
			across Quantifier_names as name loop
				text_xpath := "item/translation/" + name.item + "/text()"
				Result [text_xpath] := agent extend_text_quantity (name.cursor_index - 1)
			end
		end

	extend_text_normal
		do
			translations_list.extend (create {EL_TRANSLATION_ITEM}.make (item_id, node.to_string))
		end

	extend_text_quantity (index: INTEGER)
		local
			translation: EL_TRANSLATION_ITEM
		do
			create translation.make (item_id + Number_suffix [index], node.to_string)
			translations_list.extend (translation)
		end

	set_translation_list_from_node
		local
			lang_id: STRING
		do
			lang_id := node.to_string_8
			translations_table.search (lang_id)
			if not translations_table.found then
				translations_table.extend (new_translations_list (lang_id), lang_id)
				translations_table.search (lang_id)
			end
		ensure
			found_translation_items: translations_table.found
		end

feature {NONE} -- Constants

	English_id: STRING
		once
			Result := "en"
		end

	Root_node_name: STRING = "translations"

end
