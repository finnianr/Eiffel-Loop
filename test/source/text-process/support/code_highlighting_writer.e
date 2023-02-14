note
	description: "Eiffel HTML code highlighting writer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-14 18:37:43 GMT (Tuesday 14th February 2023)"
	revision: "23"

class
	CODE_HIGHLIGHTING_WRITER

inherit
	EL_FILE_PARSER_TEXT_EDITOR
		redefine
			make_default, on_unmatched_text, new_output, put_editions
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	TP_EIFFEL_FACTORY

	EL_EIFFEL_KEYWORDS

	EL_MODULE_XML

create
	make, make_from_file

feature {NONE} -- Initialization

	make (a_output: like output)
			--
		do
			make_default
			output := a_output
			set_encoding_from_other (output)
		end

	make_default
		do
			make_machine
			Precursor
		end

	make_from_file (a_output: like output; a_file_path: FILE_PATH; a_selected_features: like selected_features)
			--
		do
			make (a_output)

 			file_path := a_file_path
 			selected_features := a_selected_features
 			if attached open_lines (file_path, Utf_8) as source_lines then
				create source_text.make (source_lines.byte_count)

				if selected_features.is_empty then
					do_once_with_file_lines (agent find_class_declaration, source_lines)
				else
					do_once_with_file_lines (agent find_feature_block, source_lines)
				end
 			end
			core := optimal_core (source_text)
		end

feature {NONE} -- Pattern definitions

	array_brackets: like one_of
		do
			Result := one_of (<<
				string_literal ("<<"),
--				OR
				string_literal (">>")
			>>)
		end

	delimiting_pattern: like one_of
			--
		do
			create Result.make (<<
				comment									|to| agent put_emphasis (?, ?, "comment"),

				unescaped_manifest_string (Void)	|to| agent put_emphasis (?, ?, "quote"),
				quoted_string (Void)					|to| agent put_emphasis (?, ?, "quote"),
				quoted_character (Void)				|to| agent put_emphasis (?, ?, "quote"),

				array_brackets							|to| agent put_emphasis (?, ?, "class"),
				identifier								|to| agent on_identifier
			>>)
		end

feature {NONE} -- Parsing actions

	on_identifier (start_index, end_index: INTEGER)
			--
		local
			i: INTEGER; has_lower: BOOLEAN
			word: STRING; eiffel: EL_EIFFEL_SOURCE_ROUTINES
		do
			word := source_text.substring (start_index, end_index)
			from i := 1 until has_lower or i > word.count loop
				has_lower := word.item (i).to_character_8.is_lower
				i := i + 1
			end
			if has_lower then
				if eiffel.is_reserved_word (word) then
					put_emphasis (start_index, end_index, "keyword")
				else
					put_escaped (start_index, end_index)
				end

			elseif word.count > 1 and word /~ "NONE" then
				put_emphasis (start_index, end_index, Keyword.class_)

			else
				put_escaped (start_index, end_index)
			end
		end

	on_unmatched_text (start_index, end_index: INTEGER)
			--
		do
			put_escaped (start_index, end_index)
		end

feature {NONE} -- Line procedure transitions for whole class

	append_to_source_text (line: ZSTRING)
			--
		do
			if not source_text.is_empty then
				source_text.append_character ('%N')
			end
			line.grow (line.count + line.occurrences ('%T') * (Tab_spaces.count - 1))
			line.replace_substring_all (Tab_character_string, Tab_spaces)
			source_text.append (line)
		end

	find_class_declaration (line: ZSTRING)
			--
		do
			if line.starts_with (Keyword.class_) or else line.starts_with (Keyword.deferred_) then
				append_to_source_text (line)
				state := agent append_to_source_text
			end
		end

feature {NONE} -- Line procedure transitions for selected features

	find_feature_block (line: ZSTRING)
			--
		do
			if line.starts_with (Keyword.feature_) then
				last_feature_block_line := line
				state := agent find_selected_feature
			end
		end

	find_feature_end (line: ZSTRING)
			--
		local
			trimmed_line: ZSTRING
			tab_count: INTEGER
		do
			create trimmed_line.make_from_other (line)
			trimmed_line.left_adjust
			tab_count := line.count - trimmed_line.count
			if tab_count = 1 then
				state := agent find_selected_feature
				find_selected_feature (line)
			else
				append_to_source_text (line)
			end
		end

	find_selected_feature (line: ZSTRING)
			--
		local
			trimmed_line: ZSTRING; tab_count: INTEGER; found: BOOLEAN
		do
			if line.starts_with (Keyword.feature_) then
				last_feature_block_line := line
			else
				create trimmed_line.make_from_other (line)
				trimmed_line.left_adjust
				tab_count := line.count - trimmed_line.count
				from selected_features.start until found or selected_features.after loop
					if tab_count = 1
						and then
							trimmed_line.starts_with (selected_features.item)
						and then
							(trimmed_line.count > selected_features.item.count
								implies not trimmed_line.item (selected_features.item.count + 1).is_alpha_numeric)
					then
						found := True
						if last_feature_block_line /= last_feature_block_line_appended then
							append_to_source_text (last_feature_block_line)
							source_text.append_character ('%N')
							last_feature_block_line_appended := last_feature_block_line
						end
						append_to_source_text (line)
						state := agent find_feature_end
					end
					selected_features.forth
				end
			end
		end

feature {NONE} -- Implementation

	new_output: EL_PLAIN_TEXT_FILE
			-- Use the initialized output
		do
			Result := output
		end

	put_editions
		do
			output.put_line (XML.header (1.0, output.encoding_name))
			output.put_line ("<html>")
			output.put_line ("<pre>")
			Precursor
			output.put_line ("</pre>")
			output.put_line ("</html>")
		end

	put_emphasis (start_index, end_index: INTEGER; name: STRING)
			--
		do
			put_string ("<em id=%""); put_string (name); put_string ("%">")
			put_escaped (start_index, end_index)
			put_string (End_emphasis)
		end

	put_escaped (start_index, end_index: INTEGER)
			--
		do
			put_string (XML.escaped_128_plus (source_text.substring (start_index, end_index)))
		end

feature {NONE} -- Internal attributes

	last_feature_block_line: ZSTRING

	last_feature_block_line_appended: ZSTRING

	selected_features: LIST [ZSTRING]

feature {NONE} -- Constants

	End_emphasis: ZSTRING
		once
			Result := "</em>"
		end

	Tab_character_string: ZSTRING
		once
			Result := "%T"
		end

	Tab_spaces: ZSTRING
			--
		once
			create Result.make_filled (' ', 4)
		end

end