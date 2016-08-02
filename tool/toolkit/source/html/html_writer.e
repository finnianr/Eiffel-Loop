note
	description: "Summary description for {HTML_WRITER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-20 9:36:12 GMT (Wednesday 20th January 2016)"
	revision: "1"

deferred class
	HTML_WRITER

inherit
	EL_TEXT_FILE_EDITOR
		rename
			edit as write
		redefine
			close
		end

	EL_MODULE_TIME

	EL_XML_TEXT_PATTERN_FACTORY

feature {NONE} -- Initialization

	make (a_source_text: ZSTRING; output_path: EL_FILE_PATH; a_date_stamp: like date_stamp)
		do
			make_default
			date_stamp := a_date_stamp
			create last_attribute_name.make_empty
			set_output_file_path (output_path)
			set_source_text (a_source_text)
			set_utf_encoding (8)
		end

feature {NONE} -- Patterns

	trailing_line_break: like all_of
		do
			Result := all_of (<<
				all_of (<<
					string_literal ("<br>"), end_of_line_character, maybe_non_breaking_white_space
				>>)  |to| agent delete,

				all_of (<<
					string_literal ("</"), c_identifier, character_literal ('>')

				>>) |to| agent on_unmatched_text
			>>)
		end

	empty_tag_set: like all_of
		local
			tag_name: like c_identifier
		do
			tag_name := c_identifier
			Result := all_of (<<
				maybe_non_breaking_white_space,
				character_literal ('<'),
				tag_name,
				string_literal ("> </"),
				previously_matched (tag_name),
				character_literal ('>'),
				end_of_line_character
			>>) |to| agent delete
		end

	preformat_end_tag: like all_of
		do
			Result := all_of (<<
				end_of_line_character 		|to| agent delete,
				string_literal ("</pre>")	|to| agent on_unmatched_text
			>>)
		end

	anchor_element_tag: like element_tag
		do
			Result := element_tag ("a", << "id", "href", "name", "target", "title" >>)
		end

	image_element_tag: like element_tag
		do
			Result := element_tag ("img", << "alt", "src", "title", "onclick", "class" >>)
		end

	element_tag (name: STRING; attribute_list: ARRAY [ZSTRING]): like all_of
		local
			element_open: STRING
		do
			element_open := "<" + name
			attribute_list.compare_objects
			Result := all_of (<<
				string_literal (element_open),
				repeat_p1_until_p2 (
					all_of (<<
						white_space,
						xml_attribute (agent on_attribute_name, agent on_attribute_value (?, attribute_list))
					>>),
					character_literal ('>')
				)
			>>)
			Result.set_action_first (agent on_tag_begin (?, element_open))
			Result.set_action_last (agent on_tag_end)
		end

feature {NONE} -- Event handling

	on_tag_begin (match_text: EL_STRING_VIEW; element_open: STRING)
		do
			put_string (element_open)
		end

	on_tag_end (match_text: EL_STRING_VIEW)
		do
			put_string (">")
		end

	on_attribute_name (match_text: EL_STRING_VIEW)
		do
			last_attribute_name := match_text
		end

	on_attribute_value (match_text: EL_STRING_VIEW; attribute_list: ARRAY [ZSTRING])
		local
			value: ZSTRING; words: EL_ZSTRING_LIST
		do
			value := match_text.to_string.translated (New_line_and_tab, Spaces)
			words := value
			words.do_all (agent {ZSTRING}.right_adjust)
			words.prune_all_empty
			value := words.joined_words

			if attribute_list.has (last_attribute_name) then
				if value.starts_with (Http_localhost_path) then
					value.remove_head (Http_localhost_path.count)
				end
				put_last_attribute (value)
			end
		end

feature {NONE} -- Implementation

	normalized_attribute_value (value: ZSTRING)
		do
		end

	put_last_attribute (value: ZSTRING)
		do
			put_string (Attribute_template #$ [last_attribute_name, value.translated (New_line_string, Space_string)])
		end

	image_tag_text (match_text: EL_STRING_VIEW): ZSTRING
		local
			pos_height_attribute: INTEGER
		do
			Result := match_text
			Result.replace_substring_all (Http_localhost_path, Empty_string)
			pos_height_attribute := Result.substring_index (Attribute_height, 1)
			if pos_height_attribute > 0 then
				Result.keep_head (pos_height_attribute - 2)
				Result.append_character ('>')
			end
		end

	close
			--
		do
			Precursor
			output.set_date (Time.unix_date_time (date_stamp))
		end

	date_stamp: DATE_TIME

	last_attribute_name: ZSTRING

feature {NONE} -- Constants

	Attribute_height: ZSTRING
		once
			Result := "height="
		end

	Attribute_template: ZSTRING
		once
			Result := " %S=%"%S%""
		end

	Http_localhost_path: ZSTRING
		once
			Result := "http://localhost"
		end

	New_line_and_tab: ZSTRING
		once
			Result := "%N%T"
		end

	Spaces: ZSTRING
		once
			create Result.make_filled (' ', New_line_and_tab.count)
		end

end