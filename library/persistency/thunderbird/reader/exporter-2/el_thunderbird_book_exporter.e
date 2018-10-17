note
	description: "Merge Thunderbird folder of emails into a HTML book"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-17 10:46:34 GMT (Wednesday 17th October 2018)"
	revision: "2"

class
	EL_THUNDERBIRD_BOOK_EXPORTER

inherit
	EL_THUNDERBIRD_FOLDER_READER
		export
			{EL_BOOK_CHAPTER} html_lines, last_header
		redefine
			make_default, read_mails
		end

create
	make

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			create chapter_list.make (10)
		end

feature -- Basic operations

	read_mails (mails_path: EL_FILE_PATH)
		local
			book_file: EL_PLAIN_TEXT_FILE
		do
			Precursor (mails_path)
			chapter_list.sort (True)
			create book_file.make_open_write (output_dir + "book.html")
			book_file.put_string (Html_tag.open)
			book_file.put_new_line
			across chapter_list as chapter loop
				book_file.put_lines (chapter.item.value.lines)
			end
			book_file.put_string (Html_tag.close)
			book_file.close
		end

feature {NONE} -- State handlers

	find_body (line: ZSTRING)
		do
			if line.begins_with (Body_tag) then
				state := agent find_right_angle_bracket
				find_right_angle_bracket (line)
			end
		end

	find_right_angle_bracket (line: ZSTRING)
		do
			if line.ends_with_character ('>') then
				state := agent find_end_tag
			end
		end

	find_end_tag (line: ZSTRING)
			--
		do
			if line.begins_with (Body_tag_close) then
				chapter_list.last_value.lines.extend (Empty_string)
				state := agent find_first_field

			elseif not line.is_empty then
				chapter_list.last_value.lines.extend (line)
			end
		end

feature {NONE} -- Implementation

	on_email_collected
		local
			chapter: like new_chapter
		do
			chapter := new_chapter
			chapter_list.extend (chapter.number, chapter)
			do_with_lines (agent find_body, html_lines)
		end

	new_chapter: EL_BOOK_CHAPTER
		do
			create Result.make (Current)
		end

feature {NONE} -- Internal attributes

	chapter_list: EL_KEY_SORTABLE_ARRAYED_MAP_LIST [NATURAL, EL_BOOK_CHAPTER]

end
