note
	description: "Summary description for {EIFFEL_NOTES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 11:05:16 GMT (Thursday 12th October 2017)"
	revision: "7"

class
	EIFFEL_NOTES

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_EIFFEL_KEYWORDS

	EL_MODULE_COLON_FIELD

	EL_MODULE_LIO

	EL_MODULE_USER_INPUT

	EL_MODULE_XML

	SHARED_HTML_CLASS_SOURCE_TABLE

create
	make

feature {NONE} -- Initialization

	make (a_relative_class_dir: like relative_class_dir; a_selected_fields: like selected_fields)
		do
			make_machine
			create fields.make_equal (3)
			relative_class_dir := a_relative_class_dir; selected_fields := a_selected_fields
		end

feature -- Access

	description_elements: NOTE_HTML_TEXT_ELEMENT_LIST
		do
			fields.search (Field_description)
			if fields.found then
				create Result.make (fields.found_item, relative_class_dir)
			else
				create Result.make_empty
			end
		end

	field_list: EL_ARRAYED_LIST [EVOLICITY_CONTEXT]
		local
			context: EVOLICITY_CONTEXT_IMP; element_list: NOTE_HTML_TEXT_ELEMENT_LIST
		do
			create Result.make (fields.count)
			across fields as l_field loop
				create element_list.make (l_field.item, relative_class_dir)
				create context.make
				context.put_variable (element_list, Var_element_list)
				context.put_variable (new_title (l_field.key), Var_title)
				if l_field.key ~ Field_description then
					Result.put_front (context)
				else
					Result.extend (context)
				end
			end
		end

	other_field_titles: EL_ZSTRING_LIST
			-- other fields besides the description
		do
			create Result.make_empty
			across fields as l_field loop
				if l_field.key /~ Field_description then
					Result.extend (new_title (l_field.key))
				end
			end
		end

feature -- Status query

	has_description: BOOLEAN
		do
			fields.search (Field_description)
			if fields.found then
				Result := not fields.found_item.is_empty
			end
		end

	has_fields: BOOLEAN
		do
			Result := not fields.is_empty
		end

	has_other_field_titles: BOOLEAN
		do
			Result := across fields as l_field some l_field.key /~ Field_description end
		end

feature -- Basic operations

	fill (source_path: EL_FILE_PATH)
		do
			do_once_with_file_lines (agent find_note_section, create {EL_FILE_LINE_SOURCE}.make_latin (1, source_path))
			across fields.current_keys as key loop
				if fields.item (key.item).is_empty then
					fields.remove (key.item)
				end
			end
		end

	check_class_references (base_name: ZSTRING)
		-- check class references in note fields
		do
			from fields.start until fields.after loop
				fields.item_for_iteration.do_all (agent check_links_for_line (?, base_name))
				fields.forth
			end
		end

feature {NONE} -- Line states

	find_field_text_start (line, field_name: ZSTRING; lines: EL_ZSTRING_LIST)
		local
			pos_quote: INTEGER; text: ZSTRING
		do
			pos_quote := line.index_of ('"', 1)
			if pos_quote > 0 then
				text := line.substring_end (pos_quote + 1)
				inspect text [text.count]
					when '"' then
						text.remove_tail (1)
						if field_name ~ Field_description
							and then not across Standard_descriptions as l_text some text.starts_with (l_text.item) end
							and then not text.is_empty
						then
							lines.extend (text)
						end
						state := agent find_note_section_end
					when '%%' then
						-- is a split line string
						text.remove_tail (1)
						state := agent find_split_line_string_end (?, text, lines)
					when '[' then
						state := agent find_manifest_string_end (?, lines)
				else
				end
			end
		end

	find_manifest_string_end (line: ZSTRING; lines: EL_ZSTRING_LIST)
		local
			indent: INTEGER
		do
			line.right_adjust
			indent := line.leading_occurrences ('%T')
			line.remove_head (indent.min (2))
			if line ~ Manifest_string_end then
				state := agent find_note_section_end
			else
				lines.extend (line)
			end
		end

	find_note_section (line: ZSTRING)
		do
			if across Indexing_keywords as keyword some line.starts_with (keyword.item) end then
				state := agent find_note_section_end
			end
		end

	find_note_section_end (line: ZSTRING)
		local
			field_name: ZSTRING; lines: EL_ZSTRING_LIST; found_end_keyword: BOOLEAN
			keywords: like Note_end_keywords
		do
			keywords := Note_end_keywords
			from keywords.start until keywords.after or found_end_keyword loop
				found_end_keyword := line.starts_with (keywords.item)
				keywords.forth
			end
			if found_end_keyword then
				state := agent find_note_section
			else
				field_name := Colon_field.name (line)
				if selected_fields.has (field_name) or else field_name ~ Field_description then
					create lines.make (5)
					fields [field_name] := lines
					state := agent find_field_text_start (?, field_name, lines)
					find_field_text_start (line, field_name, lines)
				end
			end
		end

	find_split_line_string_end (line, text: ZSTRING; lines: EL_ZSTRING_LIST)
		local
			text_part: ZSTRING; pos_percent: INTEGER
		do
			pos_percent := line.index_of ('%%', 1)
			if pos_percent > 0 then
				text_part := line.substring_end (pos_percent + 1)
				inspect text_part [text_part.count]
					when '"' then
						text_part.remove_tail (1)
						text.append (text_part)
						lines.append (text.substring_split (Escaped_new_line))
						state := agent find_note_section_end

					when '%%' then
						text_part.remove_tail (1)
						text.append (text_part)
				else
				end
			end
		end

feature {NONE} -- Implementation

	check_links_for_line (line, base_name: ZSTRING)
		do
			line.do_with_splits (Left_square_bracket, agent check_link_candidate (?, base_name))
		end

	check_link_candidate (str, base_name: ZSTRING)
		local
			pos_close: INTEGER; name: ZSTRING
		do
			if str.starts_with (Source_variable) then
				pos_close := str.index_of (']', Source_variable.count)
				if pos_close > 0 then
					name := class_name (str.substring (Source_variable.count + 1, pos_close - 1))
					if not Class_source_table.has_key (name) then
						lio.put_path_field ("Note source link in", relative_class_dir + base_name)
						lio.put_new_line
						lio.put_labeled_string ("Cannot find class", name)
						lio.put_new_line
						lio.put_new_line
					end
				end
			end
		end

	new_title (name: ZSTRING): ZSTRING
		do
			Result := name.as_proper_case; Result.replace_character ('_', ' ')
		end

feature {NONE} -- Internal attributes

	fields: EL_ZSTRING_HASH_TABLE [EL_ZSTRING_LIST]

	relative_class_dir: EL_DIR_PATH
		-- class page directory relative to index page directory tree

	selected_fields: EL_ZSTRING_LIST

feature {NONE} -- Constants

	Empty_dir: EL_DIR_PATH
		once
			create Result
		end

	Escaped_new_line: ZSTRING
		once
			Result := "%%N"
		end

	Field_description: ZSTRING
		once
			Result := "description"
		end

	Left_square_bracket: ZSTRING
		once
			Result := "["
		end

	Manifest_string_end: ZSTRING
		once
			Result := "]%""
		end

	Manifest_string_start: ZSTRING
		once
			Result := "%"["
		end

	Note_end_keywords: EL_ZSTRING_LIST
		once
			Result := Class_declaration_keywords.twin
			Result.extend ("end")
		end

	Source_variable: ZSTRING
		once
			Result := "$source "
		end

	Standard_descriptions: ARRAY [ZSTRING]
		once
			Result := << "Summary description for",  "Objects that ..." >>
		end

	Var_element_list: ZSTRING
		once
			Result := "element_list"
		end

	Var_title: ZSTRING
		once
			Result := "title"
		end

end
