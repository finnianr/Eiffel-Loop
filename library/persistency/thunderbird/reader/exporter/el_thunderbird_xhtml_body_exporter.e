note
	description: "[
		Export Thunderbird email folders as HTML body content between `<body>' and `</body>' tags and
		output as `<subject name>.body'. Insert a page anchor before each h2 heading

			<a id="Title_1"/>
			<h2>Title 1</h2>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-22 10:30:26 GMT (Monday 22nd October 2018)"
	revision: "2"

class
	EL_THUNDERBIRD_XHTML_BODY_EXPORTER

inherit
	EL_THUNDERBIRD_XHTML_EXPORTER
		redefine
			make, edit, write_html,
			on_first_tag, on_last_tag,
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
			create h2_list.make (5)
		end

feature {NONE} -- State handlers

	on_first_tag (line: ZSTRING)
		do
			state := agent find_right_angle_bracket
			find_right_angle_bracket (line)
		end

	on_last_tag (line: ZSTRING)
		do
			on_email_collected
			state := agent find_first_header
		end

	find_right_angle_bracket (line: ZSTRING)
		do
			if line.ends_with_character ('>') then
				state := agent find_last_tag
			end
		end

feature {NONE} -- Implementation

	edit (html_doc: ZSTRING)
		do
			insert_h2_id_elements (html_doc)
			Precursor (html_doc)
		end

	insert_h2_id_elements (html_doc: ZSTRING)
		do
			h2_list.wipe_out
			html_doc.edit (H2_tag.open, H2_tag.closed, agent check_h2_tag)
		end

	h2_list: ARRAYED_LIST [ZSTRING]
		-- heading list

	h2_list_file_path: EL_FILE_PATH
		do
			Result := output_file_path.with_new_extension (Header_list_extension)
		end

	write_html
		local
			h2_file: EL_PLAIN_TEXT_FILE
		do
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
		do
			h2_list.extend (substring.substring (start_index, substring.count - 5))
			substring.share (Anchor_template #$ [Html.anchor_name (h2_list.last), substring])
		end

feature {NONE} -- Constants

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

	Last_doc_tag: ZSTRING
		once
			Result := Body_tag_close
		end

	Related_file_extensions: ARRAY [ZSTRING]
		once
			Result := << "body", "h2", "evc" >>
		end

end
