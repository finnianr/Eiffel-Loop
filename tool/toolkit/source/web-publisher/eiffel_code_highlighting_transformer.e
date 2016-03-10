note
	description: "Summary description for {EIFFEL_CODE_HIGHLIGHTING_TRANSFORMER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-10-06 17:24:35 GMT (Monday 6th October 2014)"
	revision: "6"

class
	EIFFEL_CODE_HIGHLIGHTING_TRANSFORMER

inherit
	EL_EIFFEL_TEXT_EDITOR
		rename
			edit_text as transform
		redefine
			make_default, transform, on_unmatched_text
		end

	EL_EIFFEL_PATTERN_FACTORY

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_MODULE_XML

create
	make, make_from_file

feature {NONE} -- Initialization

	make_default
		do
			make_machine
			Precursor
		end

	make (a_output: like output)
			--
		do
			make_default
			output := a_output
		end

	make_from_file (a_output: like output; file_path: EL_FILE_PATH; a_selected_features: like selected_features)
			--
		local
			source_lines: EL_FILE_LINE_SOURCE
		do
			make (a_output)

 			source_file_path := file_path
 			selected_features := a_selected_features
 			create source_lines.make (source_file_path)
			create selected_text.make (source_lines.byte_count)

			if selected_features.is_empty then
				do_once_with_file_lines (agent find_class_declaration, source_lines)
			else
				do_once_with_file_lines (agent find_feature_block, source_lines)
			end
			set_source_text (selected_text)
		end

feature -- Basic operations

	transform
			--
		do
			find_all
			write_events_text
		end

feature {NONE} -- Pattern definitions

	delimiting_pattern: EL_FIRST_MATCH_IN_LIST_TP
			--
		do
			create Result.make (<<
				eiffel_comment												|to| agent put_emphasis (?, "comment"),

				unescaped_eiffel_string (Default_match_action)	|to| agent put_emphasis (?, "quote"),
				quoted_eiffel_string (Default_match_action)		|to| agent put_emphasis (?, "quote"),
				quoted_eiffel_character (Default_match_action)	|to| agent put_emphasis (?, "quote"),

				one_of (<<
					string_literal ("<<"), string_literal (">>")
				>>)															|to| agent put_emphasis (?, "class"),
				identifier													|to| agent on_identifier
			>>)
		end

feature {NONE} -- Parsing actions

	on_unmatched_text (text: EL_STRING_VIEW)
			--
		do
			put_escaped (text)
		end

	on_identifier (text: EL_STRING_VIEW)
			--
		local
			i: INTEGER
			has_lower: BOOLEAN
			word: STRING
		do
			word := text
			from i := 1 until has_lower or i > word.count loop
				has_lower := word.item (i).to_character_8.is_lower
				i := i + 1
			end
			if has_lower then
				if Reserved_word_set.has (word) then
					put_emphasis (text, "keyword")
				else
					put_escaped (text)
				end

			elseif word.count > 1 and word /~ "NONE" then
				put_emphasis (text, "class")

			else
				put_escaped (text)
			end
		end

feature {NONE} -- Line procedure transitions for whole class

	find_class_declaration (line: ASTRING)
			--
		do
			if line.starts_with ("class") or else line.starts_with ("deferred") then
				append_to_selected_text (line)
				state := agent append_to_selected_text
			end
		end

	append_to_selected_text (line: ASTRING)
			--
		do
			if not selected_text.is_empty then
				selected_text.append_character ('%N')
			end
			line.grow (line.count + line.occurrences ('%T') * (Tab_spaces.count - 1))
			line.replace_substring_all ("%T", Tab_spaces)
			selected_text.append (line)
		end

feature {NONE} -- Line procedure transitions for selected features

	find_feature_block (line: ASTRING)
			--
		do
			if line.starts_with ("feature ") then
				last_feature_block_line := line
				state := agent find_selected_feature
			end
		end

	find_selected_feature (line: ASTRING)
			--
		local
			trimmed_line: ASTRING
			tab_count: INTEGER
			found: BOOLEAN
		do
			if line.starts_with ("feature ") then
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
							append_to_selected_text (last_feature_block_line)
							selected_text.append_character ('%N')
							last_feature_block_line_appended := last_feature_block_line
						end
						append_to_selected_text (line)
						state := agent find_feature_end
					end
					selected_features.forth
				end
			end
		end

	find_feature_end (line: ASTRING)
			--
		local
			trimmed_line: ASTRING
			tab_count: INTEGER
		do
			create trimmed_line.make_from_other (line)
			trimmed_line.left_adjust
			tab_count := line.count - trimmed_line.count
			if tab_count = 1 then
				state := agent find_selected_feature
				find_selected_feature (line)
			else
				append_to_selected_text (line)
			end
		end

feature {NONE} -- Implementation

	put_emphasis (text: EL_STRING_VIEW; name: STRING)
			--
		do
			put_string ("<em id=%""); put_string (name); put_string ("%">")
			put_escaped (text)
			put_string (End_emphasis)
		end

	put_escaped (text: EL_STRING_VIEW)
			--
		do
			put_string (XML.escaped_128_plus (text.to_string_8))
		end

	new_output: IO_MEDIUM
			--
		do
			create {EL_TEXT_IO_MEDIUM} Result.make (0)
		end

	selected_text: STRING

	selected_features: LIST [STRING]

	last_feature_block_line: STRING

	last_feature_block_line_appended: STRING

feature {NONE} -- Constants

	End_emphasis: STRING = "</em>"

	Tab_spaces: STRING
			--
		once
			create Result.make_filled (' ', 4)
		end

	Reserved_word_set: EL_HASH_SET [STRING]
			--
		once
			create Result.make (Reserved_word_list.count)
			Result.compare_objects
			from Reserved_word_list.start until Reserved_word_list.after loop
				Result.put (Reserved_word_list.item)
				Reserved_word_list.forth
			end
		end

end
