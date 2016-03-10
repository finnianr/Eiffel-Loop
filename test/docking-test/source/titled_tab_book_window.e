note
	description: "Summary description for {EL_TITLED_TAB_BOOK_WINDOW}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-01-04 9:10:17 GMT (Saturday 4th January 2014)"
	revision: "3"

class
	TITLED_TAB_BOOK_WINDOW

inherit
	EV_TITLED_WINDOW

	SHARED_CONSTANTS
		undefine
			default_create, copy
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			default_create
			set_dimensions

			create main_container
			main_container.set_border_width (10)
			tab_book := new_tab_book
			main_container.extend (tab_book)

			extend (main_container)
			tab_book.extend (create {HOME_TAB_BOX}.make (Current))
		end

feature -- Access

	tab_book: like new_tab_book

feature -- Basic operations

	open_new_tab
		do
			tab_book.extend (create {TEST_TAB_BOX}.make (Current, tab_book))
		end

feature {NONE} -- Implementation

	set_dimensions
		do
			set_minimum_size (Half_screen_width, (Half_screen_width * 0.8).rounded)
		end

	main_container: EV_VERTICAL_BOX
			-- Main container (contains all widgets displayed in this window)

	new_tab_book: TEST_TAB_BOOK
		do
			create Result.make (Current)
		end

end
