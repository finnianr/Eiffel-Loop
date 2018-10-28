note
	description: "Serializeable book indexing"
	descendants: "[
			EL_SERIALIZEABLE_BOOK_INDEXING*
				[$source EL_BOOK_HTML_CONTENTS_TABLE]
				[$source EL_BOOK_NAVIGATION_CONTROL_FILE]
				[$source EL_BOOK_PACKAGE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-28 17:26:05 GMT (Sunday 28th October 2018)"
	revision: "2"

deferred class
	EL_SERIALIZEABLE_BOOK_INDEXING

inherit
	EVOLICITY_SERIALIZEABLE

feature {NONE} -- Initialization

	make (a_book: like book)
		do
			make_from_file (a_book.output_dir + new_file_name)
			book := a_book
		end

feature {NONE} -- Implementation

	new_file_name: ZSTRING
		deferred
		end

feature {NONE} -- Evolicity

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["info",			agent: like book.info do Result := book.info end],
				["chapter_list",	agent: ITERABLE [EL_BOOK_CHAPTER] do Result := book.chapter_list end]
			>>)
		end

feature {NONE} -- Internal attributes

	book: EL_BOOK_ASSEMBLY

end
