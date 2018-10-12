note
	description: "[
		Extract all html between `<body>' and `</body>' tags and output as `<subject name>.body'.
		Insert a page anchor before each h2 heading
			
			<a id="Title 1"></a>
			<h2>Title 1</h2>
			
		Insert a class attribute into the first h2 element in the page.

			<h2 class="first">Title 1</h2>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-12 16:56:16 GMT (Friday 12th October 2018)"
	revision: "6"

class
	EL_THUNDERBIRD_EXPORT_AS_XHTML_BODY

inherit
	EL_THUNDERBIRD_FOLDER_EXPORTER [EL_HTML_BODY_WRITER]
		rename
			End_tag_name as Body_tag_close
		redefine
			make, write_html, extend_html, find_end_tag
		end

	EL_MODULE_HTML

	EL_STRING_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_output_dir: EL_DIR_PATH)
			--
		do
			Precursor (a_output_dir)
			create h2_list.make
		end

feature {NONE} -- State handlers

	find_body (line: ZSTRING)
		do
			if line.begins_with (Body_tag) then
				h2_list.wipe_out
				state := agent find_right_angle_bracket
				find_right_angle_bracket (line)
			end
		end

	find_end_image_paragraph (line: ZSTRING)
		do
			if line.begins_with (Paragraph_tag.closed) then
				append_to_html (<< line, Div_end_tag, Div_end_tag >>)
				state := agent find_end_tag
			else
				extend_html (line)
			end
		end

	find_end_tag (line: ZSTRING)
		local
			pos_class: INTEGER; extra_lines: EL_ZSTRING_LIST
		do
			if line.has_substring (Class_paragraph_image) then
				pos_class := line.substring_index (Class_paragraph_image, 1)
				line.remove_substring (pos_class, pos_class + Class_paragraph_image.count)
				create extra_lines.make_from_array (<< "<div class=%"paragraph_image%">", "<div class=%"image%">" >>)
				-- In case <img is on previous line as in the case of a hyperlinked image
				if html_lines.last.has_substring (Image_open_tag) then
					extra_lines.extend (html_lines.last)
					html_lines.finish; html_lines.remove
				end
				extra_lines.extend (line)
				append_to_html (extra_lines.to_array)
				state := agent find_start_image_paragraph

			elseif line.begins_with (Preformat_tag) then
				extend_html (line)
				if not line.ends_with (Pre_end_tag) then
					state := agent find_preformatted_end_tag
				end
			else
				Precursor (line)
			end
		end

	find_preformatted_end_tag (line: ZSTRING)
		do
			html_lines.extend (line)
			if line.ends_with (Pre_end_tag) then
				state := agent find_end_tag
			end
		end

	find_right_angle_bracket (line: ZSTRING)
		do
			if line.ends_with_character ('>') then
				state := agent find_end_tag
			end
		end

	find_start_image_paragraph (line: ZSTRING)
		do
			if line.begins_with (Paragraph_tag.open) then
				append_to_html (<< Div_end_tag, "<div class=%"paragraph%">", line >>)
				state := agent find_end_image_paragraph
			else
				extend_html (line)
			end
		end

feature {NONE} -- Implementation

	append_to_html (lines: ARRAY [ZSTRING])
		do
			lines.do_all (agent extend_html)
		end

	extend_html (line: ZSTRING)
		local
			heading_text, anchor_id: ZSTRING; pos_right_bracket: INTEGER
		do
			if line.begins_with (H2_tag.open) then
				pos_right_bracket := line.index_of ('>', 1)
				heading_text := line.substring_between (H2_tag.open, H2_tag.closed, 1)
				if heading_text.ends_with (Html_break_tag) then
					heading_text.remove_tail (Html_break_tag.count)
				end
				if not heading_text.is_empty then
					anchor_id := Html.book_mark_anchor_markup (heading_text, Empty_string)
					anchor_id.prepend (line.substring (1, line.leading_white_space))
					Precursor (anchor_id)
					h2_list.extend (heading_text)
					if h2_list.count = 1 then
						-- insert a class attribute into the first h2 element in the page
						-- <h2 class="first">Title 1</h2>
						line.insert_string (First_h2_class_attribute, pos_right_bracket)
					end
				end
			end
			Precursor (line)
		end

	h2_list: LINKED_LIST [ZSTRING]
		-- heading list

	h2_list_file_path: EL_FILE_PATH
		do
			Result := output_file_path.with_new_extension (Header_list_extension)
		end

	on_email_collected
		do
			do_with_lines (agent find_body, raw_html_lines)
		end

	write_html
		local
			h2_file: EL_PLAIN_TEXT_FILE
		do
			html_lines.finish; html_lines.remove
			from html_lines.finish until html_lines.item.stripped /~ Break_tag loop
				html_lines.remove
				html_lines.finish
			end
			Precursor
			if is_html_updated then
				lio.put_path_field ("Write H2", h2_list_file_path)
				lio.put_new_line
				create h2_file.make_open_write (h2_list_file_path)
				h2_file.enable_bom
				h2_file.put_lines (h2_list)
				h2_file.close
			end
		end

feature {NONE} -- Constants

	Class_paragraph_image: ZSTRING
		once
			Result := "class=%"paragraph_image%""
		end

	Div_end_tag: ZSTRING
		once
			Result := XML.closed_tag ("div")
		end

	First_h2_class_attribute: ZSTRING
		once
			Result := " class=%"first%""
		end

	H2_tag: TUPLE [open, closed: ZSTRING]
		once
			Result := XML.tag ("h2")
		end

	Header_list_extension: ZSTRING
		once
			Result := "h2"
		end

	Image_open_tag: ZSTRING
		once
			Result := "<img"
		end

	Paragraph_tag: TUPLE [open, closed: ZSTRING]
		once
			Result := [XML.open_tag ("p"), XML.closed_tag ("p")]
		end

	Pre_end_tag: ZSTRING
		once
			Result := XML.closed_tag ("pre")
		end

	Preformat_tag: ZSTRING
		once
			Result := "<pre>"
		end

	Related_file_extensions: ARRAY [ZSTRING]
		once
			Result := << "body", "h2", "evc" >>
		end

end
