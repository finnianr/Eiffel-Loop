note
	description: "[
		Tab for EL_TAB_BOOK
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-05-10 10:53:34 GMT (Friday 10th May 2013)"
	revision: "3"

class
	EL_TAB [B -> {EV_BOX, EL_BOX} create make end]

inherit
	EV_NOTEBOOK_TAB

create
	make

feature {NONE} -- Initialization

	make (a_tab_book: like tab_book; a_long_text: READABLE_STRING_GENERAL)
		do
			tab_book := a_tab_book
			long_text := a_long_text
			create box.make (tab_book.border_cms, tab_book.padding_cms)
			tab_book.extend_item (box)
			make_with_widgets (tab_book, box)
			max_tab_text_width := Default_max_tab_text_width
			set_text (short_text)
		end

feature -- Access

	box: B

	long_text: READABLE_STRING_GENERAL

	short_text: READABLE_STRING_GENERAL
			--
		do
			if long_text.count > max_tab_text_width then
				Result := long_text.substring (1, max_tab_text_width) + ".. "
			else
				Result := long_text + " "
			end
		end

feature -- Element change

	set_long_text (a_long_text: like long_text)
		do
			long_text := a_long_text
			set_text (short_text)
		end

feature {EL_TAB_BOOK} -- Events

	on_selected
		do
		end

	on_deselected
		do
		end

feature -- Status change

	close
			--
		do
			on_tab_close
			tab_book.remove (Current)
		end

feature {NONE} -- Implementation

	tab_book: EL_TAB_BOOK [B]

	on_tab_close
			--
		do
		end

	max_tab_text_width: INTEGER

feature {NONE} -- Constant

	Default_max_tab_text_width: INTEGER = 25

end
