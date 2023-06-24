note
	description: "[
		A command for verifying localization translation identifiers against various kinds of source texts.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-24 8:39:45 GMT (Saturday 24th June 2023)"
	revision: "30"

class
	CHECK_LOCALE_STRINGS_COMMAND

obsolete
	"Use EL_LOCALIZATION_TEST with EL_REFLECTIVE_LOCALE_TEXTS"

inherit
	EL_APPLICATION_COMMAND

	EL_FILE_TREE_COMMAND
		rename
			tree_dir as source_dir,
			make as make_tree_command
		redefine
			new_file_list, execute, make_default
		end

	EL_BUILDABLE_FROM_PYXIS
		redefine
			make_default, building_action_table
		end

	EL_EIFFEL_SOURCE_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_MODULE_LOCALE

	EL_MODULE_LIO

	EL_LOCALE_CONSTANTS

create
	make

feature {EL_APPLICATION} -- Initialization

	make (config_path: FILE_PATH; language: STRING)
		do
			make_from_file (config_path)
			translations := Locale.new_translation_table (language)
			translations.print_duplicates
			create referenced_keys.make (translations.count)
		end

	make_default
		do
			make_machine
			create evolicity_parser_list.make (0)
			create included_files.make_empty
			create last_localized_file_name_extension.make_empty
			create additional_keys_table.make_equal (7)
			create routine_lines.make_empty
			create parser.make
			create missing_keys.make_empty
			create source_path
			create localized_file_name_list.make_empty
			create localized_www_body_path_list.make_empty

			Precursor {EL_BUILDABLE_FROM_PYXIS}
			Precursor {EL_FILE_TREE_COMMAND}
		end

feature -- Constants

	Description: STRING = "Check that every localized string can be found in resources/locales"

feature -- Status query

	routine_has_english_prefix: BOOLEAN

feature -- Basic operations

	execute
		local
			l_unreferenced_items: like unreferenced_items
		do
			Precursor
			lio.put_new_line

			localized_file_name_list.do_all (agent do_with_localizeable_file (?, 2))
			localized_www_body_path_list.do_all (agent do_with_localizeable_file (?, 3))

			across additional_keys_table as list loop
				source_path := list.key
				check_keys (list.item)
				save_missing_keys (list.key)
			end

			across evolicity_parser_list as evolicity_parser loop
				evolicity_parser.item.find_all (Void)
				source_path := evolicity_parser.item.source_file_path
				check_keys (evolicity_parser.item.locale_keys)
			end

			l_unreferenced_items := unreferenced_items
			if not l_unreferenced_items.is_empty then
				lio.put_new_line
				lio.put_line ("UNREFERENCED ITEMS")
				across l_unreferenced_items as id loop
					lio.put_string_field ("id", id.item)
					lio.put_new_line
				end
			end
		end

feature {NONE} -- State handlers

	find_class_declaration (line: ZSTRING)
		do
			if code_line_is_class_declaration then
				state := agent find_routine
			end
		end

	find_routine (line: ZSTRING)
		local
			pos_quote: INTEGER
		do
			if code_line_starts_with (0, Keyword.end_) then
				state := final
			elseif code_line_starts_with_one_of (2, Routine_start_keywords) then
				routine_lines.wipe_out
				state := agent find_routine_end
			elseif tab_count = 1
				and then across English_prefixes as l_prefix some code_line.starts_with (l_prefix.item) end
			then
				if code_line [code_line.count] = '"' then
					-- eg: English_name: STRING = "&Backup"
					pos_quote := code_line.last_index_of ('"', code_line.count - 1)
					if pos_quote > 0 then
						check_keys (<< code_line.substring (pos_quote + 1, code_line.count - 1) >>)
					end
				else
					routine_has_english_prefix := True
				end
			end
		end

	find_routine_end (line: ZSTRING)
		local
			l_parser: like parser
		do
			if code_line_starts_with (2, Keyword.end_) then
				if routine_has_english_prefix then
					create {EL_ROUTINE_RESULT_LOCALE_STRING_PARSER} l_parser.make
				else
					l_parser := parser
				end
				l_parser.set_source_text (routine_lines.joined_lines)
				l_parser.find_all (Void)
				check_keys (l_parser.locale_keys)
				state := agent find_routine
				routine_has_english_prefix := False
			else
				routine_lines.extend (line)
			end
		end

feature {NONE} -- Implementation

	check_file_path_exists (file_path: FILE_PATH)
		do
			if not file_path.exists then
				lio.put_line ("FILE DOES NOT EXIST")
				lio.put_path_field ("Cannot find %S", file_path)
				lio.put_new_line
			end
		end

	check_keys (locale_keys: EL_ZSTRING_LIST)
		do
			across locale_keys as key loop
				if translations.has (key.item) then
					referenced_keys.put (key.item)
				else
					if missing_keys.is_empty then
						lio.put_path_field ("Source %S", source_path)
						lio.put_new_line
					end
					missing_keys.extend (key.item)
					lio.put_string_field ("id", key.item)
					lio.put_string (" MISSING")
					lio.put_new_line
				end
			end
		end

	do_with_file (a_source_path: FILE_PATH)
		do
			source_path := a_source_path
			do_once_with_file_lines (agent find_class_declaration, open_lines (source_path, Latin_1))
			save_missing_keys (source_path.base_name)
		end

	do_with_localizeable_file (file_path: FILE_PATH; index_of_lang_id_from_end: INTEGER)
		local
			name: ZSTRING; steps: EL_PATH_STEPS
		do
			name := file_path.without_extension.base

			source_path := file_path
			check_keys (create {EL_ZSTRING_LIST}.make_with_lines (name))

			translations.search (name)
			if translations.found then
				steps := file_path.without_extension
				steps [steps.count - index_of_lang_id_from_end + 1] := translations.language
				steps.set_base (translations.found_item + "." + file_path.extension)
				check_file_path_exists (steps)
			end
		end

	put_node_directory_error (node_name: STRING; dir_path: DIR_PATH)
		do
			lio.put_string_field ("DIRECTORY NODE", node_name)
			lio.put_new_line
			lio.put_path_field ("Cannot find %S", dir_path)
			lio.put_new_line
		end

	save_missing_keys (name: ZSTRING)
		local
			missing: EL_MISSING_TRANSLATIONS
		do
			if not missing_keys.is_empty then
				create missing.make_from_file (Workarea_pyx_template #$ [name])
				missing.class_name.append (name.as_upper)
				missing.translation_keys.merge_right (missing_keys)
				missing.serialize
			end
		end

	unreferenced_items: EL_ZSTRING_LIST
		do
			create Result.make_empty
			across translations.current_keys as key loop
				if not referenced_keys.has (key.item) then
					Result.extend (key.item)
				end
			end
		end

feature {NONE} -- Factory

	new_empty_list: EL_ZSTRING_LIST
		do
			create Result.make_empty
		end

	new_file_list: EL_FILE_PATH_LIST
		do
			Result := Precursor
			Result.append (included_files)
		end

feature {NONE} -- Internal attributes

	additional_keys_table: EL_ZSTRING_HASH_TABLE [EL_ZSTRING_LIST]

	evolicity_parser_list: ARRAYED_LIST [EVOLICITY_TEMPLATE_PARSER]

	included_files: EL_FILE_PATH_LIST

	last_localized_file_name_extension: ZSTRING

	localized_file_name_list: EL_FILE_PATH_LIST

	localized_www_body_path_list: EL_FILE_PATH_LIST

	missing_keys: EL_ZSTRING_LIST

	parser: EL_ROUTINE_LOCALE_STRING_PARSER

	referenced_keys: EL_HASH_SET [ZSTRING]

	routine_lines: EL_ZSTRING_LIST

	source_path: FILE_PATH

	translations: EL_TRANSLATION_TABLE

feature {NONE} -- Build from Pyxis

	Root_node_name: STRING = "configuration"

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			-- Nodes relative to root element: bix
		do
			create Result.make (<<
				["evolicity-template/ignore-key/text()",	agent do evolicity_parser_list.last.ignored_keys.put (node) end],
				["localized-file-names/@extension",			agent do node.set (last_localized_file_name_extension) end],
				["source-dir/text()",							agent do source_dir := node.to_expanded_dir_path end],
				["include/@name",									agent do additional_keys_table.put (new_empty_list, node) end],

				["include-class/text()",						agent extend_file_list (included_files)],
				["localized-file-names/text()",				agent extend_localized_file_name_list],
				["localized-www-content/text()",				agent extend_localized_www_content],
				["evolicity-template/@path",					agent extend_evolicity_parser_list],
				["include/keys/text()",							agent extend_additional_keys_table_item]
			>>)
		end

	extend_additional_keys_table_item
		do
			if additional_keys_table.inserted then
				additional_keys_table.found_item.extend (node)
			end
		end

	extend_evolicity_parser_list
		do
			evolicity_parser_list.extend (create {EVOLICITY_TEMPLATE_PARSER}.make (node.to_expanded_file_path))
		end

	extend_file_list (list: EL_FILE_PATH_LIST)
		local
			file_path: FILE_PATH
		do
			file_path := node.to_expanded_file_path
			if file_path.exists then
				list.extend (file_path)
			else
				lio.put_path_field ("Missing", file_path)
				lio.put_new_line
			end
		end

	extend_localized_file_name_list
		local
			dir_path: DIR_PATH; l_directory: EL_DIRECTORY
		do
			dir_path := node.to_expanded_dir_path
			create l_directory.make (dir_path)
			if dir_path.exists then
				l_directory.files_with_extension (last_localized_file_name_extension).do_all (
					agent localized_file_name_list.extend
				)
			else
				put_node_directory_error ("localized-file-names", dir_path)
			end
		end

	extend_localized_www_content
		local
			dir_path: DIR_PATH; web_menu_list: EL_ZSTRING_LIST; menu_name: ZSTRING
		do
			dir_path := node.to_expanded_dir_path
			if dir_path.exists then
				across File_system.files_with_extension (dir_path, Body_extension, True) as file_path loop
					menu_name := file_path.item.parent.base
					additional_keys_table.search (Web_menu)
					if additional_keys_table.found then
						web_menu_list := additional_keys_table.found_item
					else
						create web_menu_list.make_empty
						additional_keys_table [Web_menu] := web_menu_list
					end
					if not web_menu_list.has (menu_name) then
						web_menu_list.extend (menu_name)
					end
					localized_www_body_path_list.extend (file_path.item)
				end
			else
				put_node_directory_error ("localized-www-content", dir_path)
			end
		end

feature {NONE} -- Constants

	Body_extension: ZSTRING
		once
			Result := "body"
		end

	English_prefixes: ARRAY [EL_READABLE_ZSTRING]
		local
			prefix_1, prefix_2: ZSTRING
		once
			prefix_1 := "English_"; prefix_2 := "Eng_"
			Result := << prefix_1, prefix_2 >>
		end

	File_extensions: STRING = "e"

	Web_menu: ZSTRING
		once
			Result := "Web menu"
		end

	Workarea_pyx_template: ZSTRING
		once
			Result := "workarea/localization/%S.pyx"
		end

end