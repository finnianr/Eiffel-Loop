note
	description: "Notebook tab"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-12 12:51:30 GMT (Friday 12th July 2024)"
	revision: "10"

class
	EL_NOTEBOOK_TAB [W -> EV_WINDOW]

inherit
	EV_NOTEBOOK_TAB

	EL_REPLACEABLE_WIDGET_ITEM
		rename
			item as content_box,
			new_item as new_content_box,
			replace_item as update,
			Widget as Widget_
		export
			{ANY} update
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

feature {EL_FIXED_TAB_BOOK} -- Events

	on_deselected
		do
		end

	on_selected
		do
		end

feature {NONE} -- Implementation

	new_content_box: like tab_content.new_box
		do
			Result := tab_content.new_box
		end

feature {NONE} -- Internal attributes

	book: EL_FIXED_TAB_BOOK [W]

	max_tab_text_width: INTEGER

	tab_content: EL_TAB_CONTENT [W]

feature {NONE} -- Constant

	Default_max_tab_text_width: INTEGER = 25

end