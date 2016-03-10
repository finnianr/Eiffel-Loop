note
	description: "Summary description for {EL_VERTICAL_TAB_BOX}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "6"

deferred class
	EL_DOCKED_TAB

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

	unique_title: ASTRING
		deferred
		end

	title: ASTRING
		deferred
		end

	long_title: ASTRING
		deferred
		end

	description: ASTRING
		deferred
		end

	detail: ASTRING
		deferred
		end

	icon: EV_PIXMAP
		deferred
		end

	content_widget: like new_content_widget

feature -- Status Query

	is_selected: BOOLEAN
		do
			Result := tab_book.is_tab_selected (Current)
		end

	is_closeable: BOOLEAN
		do
			Result := True
		end

feature -- Basic operations

	close
		do
			if is_closeable then
				on_close
				tab_book.prune (Current)
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

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			--
		do
			Result := unique_title < other.unique_title
		end

feature {EL_DOCKED_TAB_BOOK, SD_WIDGET_FACTORY} -- Access

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

	on_show
		do
			tab_book.select_tab (Current)
		end

	on_selected
		do
		end

	on_close
		do
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

	short_title (s: ASTRING): ASTRING
		do
			Result := s.substring (1, s.count.min (14)) + ".."
		end

	content_border_box: EL_HORIZONTAL_BOX

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
