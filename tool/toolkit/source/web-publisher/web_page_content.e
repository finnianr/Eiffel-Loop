note
	description: "Summary description for {WEB_CONTENT_CLEANER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 19:58:29 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	WEB_PAGE_CONTENT

inherit
	EL_FILE_EDITING_PROCESSOR
		redefine
			make_from_file
		end

	EL_TEXTUAL_PATTERN_FACTORY
		export
			{NONE} all
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		export
			{NONE} all
		end

	EL_MODULE_STRING
		export
			{NONE} all
		end

create
	make_from_file

feature {NONE} -- Initialization

 	make_from_file (content_path: EL_FILE_PATH)
 			--
 		local
 			content_body_path: EL_FILE_PATH
 		do
 			log.enter_with_args ("make_from_file", << content_path >>)
 			create last_language_name.make_empty
			content_body_path := content_path.with_new_extension ("body.html")

			create body_file.make_open_write (content_body_path.unicode)
			do_with_lines (agent find_body_tag, create {EL_FILE_LINE_SOURCE}.make (content_path))
			body_file.close

 			Precursor (content_body_path)

			edit_file
			log.exit
 		end

feature -- Status report

	has_contents: BOOLEAN

feature {NONE} -- Pattern definitions

	delimiting_pattern: EL_FIRST_MATCH_IN_LIST_TP
			--
		do
			Result := one_of (<<
				string_literal ("mozTocId")						 |to| agent delete,
				automatic_thunderbird_link,
				string_literal ("<!--mozToc h1")				 |to| agent on_contents_start,
				string_literal ("<a href=%"http://localhost/")	 |to| agent replace (?, "<a href=%""),
				image_tag_src,
				source_code_include
			>>)
		end

	automatic_thunderbird_link: EL_MATCH_ALL_IN_LIST_TP
			--
		local
			link_text: EL_MATCH_TP1_UNTIL_TP2_MATCH_TP
		do
			link_text := repeat_pattern_1_until_pattern_2 (any_character, string_literal ("</a>"))
			link_text.set_action_on_combined_repeated_match (agent on_unmatched_text)
			Result := all_of (<<
				string_literal ("<a"),
				white_space,
				string_literal ("class=%"moz-txt-link"),
				repeat_pattern_1_until_pattern_2 (any_character, string_literal ("%">")),
				link_text
			>>)
		end

	image_tag_src: EL_MATCH_ALL_IN_LIST_TP
			-- Remove http://localhost in src attribute of image tags
		local
			attributes: EL_MATCH_TP1_UNTIL_TP2_MATCH_TP
		do
			attributes := repeat_pattern_1_until_pattern_2 (
				any_character,
				string_literal ("src=%"http://localhost") |to| agent replace (?, "src=%"")
			)
			attributes.set_action_on_combined_repeated_match (agent on_unmatched_text)
			Result := all_of (<<
				string_literal ("<img ") |to| agent on_unmatched_text,
				attributes,
				repeat_pattern_1_until_pattern_2 (any_character, string_literal ("%">")) |to| agent on_unmatched_text
			>>)
		end

	source_code_include: EL_MATCH_ALL_IN_LIST_TP
			--
		local
			pre_content: EL_MATCH_TP1_WHILE_NOT_TP2_MATCH_TP
		do
			pre_content := while_not_pattern_1_repeat_pattern_2 (string_literal ("</pre>"), any_character)
			Result := all_of (<<
				string_literal ("<pre") |to| agent on_pre_tag,
				white_space,
				string_literal ("lang="),
				quoted_string_with_escape_sequence (string_literal ("\%""), agent on_language_name),
				maybe_white_space,
				character_literal ('>'),
				pre_content
			>>)
			pre_content.set_action_on_combined_repeated_match (agent on_pre_content)
		end

feature {NONE} -- Parsing actions

	on_contents_start (text: EL_STRING_VIEW)
			--
		do
			put_string (text)
			has_contents := True
		end

	on_pre_tag (text: EL_STRING_VIEW)
			--
		do
			last_language_name.wipe_out
		end

	on_language_name (text: EL_STRING_VIEW)
			--
		do
			last_language_name := text
		end

	on_pre_content (text: EL_STRING_VIEW)
			--
		local
			transformer: EIFFEL_CODE_HIGHLIGHTING_TRANSFORMER
			src_path: EL_FILE_PATH
			selected_class_features: LIST [STRING]
			src_path_steps: EL_PATH_STEPS
		do
			create src_path
			selected_class_features := String.delimited_list (text, "<br>")
			selected_class_features.start
			if not selected_class_features.after then
				src_path_steps := selected_class_features.item
				src_path := src_path_steps.as_expanded_file_path
				selected_class_features.remove
			end
			if not selected_class_features.is_empty then
				selected_class_features.finish
				if not selected_class_features.after and then selected_class_features.item.is_empty then
					selected_class_features.remove
				end
			end
			if last_language_name ~ "Eiffel" then
				put_string ("<pre class=%"Eiffel%">")
				if src_path.exists then
					create transformer.make_from_file (output, src_path, selected_class_features)
					transformer.transform
				else
					put_string ("File not found!")
					put_new_line
					put_string (text)
				end
				put_string ("</pre>")
			end
		end

feature {NONE} -- Line procedure transitions

	find_body_tag (line: EL_ASTRING)
			--
		do
			if line.starts_with ("<body") then
				state := agent find_end_of_body_attributes
				find_end_of_body_attributes (line)
			end
		end

	find_end_of_body_attributes (line: EL_ASTRING)
			--
		do
			if line.ends_with (">") then
				state := agent find_body_end
			end
		end

	find_body_end (line: EL_ASTRING)
			--
		do
			if line.starts_with ("</body>") then
				state := agent final
			else
				if line.starts_with ("<!--mozToc") then
					has_contents := True
				end
				body_file.put_string (line)
				body_file.put_new_line
			end
		end

feature {NONE} -- Implementation

	last_language_name: STRING

	body_file: PLAIN_TEXT_FILE

end