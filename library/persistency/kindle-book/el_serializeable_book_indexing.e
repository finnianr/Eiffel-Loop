note
	description: "Serializeable book indexing"
	descendants: "[
			EL_SERIALIZEABLE_BOOK_INDEXING*
				${EL_BOOK_HTML_CONTENTS_TABLE}
				${EL_BOOK_NAVIGATION_CONTROL_FILE}
				${EL_BOOK_PACKAGE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2008-04-21 19:24:48 GMT (Monday 21st April 2008)"
	revision: "10"

deferred class
	EL_SERIALIZEABLE_BOOK_INDEXING

inherit
	EVOLICITY_SERIALIZEABLE

	EL_MODULE_TUPLE

feature {NONE} -- Initialization

	make (a_book: like book)
		do
			path := Default_path; book := a_book
			if not a_book.info.cover_image_path.is_empty then
				path.cover := a_book.info.cover_image_path
			end
			make_from_file (a_book.output_dir + new_file_name)
		end

feature {NONE} -- Implementation

	new_file_name: ZSTRING
		deferred
		end

feature {NONE} -- Evolicity

	getter_function_table: like getter_functions
			--
		do
			create Result.make_assignments (<<
				["info",			agent: like book.info do Result := book.info end],
				["chapter_list",	agent: ITERABLE [EL_BOOK_CHAPTER] do Result := book.chapter_list end]
			>>)
		end

feature {NONE} -- Internal attributes

	book: EL_BOOK_ASSEMBLY

	path: like Default_path

feature {NONE} -- Constants

	Default_path: TUPLE [cover, ncx, book_toc: FILE_PATH]
		once
			create Result
			Tuple.fill (Result, "image/cover.png, book-navigation.ncx, book-toc.html")
		end
end