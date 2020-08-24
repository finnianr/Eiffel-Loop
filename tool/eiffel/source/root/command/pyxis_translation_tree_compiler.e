note
	description: "[
		Compile tree of Pyxis locale translation files into a directory `locales' binary data files.
		For example:
		
			locales/en
			locales/de
			locales/fr
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-24 12:18:33 GMT (Monday 24th August 2020)"
	revision: "9"

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

	make (a_source_tree_dir, a_output_dir: EL_DIR_PATH)
		do
			make_compiler (a_source_tree_dir)
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

	new_output_modification_time: DATE_TIME
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
		do
			create Result.make (<<
				["item/@id", 									agent do item_id := node.to_string end],
				["item/translation/@lang", 				agent set_translation_list_from_node],
				["item/translation/text()",		 		agent extend_text_normal],
				["item/translation/zero/text()", 		agent extend_text_quantity (0)],
				["item/translation/singular/text()",	agent extend_text_quantity (1)],
				["item/translation/plural/text()", 		agent extend_text_quantity (2)]
			>>)
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
