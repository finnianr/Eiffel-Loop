note
	description: "Docked tab"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "4"

deferred class
	EL_DOCKED_TAB

inherit
	EL_MODULE_GUI

feature {NONE} -- Initialization

	make
		require else
			valid_unique_title: attached {like unique_title} unique_title and then not unique_title.is_empty
		do
			create content_border_box.make (Border_width_cms, 0.0)
			content_border_box.extend (create {EV_CELL})

			create properties.make_with_tab (Current)
			properties.set_type ({SD_ENUMERATION}.editor)
		end

feature -- Access

	content_widget: like new_content_widget

	description: ZSTRING
		deferred
		end

	detail: ZSTRING
		deferred
		end

	icon: EV_PIXMAP
		deferred
		end

	long_title: ZSTRING
		deferred
		end

	title: ZSTRING
		deferred
		end

	unique_title: ZSTRING
		deferred
		end

feature -- Status Query

	is_closeable: BOOLEAN
		do
			Result := True
		end

	is_selected: BOOLEAN
		do
			Result := properties.has_focus
		end

	is_current_tab_set: BOOLEAN
		do
			Result := tab_book.tabs.item = Current
		end

feature -- Basic operations

	close
		do
			if is_closeable then
				on_close
				properties.close
			end
		end

	update_properties
		do
			properties.set_unique_title (unique_title.to_unicode)
			properties.set_short_title (title.to_unicode)
			properties.set_long_title (long_title.to_unicode)
			properties.set_description (description.to_unicode)
			properties.set_detail (detail.to_unicode)
			properties.set_pixmap (icon)
			properties.set_tab_tooltip (long_title.to_unicode)
		end

feature -- Status change

	set_selected
		do
			properties.set_focus
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			--
		do
			Result := unique_title < other.unique_title
		end

feature {EL_DOCKED_TAB_BOOK, SD_WIDGET_FACTORY, SD_TAB_ZONE} -- Access

	properties: EL_DOCKING_CONTENT
		-- tab properties

	tab_book: EL_DOCKED_TAB_BOOK

feature {EL_DOCKED_TAB_BOOK} -- Element change

	replace_content_widget
		do
			content_widget := new_content_widget
			content_border_box.start; content_border_box.replace (content_widget)
		end

	set_tab_book (a_tab_book: like tab_book)
		do
			tab_book := a_tab_book
			update_properties
		end

feature {EL_DOCKED_TAB_BOOK, EL_DOCKING_CONTENT} -- Event handler

	on_close
		do
		end

	on_selected
		require
			current_tab_set: is_current_tab_set
		do
		end

	on_focus_in
		do
			GUI.do_once_on_idle (agent on_selected)
		end

feature {SD_WIDGET_FACTORY} -- Factory

	new_content_widget: EV_WIDGET
		deferred
		end

	new_menu: EV_MENU
			-- right click menu on tab area
		do
			create Result
		end

feature {EL_DOCKING_CONTENT} -- Implementation

	content_border_box: EL_HORIZONTAL_BOX

	short_title (s: ZSTRING): ZSTRING
		do
			Result := s.substring (1, s.count.min (14)) + ".."
		end

feature {NONE} -- Constants

	Border_width_cms: REAL
		once
			Result := 0.0
		end

	Icon_height: INTEGER
		once
			Result := (tab_book.title_bar_height * 0.7).rounded
		end

end