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
	date: "2018-10-17 17:39:13 GMT (Wednesday 17th October 2018)"
	revision: "1"

class
	EL_THUNDERBIRD_FOLDER_TO_XHTML_BODY

inherit
	EL_THUNDERBIRD_FOLDER_TO_XHTML
		rename
			End_tag_name as Body_tag_close
		redefine
			make, edit, write_html,
			First_doc_tag, Last_doc_tag
		end

	EL_MODULE_HTML

	EL_ZSTRING_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_config: like config)
			--
		do
			Precursor (a_config)
			create h2_list.make
		end

feature {NONE} -- Implementation

	edit (html_doc: ZSTRING)
		do
			h2_list.wipe_out
			html_doc.edit (H2_tag.open, H2_tag.closed, agent check_h2_tag)
			Precursor (html_doc)
		end

	h2_list: LINKED_LIST [ZSTRING]
		-- heading list

	h2_list_file_path: EL_FILE_PATH
		do
			Result := output_file_path.with_new_extension (Header_list_extension)
		end

	write_html
		local
			h2_file: EL_PLAIN_TEXT_FILE; line: ZSTRING
		do
			-- Remove body tag
			from line := Empty_string until line.ends_with_character ('>') loop
				html_lines.start
				line := html_lines.item
				html_lines.remove
			end
			-- Remove body close tag
			html_lines.finish; html_lines.remove
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

feature {NONE} -- Editing routines

	check_h2_tag (start_index, end_index: INTEGER; substring: ZSTRING)
		local
			break_index: INTEGER
		do
			break_index := substring.substring_index (Html_break_tag, start_index)
			if break_index > 0 then
				substring.remove_substring (break_index, end_index)
			end
			h2_list.extend (substring.substring (start_index, substring.count - 5))
			substring.insert_string (Anchor_template #$ [Html.anchor_name (h2_list.last)], 1)
		end

feature {NONE} -- Constants

	Anchor_template: ZSTRING
		once
			Result := "[
				<a id="#"/>
			]" + "%N    "
		end

	First_doc_tag: ZSTRING
		once
			Result := Body_tag
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

	Last_doc_tag: ZSTRING
		once
			Result := Body_tag_close
		end

	Paragraph_tag: TUPLE [open, closed: ZSTRING]
		once
			Result := [XML.open_tag ("p"), XML.closed_tag ("p")]
		end

	Related_file_extensions: ARRAY [ZSTRING]
		once
			Result := << "body", "h2", "evc" >>
		end

end
