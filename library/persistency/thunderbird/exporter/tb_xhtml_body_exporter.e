note
	description: "[
		Export Thunderbird email folders as HTML body content between `<body>' and `</body>' tags and
		output as `<subject name>.body'. Insert a page anchor before each h2 heading

			<a id="Title_1"/>
			<h2>Title 1</h2>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-25 19:14:34 GMT (Wednesday 25th January 2023)"
	revision: "16"

class
	TB_XHTML_BODY_EXPORTER

inherit
	TB_XHTML_FOLDER_EXPORTER
		redefine
			make_default, check_paragraph_count, edit, write_html, new_content_lines
		end

	EL_MODULE_HTML

create
	make

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			create h2_list.make (5)
		end

feature {NONE} -- Implementation

	check_paragraph_count (body_text: STRING)
		do
			Precursor (XML.document_text ("html", "UTF-8", body_text))
		end

	edit (html_doc: ZSTRING)
		do
			insert_h2_id_elements (html_doc)
			Precursor (html_doc)
		end

	insert_h2_id_elements (html_doc: ZSTRING)
		do
			h2_list.wipe_out
			html_doc.edit (header_tag (2).open, header_tag (2).close, agent check_h2_tag)
		end

	h2_list: ARRAYED_LIST [ZSTRING]
		-- heading list

	h2_list_file_path: FILE_PATH
		do
			Result := output_file_path.with_new_extension (Header_list_extension)
		end

	new_content_lines (email: TB_EMAIL): EL_ZSTRING_LIST
		-- everything inside <body> </body> tags
		local
			collecting, done: BOOLEAN
		do
			create Result.make (email.content.occurrences ('%N') + 1)
			across email.content.split ('%N') as line until done loop
				if collecting then
					if line.item.has_substring (Tag.body.close) then
						done := True
					else
						Result.extend (line.item_copy)
					end

				elseif line.item.has_substring (Tag_start.body) then
					collecting := True
				end
			end
		end

	write_html (html_doc: ZSTRING)
		local
			h2_file: EL_PLAIN_TEXT_FILE
		do
			Precursor (html_doc)
			if is_html_updated then
				if h2_list.count > 0 then
					lio.put_path_field ("Write H2", h2_list_file_path)
					lio.put_new_line
					create h2_file.make_open_write (h2_list_file_path)
					h2_file.byte_order_mark.enable
					h2_file.put_lines (h2_list)
					h2_file.close
				elseif h2_list_file_path.exists then
					File_system.remove_file (h2_list_file_path)
				end
			end
		end

feature {NONE} -- Editing routines

	check_h2_tag (start_index, end_index: INTEGER; target: ZSTRING)
		local
			s: EL_ZSTRING_ROUTINES; h2_content: ZSTRING
		do
			h2_content := target.substring (start_index, target.count - 5)
			h2_content.replace_character ('%N', ' ')
			if h2_content.has ('<') then
--				Remove formatting markup from headers like: <h2>Introduction to <i>My Ching</i></h2>
				h2_content.edit (s.character_string ('<'), s.character_string ('>'), agent remove_markup)
			end
			target.replace_substring (h2_content, start_index, target.count - 5)
			target.share (Anchor_template #$ [Html.anchor_name (h2_content), target])

			h2_list.extend (h2_content)
		end

	remove_markup (start_index, end_index: INTEGER; target: ZSTRING)
		do
			target.wipe_out
		end

feature {NONE} -- Constants

	Header_list_extension: ZSTRING
		once
			Result := "h2"
		end

	Related_file_extensions: EL_ZSTRING_LIST
		once
			Result := "body, h2, evc"
		end

end
