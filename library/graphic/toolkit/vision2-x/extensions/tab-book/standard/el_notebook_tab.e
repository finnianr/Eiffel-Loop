note
	description: "Notebook tab"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-10 13:21:06 GMT (Sunday 10th November 2024)"
	revision: "11"

class
	EL_NOTEBOOK_TAB [W -> EV_WINDOW]

inherit
	EV_NOTEBOOK_TAB

	EL_WIDGET_REPLACEMENT [EL_VERTICAL_BOX]
		rename
			Widget as Widget_
		end

create
	make

feature {NONE} -- Initialization

	make (a_tab_book: like book; a_tab_content: like tab_content)
		local
			cell: EV_CELL
		do
			book := a_tab_book; tab_content := a_tab_content
			create cell
			content_box := new_content_box
			cell.put (content_box)
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
			set_text (name_shown (name).to_string_32)
		end

feature -- Basic operations

	update
		do
			content_box := replaced (content_box, new_content_box)
		end

feature {EL_FIXED_TAB_BOOK} -- Events

	on_deselected
		do
		end

	on_selected
		do
		end

feature {NONE} -- Implementation

	new_content_box: EL_VERTICAL_BOX
		do
			Result := tab_content.new_box
		end

feature {NONE} -- Internal attributes

	book: EL_FIXED_TAB_BOOK [W]

	content_box: like new_content_box

	max_tab_text_width: INTEGER

	tab_content: EL_TAB_CONTENT [W]

feature {NONE} -- Constant

	Default_max_tab_text_width: INTEGER = 25

end