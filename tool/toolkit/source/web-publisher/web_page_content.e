note
	description: "Summary description for {WEB_CONTENT_CLEANER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-21 11:19:33 GMT (Thursday 21st January 2016)"
	revision: "6"

class
	WEB_PAGE_CONTENT

inherit
	EL_FILE_EDITING_PROCESSOR
		redefine
			make_default, make_from_file
		end

	EL_ZTEXT_PATTERN_FACTORY
		export
			{NONE} all
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		export
			{NONE} all
		end

	EL_MODULE_LOG

create
	make_from_file

feature {NONE} -- Initialization

	make_default
		do
			make_machine
			Precursor
		end

 	make_from_file (content_path: EL_FILE_PATH)
 			--
 		local
 			content_body_path: EL_FILE_PATH
 		do
 			log.enter_with_args ("make_from_file", << content_path >>)
 			create last_language_name.make_empty
			content_body_path := content_path.with_new_extension ("body.html")

			create body_file.make_open_write (content_body_path)
			do_once_with_file_lines (agent find_body_tag, create {EL_FILE_LINE_SOURCE}.make (content_path))
			body_file.close

 			Precursor (content_body_path)

			edit
			log.exit
 		end

feature -- Status report

	has_contents: BOOLEAN

feature {NONE} -- Pattern definitions

	automatic_thunderbird_link: like all_of
			--
		local
			link_text: like repeat_p1_until_p2
		do
			link_text := repeat_p1_until_p2 (any_character, string_literal ("</a>"))
			link_text.set_action_combined_p1 (agent on_unmatched_text)
			Result := all_of (<<
				string_literal ("<a"),
				white_space,
				string_literal ("class=%"moz-txt-link"),
				repeat_p1_until_p2 (any_character, string_literal ("%">")),
				link_text
			>>)
		end

	delimiting_pattern: like one_of
			--
		do
			Result := one_of (<<
				string_literal ("mozTocId")							 |to| agent delete,
				automatic_thunderbird_link,
				string_literal ("<!--mozToc h1")						 |to| agent on_contents_start,
				string_literal ("<a href=%"http://localhost/")	 |to| agent replace (?, "<a href=%""),
				image_tag_src,
				source_code_include
			>>)
		end

	image_tag_src: like all_of
			-- Remove http://localhost in src attribute of image tags
		local
			attributes: like repeat_p1_until_p2
		do
			attributes := repeat_p1_until_p2 (
				any_character,
				string_literal ("src=%"http://localhost") |to| agent replace (?, "src=%"")
			)
			attributes.set_action_combined_p1 (agent on_unmatched_text)
			Result := all_of (<<
				string_literal ("<img ") |to| agent on_unmatched_text,
				attributes,
				repeat_p1_until_p2 (any_character, string_literal ("%">")) |to| agent on_unmatched_text
			>>)
		end

	source_code_include: like all_of
			--
		local
			pre_content: like while_not_p1_repeat_p2
		do
			pre_content := while_not_p1_repeat_p2 (string_literal ("</pre>"), any_character)
			Result := all_of (<<
				string_literal ("<pre") |to| agent on_pre_tag,
				white_space,
				string_literal ("lang="),
				quoted_string (string_literal ("\%""), agent on_language_name),
				maybe_white_space,
				character_literal ('>'),
				pre_content
			>>)
			pre_content.set_action_combined_p2 (agent on_pre_content)
		end

feature {NONE} -- Parsing actions

	on_contents_start (text: EL_STRING_VIEW)
			--
		do
			put_string (text)
			has_contents := True
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
			selected_class_features: LIST [ZSTRING]
			src_path_steps: EL_PATH_STEPS; src_path: EL_FILE_PATH
		do
			create src_path
			selected_class_features := text.to_string.substring_split (Break_open)
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

	on_pre_tag (text: EL_STRING_VIEW)
			--
		do
			last_language_name.wipe_out
		end

feature {NONE} -- Line procedure transitions

	find_body_end (line: ZSTRING)
			--
		do
			if line.starts_with (Body_close) then
				state := agent final
			else
				if line.starts_with (Comment_moztoc) then
					has_contents := True
				end
				body_file.put_string (line)
				body_file.put_new_line
			end
		end

	find_body_tag (line: ZSTRING)
			--
		do
			if line.starts_with (Body_open) then
				state := agent find_end_of_body_attributes
				find_end_of_body_attributes (line)
			end
		end

	find_end_of_body_attributes (line: ZSTRING)
			--
		do
			if line.ends_with (Right_angle_bracket) then
				state := agent find_body_end
			end
		end

feature {NONE} -- Implementation

	body_file: PLAIN_TEXT_FILE

	last_language_name: STRING

feature {NONE} -- Constants

	Comment_moztoc: ZSTRING
		once
			Result := "<!--mozToc"
		end

	Body_open: ZSTRING
		once
			Result := "<body"
		end

	Body_close: ZSTRING
		once
			Result := "</body>"
		end

	Break_open: ZSTRING
		once
			Result := "<br>"
		end

	Right_angle_bracket: ZSTRING
		once
			Result := ">"
		end

end