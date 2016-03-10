note
	description: "Summary description for {EL_TITLED_TAB_BOOK_WINDOW}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-01-04 9:10:17 GMT (Saturday 4th January 2014)"
	revision: "3"

class
	EL_TITLED_TAB_BOOK_WINDOW

inherit
	EL_TITLED_WINDOW
		redefine
			make
		end

	EL_MODULE_SCREEN
		undefine
			default_create, copy, is_equal
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			set_dimensions

			create main_container
			main_container.set_border_width (Screen.horizontal_pixels (Border_cms))
			tab_book := new_tab_book
			main_container.extend (tab_book)

			extend (main_container)
		end

feature -- Access

	tab_book: EL_DOCKED_TAB_BOOK

feature {NONE} -- Implementation

	set_dimensions
		do
		end

	main_container: EV_VERTICAL_BOX
		-- Main container (contains all widgets displayed in this window)

	new_tab_book: like tab_book
		do
			create Result.make (Current)
		end

feature {NONE} -- Constants

	Border_cms: REAL
		once
			Result := 0.07
		end
end
