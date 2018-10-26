note
	description: "Merge Thunderbird folder of numbered chapter emails into a HTML book"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-26 9:53:13 GMT (Friday 26th October 2018)"
	revision: "3"

class
	EL_THUNDERBIRD_BOOK_EXPORTER

inherit
	EL_THUNDERBIRD_XHTML_BODY_EXPORTER
		export
			{EL_BOOK_CHAPTER} html_lines, last_header
		redefine
			config, make_default, export_mails, on_email_collected, remove_old_files
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

	config: EL_ML_THUNDERBIRD_ACCOUNT_BOOK_EXPORTER

feature -- Basic operations

	export_mails (mails_path: EL_FILE_PATH)
		local
			book: EL_BOOK_ASSEMBLY
		do
			Precursor (mails_path)
			if across chapter_list as chapter some chapter.item.is_modified end then
				create book.make (config.book, chapter_list, output_dir)
				book.html_contents_table.serialize
				book.navigation_control_file.serialize
			else
				lio.put_labeled_string ("No modifications", output_file_path)
				lio.put_new_line
			end
		end

feature {NONE} -- Implementation

	on_email_collected
		local
			chapter: like chapter_list.item; number: NATURAL
			title: ZSTRING; subject: EL_ZSTRING_LIST
		do
			create subject.make_with_separator (last_header.subject, '.', False)
			if subject.count > 1 and then subject.first.is_natural then
				number := subject.first.to_natural
				subject.start
				subject.remove
				title := subject.joined ('.')
			else
				title := last_header.subject
			end
			create chapter.make (title, number, last_header.date, html_lines.joined_lines, output_dir)

			edit (chapter.text)
			if chapter.is_modified then
				chapter.serialize
			end
			chapter_list.extend (chapter)
		end

	remove_old_files
		do
		end

end
