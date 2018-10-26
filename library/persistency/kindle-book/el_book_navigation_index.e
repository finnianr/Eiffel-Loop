note
	description: "Book navigation index"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-26 9:52:38 GMT (Friday 26th October 2018)"
	revision: "1"

deferred class
	EL_BOOK_NAVIGATION_INDEX

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
				["author",			agent: ZSTRING do Result := book.info.author end],
				["title",			agent: ZSTRING do Result := book.info.title end],
				["uuid",				agent: ZSTRING do Result := book.info.uuid end],

				["chapter_list",	agent: ITERABLE [EL_BOOK_CHAPTER] do Result := book.chapter_list end]
			>>)
		end

feature {NONE} -- Internal attributes

	book: EL_BOOK_ASSEMBLY

end
