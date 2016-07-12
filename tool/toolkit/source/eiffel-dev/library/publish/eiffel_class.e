note
	description: "[
		Class to render github like markdown found in the description note field of Eiffel classes.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-11 18:05:14 GMT (Monday 11th July 2016)"
	revision: "9"

class
	EIFFEL_CLASS

inherit
	EVOLICITY_SERIALIZEABLE
		rename
			output_path as html_path
		undefine
			is_equal
		redefine
			make_default, serialize
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		undefine
			is_equal
		end

	COMPARABLE

	EL_STRING_CONSTANTS
		undefine
			is_equal
		end

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32
		undefine
			is_equal
		end

	EL_MODULE_DIRECTORY
		undefine
			is_equal
		end

	EL_MODULE_LOG
		undefine
			is_equal
		end

	EL_MODULE_UTF
		undefine
			is_equal
		end

	EL_MODULE_XML
		undefine
			is_equal
		end

create
	make

feature {NONE} -- Initialization

	make (a_source_path: like source_path; a_relative_html_path: like relative_html_path; a_repository: like repository)
			--
		local
			l_crc: like crc_generator; raw_source: STRING
		do
			relative_source_path := a_source_path.relative_path (a_repository.root_dir)
			make_from_template_and_output (
				a_repository.code_template_path, a_repository.output_dir + relative_source_path.with_new_extension ("html")
			)
			source_path := a_source_path; relative_html_path := a_relative_html_path; repository := a_repository
			name := source_path.without_extension.base.as_upper
			raw_source := File_system.plain_text (source_path)
			l_crc := crc_generator
			l_crc.add_string_8 (raw_source)
			crc_digest := l_crc.checksum
			code_text := new_code_text (raw_source)
			if html_path.exists then
				do_once_with_file_lines (agent find_meta_digest, create {EL_FILE_LINE_SOURCE}.make_latin (1, html_path))
			end
		end

	make_default
		do
			create source_path
			create name.make_empty
			create description_paragraphs.make_empty
			create preformatted_lines.make_empty
			create paragraph_lines.make_empty
			create class_index_top_dir
			make_machine
			Precursor
		end

feature -- Access

	code_text: ZSTRING

	description_paragraphs: EL_ARRAYED_LIST [HTML_PARAGRAPH]

	name: STRING

	relative_html_path: EL_FILE_PATH

	relative_source_path: EL_FILE_PATH

	source_path: EL_FILE_PATH

feature -- Status report

	has_description: BOOLEAN
		do
			Result := not description_paragraphs.is_empty
		end

	is_modified: BOOLEAN
		do
			Result := crc_digest /= meta_crc_digest
		end

	is_library: BOOLEAN
		do
			Result := relative_source_path.first_step ~ Library
		end

	has_class_name (a_name: ZSTRING): BOOLEAN
		local
			pos_name: INTEGER; c_left, c_right: CHARACTER_32
			l_text: like code_text
		do
			l_text := code_text
			from pos_name := 1 until Result or pos_name = 0 loop
				pos_name := l_text.substring_index (a_name, pos_name)
				if pos_name > 0 then
					c_left := l_text.item (pos_name - 1)
					c_right := l_text.item (pos_name + a_name.count)
					if (c_left.is_alpha or c_left = '_') or else (c_right.is_alpha or c_right = '_') then
						pos_name := (pos_name + a_name.count).min (l_text.count)
					else
						Result := True
					end
				end
			end
		end

feature -- Basic operations

	serialize
		do
			do_once_with_file_lines (agent parse_description, create {EL_FILE_LINE_SOURCE}.make_latin (1, source_path))
			Precursor
			repository.ftp_sync.extend_modified (html_path.relative_path (repository.output_dir))
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			if has_description = other.has_description then
				Result := name < other.name

			else
				Result := has_description
			end
		end

feature -- Element change

	set_class_index_top_dir (a_class_index_top_dir: like class_index_top_dir)
		do
			class_index_top_dir := a_class_index_top_dir
		end

feature {NONE} -- Line states Eiffel

	parse_description (line: ZSTRING)
		local
			description: ZSTRING
		do
			if colon_name (line) ~ Note_description then
				description := colon_value (line)
				if description ~ Manifest_string_start then
					state := agent find_end_of_description
				else
					description.remove_quotes
					if not across Standard_descriptions as text some description.starts_with (text.item) end then
						paragraph_lines.extend (description)
						add_paragraph
					end
					state := agent final
				end
			end
		end

	find_end_of_description (line: ZSTRING)
		local
			l_line: like new_trim_line
		do
			l_line := new_trim_line (line)
			if l_line.text ~ Manifest_string_end then
				add_paragraph
				state := agent final
			elseif l_line.text.is_empty then
				add_paragraph
			elseif l_line.indent > 2 then
				add_paragraph
				line.remove_head (3)
				preformatted_lines.extend (line)
				state := agent find_end_of_preformatted
			else
				paragraph_lines.extend (l_line.text)
			end
		end

	find_end_of_preformatted (line: ZSTRING)
		local
			l_line: like new_trim_line
		do
			l_line := new_trim_line (line)
			if l_line.text ~ Manifest_string_end then
				add_preformatted
				state := agent final
			elseif l_line.text.is_empty then
				preformatted_lines.extend (Empty_string)
			elseif l_line.indent = 2 then
				add_preformatted
				state := agent find_end_of_description
				find_end_of_description (line)
			else
				line.remove_head (3)
				preformatted_lines.extend (line)
			end
		end

feature {NONE} -- Line states HTML

	find_meta_digest (line: ZSTRING)
		do
			if line.has_substring (Digest_value) then
				meta_crc_digest := line.substring_between (Content_assignment, Meta_close, 1).to_natural
				state := agent final
			end
		end

feature {NONE} -- Implementation

	add_paragraph
		do
			if not paragraph_lines.is_empty then
				description_paragraphs.extend (create {HTML_PARAGRAPH}.make (html_description))
				paragraph_lines.wipe_out
			end
		end

	add_preformatted
		local
			pos_space: INTEGER; line: ZSTRING
		do
			if not preformatted_lines.is_empty then
				preformatted_lines.finish
				if preformatted_lines.item.is_empty then
					preformatted_lines.remove
				end
				preformatted_lines.expand_tabs (3)
				from preformatted_lines.start until preformatted_lines.after loop
					line := preformatted_lines.item
					if line.count > Maximum_code_width then
						from pos_space := line.count + 1 until pos_space < Maximum_code_width loop
							pos_space := line.last_index_of (' ', pos_space - 1)
						end
						line := line.substring (pos_space, line.count)
						preformatted_lines.item.remove_tail (line.count)
						preformatted_lines.put_right (new_filler (Maximum_code_width - line.count) + line)
						preformatted_lines.forth
					end
					preformatted_lines.forth
				end
				description_paragraphs.extend (create {HTML_PREFORMATTED}.make (XML.escaped (preformatted_lines.joined_lines)))
				preformatted_lines.wipe_out
			end
		end

	html_description: ZSTRING
			-- escaped description with html formatting
		local
			pos_open, pos_close, pos_space: INTEGER; done: BOOLEAN
			delimiter_start, delimiter_end, markup_open, markup_close: ZSTRING
		do
			Result := XML.escaped (paragraph_lines.joined_words)
			Anchor_relative_markup_open.keep_head (9)
			Anchor_relative_markup_open.append_string (class_index_top_dir.joined_dir_path (relative_source_path.parent).to_string)
			Anchor_relative_markup_open.append_string (Current_dir)

			across Highlight_markup as markup loop
				delimiter_start := markup.item.delimiter_start; delimiter_end := markup.item.delimiter_end
				markup_open := markup.item.markup_open; markup_close := markup.item.markup_close
				from done := False until done loop
					pos_open := Result.substring_index (delimiter_start, pos_open + 1)
					if pos_open > 0 then
						pos_close := Result.substring_index (delimiter_end, pos_open + delimiter_start.count)
						if pos_close > 0 then
							Result.replace_substring (markup_open, pos_open, pos_open + delimiter_start.count - 1)
							pos_close := pos_close + markup_open.count - delimiter_start.count
							Result.replace_substring (markup_close, pos_close, pos_close + delimiter_end.count - 1)
							if Anchor_start_markup.has (delimiter_start) then
								pos_space := Result.substring_index (Space_string, pos_open + 3)
								if pos_space > 0 then
									Result.replace_substring (Anchor_target, pos_space, pos_space)
								end
								pos_close := pos_close + Anchor_target.count - 1
							end
						end
					end
					done := pos_open = 0 or pos_close = 0
				end
			end
		end

	index_dir: ZSTRING
		do
			Result := Directory.relative_parent (relative_html_path.steps.count - 1)
		end

	top_dir: EL_DIR_PATH
		do
			Result := Directory.relative_parent (relative_source_path.steps.count - 1)
		end

feature {NONE} -- Factory

	new_code_text (raw_source: STRING): ZSTRING
		do
			if raw_source.starts_with (UTF.Utf_8_bom_to_string_8) then
				raw_source.remove_head (UTF.Utf_8_bom_to_string_8.count)
				create Result.make_from_utf_8 (raw_source)
			else
				create Result.make_from_latin_1 (raw_source)
			end
		end

	new_filler (n: INTEGER): ZSTRING
		do
			create Result.make_filled (' ', n)
		end

	new_markup_substitution (delimiter_start, delimiter_end, markup_open, markup_close: ZSTRING): like Highlight_markup.item
		do
			create Result
			Result.delimiter_start := delimiter_start
			Result.delimiter_end := delimiter_end
			Result.markup_open := markup_open
			Result.markup_close := markup_close
		end

	new_trim_line (line: ZSTRING): TUPLE [indent: INTEGER; text: ZSTRING]
		do
			create Result
			Result.indent := line.leading_occurrences ('%T')
			Result.text := line.twin
			Result.text.left_adjust
		end

feature {NONE} -- Internal attributes

	crc_digest: NATURAL
		-- Eiffel source digest

	meta_crc_digest: NATURAL
		-- digest in HTML

	paragraph_lines: EL_ZSTRING_LIST

	preformatted_lines: EL_ZSTRING_LIST

	repository: EIFFEL_REPOSITORY_PUBLISHER

	class_index_top_dir: EL_DIR_PATH
		-- top level directory relative to class-index.html for this class

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["crc_digest", 				agent: NATURAL_32_REF do Result := crc_digest.to_reference end],
				["code_text", 					agent: ZSTRING do Result := XML.escaped (code_text) end],
				["description_paragraphs", agent: ITERABLE [HTML_PARAGRAPH] do Result := description_paragraphs end],
				["name", 						agent: STRING do Result := name.string end],
				["name_as_lower", 			agent: STRING do Result := name.string.as_lower end],
				["html_path", 					agent: ZSTRING do Result := relative_html_path end],
				["relative_dir", 				agent: EL_DIR_PATH do Result := relative_source_path.parent end],
				["index_dir", 					agent index_dir],
				["is_library", 				agent: BOOLEAN_REF do Result := is_library.to_reference end],
				["source_path", 				agent: EL_FILE_PATH do Result := relative_source_path end],
				["top_dir", 					agent top_dir]
			>>)
		end

feature {NONE} -- Constants

	Content_assignment: ZSTRING
		once
			Result := "content=%""
		end

	Current_dir: ZSTRING
		once
			Result := "/."
		end

	Digest_value: ZSTRING
		once
			Result := "[
				"digest"
			]"
		end

	Highlight_markup: ARRAY [TUPLE [delimiter_start, delimiter_end, markup_open, markup_close: ZSTRING]]
		once
			Result := <<
				new_markup_substitution ("`", "&apos;", "<em id=%"code%">", "</em>"),
				new_markup_substitution ("**", "**", "<b>", "</b>"),
				new_markup_substitution (Anchor_delimiter_start, "]", "<a href=%"http://", "</a>"),
				new_markup_substitution (Anchor_relative_delimiter_start, "]", Anchor_relative_markup_open, "</a>")
			>>
		end

	Anchor_target: ZSTRING
		once
			Result := "[
				" target="_blank">
			]"
		end

	Anchor_start_markup: ARRAY [ZSTRING]
		once
			Result := << Anchor_delimiter_start, Anchor_relative_delimiter_start >>
		end

	Anchor_delimiter_start: ZSTRING
		once
			Result := "[http://"
		end

	Anchor_relative_delimiter_start: ZSTRING
		once
			Result := "[."
		end

	Anchor_relative_markup_open: ZSTRING
		once
			Result := "<a href=%""
		end

	Manifest_string_end: ZSTRING
		once
			Result := "]%""
		end

	Library: ZSTRING
		once
			Result := "library"
		end

	Manifest_string_start: ZSTRING
		once
			Result := "%"["
		end

	Maximum_code_width: INTEGER
		once
			Result := 83
		end

	Meta_close: ZSTRING
		once
			Result := "%"/>"
		end

	Note_description: ZSTRING
		once
			Result := "description"
		end

	Standard_descriptions: ARRAY [ZSTRING]
		once
			Result := << "Summary description for",  "Objects that ..." >>
		end

	Tab_spaces: INTEGER = 3

	Template: STRING = ""

end
