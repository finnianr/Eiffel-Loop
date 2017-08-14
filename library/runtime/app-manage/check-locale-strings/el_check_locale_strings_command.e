note
	description: "Summary description for {CHECK_LOCALE_STRINGS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_CHECK_LOCALE_STRINGS_COMMAND

inherit
	EL_FILE_TREE_COMMAND
		rename
			make as make_command,
			tree_dir as source_dir
		redefine
			new_file_list
		end

	EL_EIFFEL_SOURCE_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_SHARED_LOCALE_TABLE

create
	default_create, make

feature {EL_SUB_APPLICATION} -- Initialization

	make (a_source_dir: like source_dir; include_path: EL_FILE_PATH; language: STRING)
		local
			included_lines: EL_FILE_LINE_SOURCE; file_path: EL_FILE_PATH
		do
			make_command (a_source_dir)
			make_machine
			translations := new_translation_table (language)
			translations.print_duplicates

			create included_files.make_empty
			create routine_lines.make_empty
			create parser.make
			create missing_keys.make_empty
			is_print_progress_disabled := True

			if not include_path.is_empty and then include_path.exists then
				create included_lines.make (include_path)
				across included_lines as line loop
					if not line.item.is_empty and then line.item [1] /= '#' then
						file_path := line.item
						file_path.expand
						if file_path.exists then
							included_files.extend (file_path)
						else
							lio.put_path_field ("Missing", file_path)
							lio.put_new_line
						end
					end
				end
			end
		end

feature -- Status query

	routine_has_english_prefix: BOOLEAN

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
				lio.put_new_line
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

	check_keys (locale_keys: EL_ZSTRING_LIST)
		do
			if not locale_keys.is_empty then
				across locale_keys as key loop
					lio.put_string_field ("id", key.item)
					if not translations.has (key.item) then
						missing_keys.extend (key.item)
						lio.put_string (" MISSING")
					end
					lio.put_new_line
				end
			end
		end

	do_with_file (source_path: EL_FILE_PATH)
		local
			missing: EL_MISSING_TRANSLATIONS; class_name: ZSTRING
		do
			lio.put_path_field ("Source", source_path)
			lio.put_new_line
			do_once_with_file_lines (agent find_class_declaration, create {EL_FILE_LINE_SOURCE}.make_latin (1, source_path))
			if not missing_keys.is_empty then
				class_name := source_path.base_sans_extension
				create missing.make_from_file (Workarea_pyx_template #$ [class_name])
				missing.class_name.append (class_name.as_upper)
				missing.translation_keys.merge_right (missing_keys)
				missing.serialize
			end
		end

	new_file_list: EL_SORTABLE_ARRAYED_LIST [EL_FILE_PATH]
		do
			Result := Precursor
			Result.append (included_files)
		end

feature {NONE} -- Internal attributes

	parser: EL_ROUTINE_LOCALE_STRING_PARSER

	routine_lines: EL_ZSTRING_LIST

	translations: EL_TRANSLATION_TABLE

	included_files: EL_FILE_PATH_LIST

	missing_keys: EL_ZSTRING_LIST

feature {NONE} -- Constants

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
