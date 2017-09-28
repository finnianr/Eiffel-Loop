note
	description: "[
		A command for verifying localization translation identifiers against various kinds of source texts.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-08-29 14:15:42 GMT (Tuesday 29th August 2017)"
	revision: "1"

class
	CHECK_LOCALE_STRINGS_COMMAND

inherit
	EL_FILE_TREE_COMMAND
		rename
			make as make_command,
			tree_dir as source_dir
		redefine
			new_file_list, execute
		end

	EL_BUILDABLE_FROM_PYXIS
		redefine
			make_default, building_action_table
		end

	EL_EIFFEL_SOURCE_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_SHARED_LOCALE_TABLE
		redefine
			new_locale_table
		end

create
	default_create, make

feature {EL_SUB_APPLICATION} -- Initialization

	make (config_path: EL_FILE_PATH; language: STRING)
		do
			make_from_file (config_path)
			translations := new_translation_table (language)
			translations.print_duplicates
			create referenced_keys.make_equal (translations.count)
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
			is_print_progress_disabled := True

			Precursor
		end

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
				evolicity_parser.item.find_all
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
			if code_line_starts_with (0, Keyword_end) then
				state := final
			elseif code_line_starts_with_one_of (2, Routine_start_keywords) then
				routine_lines.wipe_out
				state := agent find_routine_end
			elseif tab_count = 1 and English_prefixes.there_exists (agent code_line.starts_with) then
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
			if code_line_starts_with (2, Keyword_end) then
				if routine_has_english_prefix then
					create {EL_ROUTINE_RESULT_LOCALE_STRING_PARSER} l_parser.make
				else
					l_parser := parser
				end
				l_parser.set_source_text (routine_lines.joined_lines)
				l_parser.find_all
				check_keys (l_parser.locale_keys)
				state := agent find_routine
				routine_has_english_prefix := False
			else
				routine_lines.extend (line)
			end
		end

feature {NONE} -- Implementation

	check_file_path_exists (file_path: EL_FILE_PATH)
		do
			if not file_path.exists then
				lio.put_line ("FILE DOES NOT EXIST")
				lio.put_path_field ("Cannot find", file_path)
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
						lio.put_path_field ("Source", source_path)
						lio.put_new_line
					end
					missing_keys.extend (key.item)
					lio.put_string_field ("id", key.item)
					lio.put_string (" MISSING")
					lio.put_new_line
				end
			end
		end

	do_with_file (a_source_path: EL_FILE_PATH)
		do
			source_path := a_source_path
			do_once_with_file_lines (agent find_class_declaration, create {EL_FILE_LINE_SOURCE}.make_latin (1, source_path))
			save_missing_keys (source_path.base_sans_extension)
		end

	do_with_localizeable_file (file_path: EL_FILE_PATH; index_of_lang_id_from_end: INTEGER)
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
				steps [steps.count] := translations.found_item + "." + file_path.extension
				check_file_path_exists (steps)
			end
		end

	put_node_directory_error (node_name: STRING; dir_path: EL_DIR_PATH)
		do
			lio.put_string_field ("DIRECTORY NODE", node_name)
			lio.put_new_line
			lio.put_path_field ("Cannot find", dir_path)
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

	new_file_list: EL_SORTABLE_ARRAYED_LIST [EL_FILE_PATH]
		do
			Result := Precursor
			Result.append (included_files)
		end

	new_locale_table: EL_LOCALE_TABLE
		do
			create Result.make (locale_resources_dir)
		end

feature {NONE} -- Internal attributes

	additional_keys_table: EL_ZSTRING_HASH_TABLE [EL_ZSTRING_LIST]

	evolicity_parser_list: ARRAYED_LIST [EVOLICITY_TEMPLATE_PARSER]

	included_files: EL_FILE_PATH_LIST

	last_localized_file_name_extension: ZSTRING

	locale_resources_dir: EL_DIR_PATH

	localized_file_name_list: EL_FILE_PATH_LIST

	localized_www_body_path_list: EL_FILE_PATH_LIST

	missing_keys: EL_ZSTRING_LIST

	parser: EL_ROUTINE_LOCALE_STRING_PARSER

	referenced_keys: EL_HASH_SET [ZSTRING]

	routine_lines: EL_ZSTRING_LIST

	source_path: EL_FILE_PATH

	translations: EL_TRANSLATION_TABLE

feature {NONE} -- Build from Pyxis

	Root_node_name: STRING = "configuration"

	building_action_table: EL_PROCEDURE_TABLE
			-- Nodes relative to root element: bix
		do
			create Result.make (<<
				["locale-resource-dir/text()",				agent do locale_resources_dir := node.to_expanded_dir_path end],
				["localized-file-names/@extension",			agent do last_localized_file_name_extension := node end],
				["source-dir/text()",							agent do make_command (node.to_expanded_dir_path) end],
				["include/@name",									agent do additional_keys_table.put (new_empty_list, node) end],

				["include-class/text()",						agent extend_file_list (included_files)],
				["localized-file-names/text()",				agent extend_localized_file_name_list],
				["localized-www-content/text()",				agent extend_localized_www_content],
				["evolicity-template/@path",					agent extend_evolicity_parser_list],
				["evolicity-template/ignore-key/text()",	agent do evolicity_parser_list.last.ignored_keys.put (node) end],
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
			file_path: EL_FILE_PATH
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
			dir_path: EL_DIR_PATH; l_directory: EL_DIRECTORY
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
			dir_path: EL_DIR_PATH; web_menu_list: EL_ZSTRING_LIST; menu_name: ZSTRING
		do
			dir_path := node.to_expanded_dir_path
			if dir_path.exists then
				across File_system.recursive_files_with_extension (dir_path, Body_extension) as file_path loop
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

	Web_menu: ZSTRING
		once
			Result := "Web menu"
		end

	Body_extension: ZSTRING
		once
			Result := "body"
		end

	Default_extension: STRING = "e"

	English_prefixes: ARRAY [EL_READABLE_ZSTRING]
		local
			prefix_1, prefix_2: ZSTRING
		once
			prefix_1 := "English_"; prefix_2 := "Eng_"
			Result := << prefix_1, prefix_2 >>
		end

	Workarea_pyx_template: ZSTRING
		once
			Result := "workarea/localization/%S.pyx"
		end

end
