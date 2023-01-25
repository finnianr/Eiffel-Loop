note
	description: "Merge Thunderbird folder of numbered chapter emails into a HTML book"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-25 19:16:59 GMT (Wednesday 25th January 2023)"
	revision: "11"

class
	TB_BOOK_EXPORTER

inherit
	TB_XHTML_BODY_EXPORTER
		redefine
			config, make_default, export_mails, write_lines, remove_old_files, edit_list_tag
		end

create
	make

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			create chapter_list.make (20)
		end

feature -- Access

	chapter_list: ARRAYED_LIST [EL_BOOK_CHAPTER]

	config: TB_MULTI_LANG_ACCOUNT_BOOK_EXPORTER

feature -- Basic operations

	export_mails (email_list: TB_EMAIL_LIST)
		do
			Precursor (email_list)
			if across chapter_list as chapter some chapter.item.is_modified end then
				on_chapter_modified
			else
				lio.put_labeled_string ("No modifications", output_file_path)
				lio.put_new_line
			end
		end

feature {NONE} -- Implementation

	edit_list_tag (start_index, end_index: INTEGER; substring: ZSTRING)
		do
			Precursor (start_index, end_index, substring)
			if not substring.is_empty and then substring.same_characters ("ol", 1, 2, 2) then
				substring.insert_string (Ordered_list_from_1, start_index - 1)
			end
		end

	on_chapter_modified
		local
			assembly: EL_BOOK_ASSEMBLY
		do
			across chapter_list as chapter loop
				if chapter.item.is_modified then
					chapter.item.serialize
				end
			end
			create assembly.make (config.book, chapter_list, output_dir)
			assembly.write_files
		end

	write_lines (email: TB_EMAIL)
		local
			chapter: like chapter_list.item; number: NATURAL
			title, html_content: ZSTRING; subject: EL_ZSTRING_LIST
		do
			create subject.make_split (email.subject_decoded, '.')
			if subject.count > 1 and then subject.first.is_natural then
				number := subject.first.to_natural
				subject.start
				subject.remove
				title := subject.joined ('.')
			else
				title := email.subject_decoded
			end
			html_content := new_html_lines (email).joined_lines
			create chapter.make (title, number, email.modification_time, html_content, output_dir)

			edit (chapter.text)
			chapter_list.extend (chapter)
		end

	remove_old_files (email_list: TB_EMAIL_LIST)
		do
		end

feature {NONE} -- Constants

	Ordered_list_from_1: ZSTRING
		once
			Result := "[
				start="1" type="1"
			]"
			Result.prepend_character (' ')
		end
end

