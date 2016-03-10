note
	description: "Summary description for {HOME_TAB_BOX}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HOME_TAB_BOX

inherit
	EL_VERTICAL_TAB_BOX
		rename
			make as make_tab
		redefine
			tab_book, on_selected
		end

	SHARED_CONSTANTS
		undefine
			default_create, is_equal, copy
		end


	GUI_ROUTINES
		undefine
			default_create, is_equal, copy
		end

create
	make

feature {NONE} -- Initialization

	make (main_window: TITLED_TAB_BOOK_WINDOW)
		local
			center_button: EV_BUTTON
			h_box: EV_HORIZONTAL_BOX
		do
			make_tab
			create center_button.make_with_text_and_action (
				"Open a text tab", agent main_window.open_new_tab
			)

			create h_box
			h_box.set_border_width (10)

			h_box.extend (center_button)
			h_box.disable_item_expand (h_box.last)
--			h_box.extend (create {EV_CELL})

			extend (h_box)
			disable_item_expand (last)
		end

feature -- Access

	unique_title: STRING_32
		do
			Result := "Home"
		end

	title: STRING_32
		do
			Result := unique_title
		end

	long_title: STRING_32
		do
			Result := "Home tab"
		end

	description: STRING_32
		do
			Result := "A tab that is smaller than text tabs"
		end

	detail: STRING_32
		do
			Result := long_title
		end

	icon: EV_PIXMAP
		local
			l_height: INTEGER
		do
			create Result
			l_height := Result.font.line_height
			Result.set_size (Result.font.string_width ("H"), l_height)
			Result.draw_text_top_left (0, 0, "H")
		end

feature {TEST_TAB_BOOK} -- Event handler

	on_selected
		do
		end

feature {EL_DOCKED_TAB_BOOK} -- Access

	tab_item: EV_VERTICAL_BOX

feature {NONE} -- Implementation

	tab_book: TEST_TAB_BOOK

	Default_icon: EV_PIXMAP
		once
			create Result
		end

end
