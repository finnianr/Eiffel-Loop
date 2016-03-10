note
	description: "Summary description for {MAIN_NOTEBOOK}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-05-30 17:21:50 GMT (Thursday 30th May 2013)"
	revision: "3"

class
	TEST_TAB_BOOK

inherit
	EL_SPLIT_AREA_DOCKED_TAB_BOOK
		rename
			right_place_holder as artwork_place_holder
		redefine
			make, main_window, Default_split_proportion, set_delivery_zone
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

	make (a_main_window: like main_window)
	 	do
	 		Precursor (a_main_window)
	 		manager.main_container.resize_actions.extend (agent on_main_container_resize)
			main_window.maximize_actions.extend (
				agent
					do
						normal_main_container_width := manager.main_container.width
						normal_main_container_height := manager.main_container.height
					end
			)
	 	end

feature -- Status query

	is_maximized: BOOLEAN

feature -- Element change

	replace_artwork
		do
			artwork_place_holder.replace (new_artwork_box)
			artwork_place_holder.set_background_color (artwork_place_holder.item.background_color)
		end

feature -- Basic operations

	close_selected_tab
		do
			if selected_tab.is_closeable then
				selected_tab.close
			end
		end

feature {NONE} -- Event handling

	on_main_container_resize (a_x, a_y, a_width, a_height: INTEGER)
			-- In Windows this is called 2 times during a maximize.
			-- The first time the a_height is still at the old value hence the expression
			-- "normal_main_container_height /= a_height" is need to detect the second time.
			-- In GTK it is only called once.
		do
			if main_window.is_maximized /= is_maximized then
				if main_window.is_maximized and normal_main_container_height /= a_height then
					enable_maximized
				else
					disable_maximized
				end
			end
		end

feature {NONE} -- Implementation

	set_delivery_zone
		do
			Precursor
			split_area.second.hide
		end

	enable_maximized
		do
			split_area.second.show
			set_split_position_on_idle (Half_screen_width)

			is_maximized := True
			replace_artwork
		end

	disable_maximized
		do
			split_area.second.hide
			is_maximized := False
			replace_artwork
		end

	new_artwork_box: EV_HORIZONTAL_BOX
		local
			label: EV_LABEL; artwork_pixmap: EV_PIXMAP
			v_box: EV_VERTICAL_BOX
		do
			if is_maximized then
				create v_box
				create artwork_pixmap
				artwork_pixmap.set_with_named_path (Lenna_png_path)
				artwork_pixmap.stretch (
					(artwork_pixmap.width * artwork_height / artwork_pixmap.height).rounded,
					artwork_height
				)

				create label.make_with_text ("PORTRAIT OF LENNA")
--				label.font.set_height (artwork_vertical_border // 2)
				label.set_foreground_color (Colors.White)
				v_box.extend (label)
				v_box.extend (artwork_pixmap)
				artwork_pixmap.set_minimum_size (artwork_pixmap.width, artwork_pixmap.height)
				v_box.disable_item_expand (artwork_pixmap)
				v_box.extend (create {EV_CELL})

				Result := new_centered_horizontal_box (v_box)
				Result.set_background_color (Colors.Black)
				Result.propagate_background_color

			else
				create Result
			end
		end

	artwork_height: INTEGER
		do
			Result := manager.main_container.height - Artwork_vertical_border * 2
		end

	main_window: TITLED_TAB_BOOK_WINDOW

	normal_main_container_width: INTEGER
		-- Unmaximized width

	normal_main_container_height: INTEGER
		-- Unmaximized width

feature {NONE} -- Constants

	Default_split_proportion: REAL
		do
			Result := 1.0
		end

	Artwork_vertical_border: INTEGER
		do
			Result := (Screen.height * 0.2).rounded
		end

	Lenna_png_path: PATH
		local
			env: EXECUTION_ENVIRONMENT
		once
			create env
			create Result.make_from_string (env.item ("ISE_LIBRARY") + "/library/vision2/tests/graphics/Lenna.png")
		end

end
