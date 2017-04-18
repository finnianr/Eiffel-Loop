note
	description: "Summary description for {EL_TAB_2}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-01-28 14:21:57 GMT (Saturday 28th January 2017)"
	revision: "1"

class
	EL_NOTEBOOK_TAB [W -> {EV_WINDOW}]

inherit
	EV_NOTEBOOK_TAB

create
	make

feature {NONE} -- Initialization

	make (a_tab_book: like book; tab_content: EL_TAB_CONTENT [W])
		local
			cell: EV_CELL
		do
			book := a_tab_book
			create cell
			create content_box.make_with_container (cell, agent tab_content.new_box)
			book.extend_item (cell)
			make_with_widgets (book, cell)
			max_tab_text_width := Default_max_tab_text_width
			set_name (tab_content.display_name)
		end

feature -- Access

	name_shown (name: READABLE_STRING_GENERAL): READABLE_STRING_GENERAL
			--
		do
			if name.count > max_tab_text_width then
				Result := name.substring (1, max_tab_text_width) + ".. "
			else
				Result := name + " "
			end
		end

feature -- Element change

	set_name (name: like name_shown)
		do
			set_text (name_shown (name))
		end

feature -- Basic operations

	update
		do
			content_box.update
		end

feature {EL_FIXED_TAB_BOOK} -- Events

	on_deselected
		do
		end

	on_selected
		do
		end

feature {NONE} -- Internal attributes

	content_box: EL_MANAGED_WIDGET [EL_VERTICAL_BOX]

	max_tab_text_width: INTEGER

	book: EL_FIXED_TAB_BOOK [W]

feature {NONE} -- Constant

	Default_max_tab_text_width: INTEGER = 25

end
