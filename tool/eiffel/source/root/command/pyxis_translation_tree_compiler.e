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
	date: "2024-07-18 8:20:49 GMT (Thursday 18th July 2024)"
	revision: "23"

class
	PYXIS_TRANSLATION_TREE_COMPILER

inherit
	EL_APPLICATION_COMMAND

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

	EL_MODULE_FILE_SYSTEM

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
		end

	make_default
		do
			create locales.make_default
			create translations_table.make_size (7)
			item_id := Empty_string
			Precursor {EL_PYXIS_TREE_COMPILER}
			Precursor {EL_BUILDABLE_FROM_PYXIS}
		end

feature -- Access

	Description: STRING = "Compile tree of Pyxis translation files into multiple locale files"

	translations_table: EL_HASH_TABLE [EL_TRANSLATION_ITEMS_LIST, STRING]

feature {NONE} -- Implementation

	compile_tree
		local
			language: STRING
		do
			lio.put_line ("Compiling locales..")

			build_from_lines (new_merged_lines)
			across translations_table as table loop
				language := table.item.file_path.base_name
				lio.put_integer_field ("Storing " + language, table.item.count)
				table.item.store
				lio.put_new_line
			end
			translations_table.search (English_id)
			if attached found_list as list and then attached list.to_table (English_id) as en_table then
				same_list_and_table_count := list.count - en_table.duplicate_count = en_table.count
				if en_table.has_duplicates then
					en_table.print_duplicates
				end
			end
		ensure then
			same_count: same_list_and_table_count
		end

	output_modification_time: INTEGER
		do
			across locales as locale loop
				if locale.item.modification_time > Result then
					Result := locale.item.modification_time
				end
			end
		end

	found_list: EL_TRANSLATION_ITEMS_LIST
		do
			Result := translations_table.found_item
		end

feature {NONE} -- Internal attributes

	item_id: ZSTRING

	locales: EL_LOCALE_TABLE

	same_list_and_table_count: BOOLEAN

feature {NONE} -- Build from XML

	set_item_id
		do
			item_id := node.to_string
			-- Normalize identifier for reflective localization attribute
			if item_id.has_enclosing ('{', '}') then
				if item_id.has ('-') then
					item_id.replace_character ('-', '_')
					item_id.to_lower
				end
			else
			-- `item_id' is the translation text for English
				set_found_list (False); extend_text_normal (False)
			end
		end

	building_action_table: EL_PROCEDURE_TABLE [STRING]
		local
			text_xpath: STRING
		do
			create Result.make (<<
				["item/@id", 						agent set_item_id],
				["item/translation/@lang", 	agent set_found_list (True)],
				["item/translation/text()",	agent extend_text_normal (True)]
			>>)
			across Quantifier_names as name loop
				text_xpath := "item/translation/" + name.item + "/text()"
				Result [text_xpath] := agent extend_text_quantity (name.cursor_index - 1)
			end
		end

	extend_text_normal (from_node: BOOLEAN)
		local
			text: ZSTRING
		do
			if from_node then
				text := node.to_string
			else
				text := item_id
			end
			if attached found_list as list then
				list.extend (create {EL_TRANSLATION_ITEM}.make (item_id, text))
			end
		end

	extend_text_quantity (index: INTEGER)
		local
			translation: EL_TRANSLATION_ITEM
		do
			create translation.make (item_id + Number_suffix [index], node.to_string)
			if attached found_list as list then
				list.extend (translation)
			end
		end

	set_found_list (from_node: BOOLEAN)
		local
			lang_id: STRING; new_list: like found_list
		do
			if from_node then
				lang_id := node.to_string_8
			else
				lang_id := English_id
			end
			if not translations_table.has_key (lang_id)
				and then attached locales.new_locale_path (lang_id) as file_path
			then
				lio.put_path_field ("Creating %S", file_path)
				lio.put_new_line
				if file_path.exists then
					File_system.remove_file (file_path)
				end
				create new_list.make_from_file (file_path)
				translations_table.put (new_list, lang_id)
			end
		ensure
			has_found_list: attached found_list
		end

feature {NONE} -- Constants

	English_id: STRING
		once
			Result := "en"
		end

	Root_node_name: STRING = "translations"

end