note
	description: "Summary description for {EL_VERTICAL_TAB_BOX}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-12-07 17:37:45 GMT (Saturday 7th December 2013)"
	revision: "4"

deferred class
	EL_DOCKED_TAB

feature {NONE} -- Initialization

	make
		require else
			valid_unique_title: attached {like unique_title} unique_title and then not unique_title.is_empty
		do
			create content_border_box.make (Border_width_cms, 0.0)
			content_border_box.extend (create {EV_CELL})
			create properties.make_with_widget (content_border_box, unique_title)
			if is_closeable then
				properties.close_request_actions.extend (agent close)
			end
			properties.show_actions.extend (agent on_show)
			properties.set_type ({SD_ENUMERATION}.editor)
		end

feature -- Access

	unique_title: STRING_32
		deferred
		end

	title: STRING_32
		deferred
		end

	long_title: STRING_32
		deferred
		end

	description: STRING_32
		deferred
		end

	detail: STRING_32
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
			properties.set_unique_title (unique_title)
			properties.set_short_title (title)
			properties.set_long_title (long_title)
			properties.set_description (description)
			properties.set_detail (detail)
			properties.set_pixmap (icon)
			properties.set_tab_tooltip (long_title)
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			--
		do
			Result := unique_title < other.unique_title
		end

feature {EL_DOCKED_TAB_BOOK} -- Access

	properties: SD_CONTENT
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

feature {EL_DOCKED_TAB_BOOK} -- Event handler

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

feature {NONE} -- Factory

	new_content_widget: EV_WIDGET
		deferred
		end

feature {NONE} -- Implementation

	short_title (s: EL_ASTRING): STRING_32
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
