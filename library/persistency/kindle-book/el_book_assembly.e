note
	description: "[
		Assembly of all book components including OPF package, navigation control file and HTML table of contents
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-28 17:28:02 GMT (Sunday 28th October 2018)"
	revision: "2"

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

	output_dir: EL_DIR_PATH

feature {NONE} -- Implementation

	parts: ARRAY [EL_SERIALIZEABLE_BOOK_INDEXING]
		do
			Result := <<
				create {EL_BOOK_NAVIGATION_CONTROL_FILE}.make (Current),
				create {EL_BOOK_HTML_CONTENTS_TABLE}.make (Current),
				create {EL_BOOK_PACKAGE}.make (Current)
			>>
		end

feature -- Basic operations

	write_files
		do
			parts.do_all (agent {EL_SERIALIZEABLE_BOOK_INDEXING}.serialize)
		end
end
