note
	description: "Book with table of contents generated from Thunderbird email folder"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-26 9:53:39 GMT (Friday 26th October 2018)"
	revision: "1"

class
	EL_BOOK_ASSEMBLY

inherit
	EL_KEY_SORTABLE_ARRAYED_MAP_LIST [NATURAL, EL_BOOK_CHAPTER]
		rename
			value_list as chapter_list,
			make as make_with_count
		end

create
	make

feature {NONE} -- Initialization

	make (a_info: EL_BOOK_INFO; a_chapter_list: FINITE [EL_BOOK_CHAPTER]; a_output_dir: EL_DIR_PATH)
		do
			make_from_values (a_chapter_list, agent {EL_BOOK_CHAPTER}.number)
			output_dir := a_output_dir
			info := a_info
			sort (True)
		end

feature -- Access

	info: EL_BOOK_INFO

	html_contents_table: EL_BOOK_HTML_CONTENTS_TABLE
		do
			create Result.make (Current)
		end

	navigation_control_file: EL_BOOK_NAVIGATION_CONTROL_FILE
		do
			create Result.make (Current)
		end

	output_dir: EL_DIR_PATH

end
