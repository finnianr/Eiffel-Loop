note
	description: "Eiffel notes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-31 15:08:09 GMT (Monday 31st July 2023)"
	revision: "30"

class
	EIFFEL_NOTES

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_default
		redefine
			make_default
		end

	EL_EIFFEL_KEYWORDS

	EL_MODULE_USER_INPUT

	EL_MODULE_XML

	SHARED_CLASS_PATH_TABLE

	SHARED_ISE_CLASS_TABLE

	SHARED_INVALID_CLASSNAMES

create
	make, make_default

feature {NONE} -- Initialization

	make (a_relative_class_dir: like relative_class_dir; a_selected_fields: like selected_fields)
		do
			make_default
			relative_class_dir := a_relative_class_dir; selected_fields := a_selected_fields
		end

	make_default
		do
			Precursor
			create fields.make_equal (3)
			create last_field_name.make_empty
			create note_lines.make (5)
			create relative_class_dir
			create selected_fields.make_empty
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

	field_list: EL_ARRAYED_LIST [EVOLICITY_TUPLE_CONTEXT]
		local
			context: EVOLICITY_TUPLE_CONTEXT; element_list: NOTE_HTML_TEXT_ELEMENT_LIST
		do
			create Result.make (fields.count)
			across fields as l_field loop
				create element_list.make (l_field.item, relative_class_dir)
				create context.make ([element_list, l_field.key], once "element_list, title")
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

	check_class_references (base_name: ZSTRING)
		-- check class references in note fields
		do
			from fields.start until fields.after loop
				fields.item_for_iteration.do_all (agent check_links_for_line (?, base_name))
				fields.forth
			end
		end

	fill (source_path: FILE_PATH)
		local
			key_list: EL_ZSTRING_LIST
		do
			do_once_with_file_lines (agent find_note_section, open_lines (source_path, Latin_1))

			-- prune empty fields
			key_list := note_lines; key_list.wipe_out
			across fields as f loop
				if f.item.is_empty then
					key_list.extend (f.key)
				end
			end
			key_list.do_all (agent fields.remove)
		end

feature -- Element change

	set_relative_class_dir (a_relative_class_dir: like relative_class_dir)
		do
			relative_class_dir := a_relative_class_dir
		end

feature {NONE} -- Line states

	find_field_text_start (line: ZSTRING)
		local
			pos_quote: INTEGER; text: ZSTRING; s: EL_ZSTRING_ROUTINES
		do
			pos_quote := line.index_of ('"', 1)
			if pos_quote > 0 then
				text := line.substring_end (pos_quote + 1)
				inspect text [text.count]
					when '"' then
						text.remove_tail (1)
						if last_field_name ~ Field_description
							and then Standard_descriptions.there_exists (agent s.starts_with (text, ?))
						then
							text.wipe_out
						end
						if not text.is_empty then
							note_lines.extend (text)
						end
						state := agent find_note_section_end
					when '%%' then
						-- is a split line string
						text.remove_tail (1)
						state := agent find_split_line_string_end (?, text)
					when '[' then
						state := agent find_manifest_string_end
				else
				end
			end
		end

	find_manifest_string_end (line: ZSTRING)
		local
			indent: INTEGER
		do
			line.right_adjust
			indent := line.leading_occurrences ('%T')
			line.remove_head (indent.min (2))
			if line ~ Manifest_string_end then
				state := agent find_note_section_end
			else
				note_lines.extend (line)
			end
		end

	find_note_section (line: ZSTRING)
		do
			if across Indexing_keywords as word some line.starts_with (word.item) end then
				state := agent find_note_section_end
			end
		end

	find_note_section_end (line: ZSTRING)
		local
			s: EL_ZSTRING_ROUTINES; field: EL_COLON_FIELD_ROUTINES
		do
			if not note_lines.is_empty then
				if selected_fields.has (last_field_name) or else last_field_name ~ Field_description then
					fields [last_field_name] := note_lines.twin
				end
				note_lines.wipe_out
			end
			Note_end_keywords.find_first_true (agent s.starts_with (line, ?))
			if Note_end_keywords.found then
				state := agent find_note_section

			elseif line.has (':') then
				last_field_name := field.name (line)
				state := agent find_field_text_start
				find_field_text_start (line)
			end
		end

	find_split_line_string_end (line, text: ZSTRING)
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
						note_lines.append (text.substring_split (Escaped_new_line))
						state := agent find_note_section_end

					when '%%' then
						text_part.remove_tail (1)
						text.append (text_part)
				else
				end
			end
		end

feature {NONE} -- Implementation

	check_link_candidate (str, base_name: ZSTRING)
		local
			pos_close: INTEGER; text: ZSTRING
		do
			if str.starts_with (Source_variable) then
				pos_close := str.index_of (']', Source_variable.count)
				if pos_close > 0 then
					text := str.substring (Source_variable.count + 1, pos_close - 1)
					if Class_path_table.has_class (text) then
						do_nothing
					elseif ISE_class_table.has_class (text) then
						do_nothing
					else
						Invalid_source_name_table.extend (relative_class_dir + base_name, Class_path_table.last_name)
					end
				end
			end
		end

	check_links_for_line (line, base_name: ZSTRING)
		do
			line.do_with_splits (Left_square_bracket, agent check_link_candidate (?, base_name))
		end

	new_title (name: ZSTRING): ZSTRING
		do
			Result := name.as_proper_case; Result.replace_character ('_', ' ')
		end

feature {NONE} -- Internal attributes

	note_lines: EL_ZSTRING_LIST

	last_field_name: ZSTRING

	fields: EL_ZSTRING_HASH_TABLE [EL_ZSTRING_LIST]

	relative_class_dir: DIR_PATH
		-- class page directory relative to index page directory tree

	selected_fields: EL_ZSTRING_LIST

feature {NONE} -- Constants

	Empty_dir: DIR_PATH
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

end