note
	description: "Summary description for {EL_VERTICAL_TAB_BOX}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-12-07 17:37:45 GMT (Saturday 7th December 2013)"
	revision: "4"

deferred class
	EL_VERTICAL_TAB_BOX

inherit
	EV_VERTICAL_BOX

feature {NONE} -- Initialization

	make
		do
			default_create
			set_border_width (10)
			create tab_data.make_with_widget (Current, unique_title)
			if is_closeable then
				tab_data.close_request_actions.extend (agent close)
			end
			tab_data.show_actions.extend (agent on_show)
			tab_data.set_type ({SD_ENUMERATION}.editor)
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

feature {EL_DOCKED_TAB_BOOK} -- Access

	tab_data: SD_CONTENT

	tab_book: EL_DOCKED_TAB_BOOK

feature -- Status Query

	is_selected: BOOLEAN
		do
			Result := tab_book.is_tab_selected (Current)
		end

	is_closeable: BOOLEAN
		do
			Result := True
		end

feature {EL_DOCKED_TAB_BOOK} -- Element change

	set_tab_book (a_tab_book: like tab_book)
		do
			tab_book := a_tab_book
			update_properties
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			--
		do
			Result := unique_title < other.unique_title
		end

feature -- Basic operations

	close
		do
			if is_closeable then
				on_close
				tab_book.prune (Current)
				tab_data.close
			end
		end

	update_properties
		do
			tab_data.set_unique_title (unique_title)
			tab_data.set_short_title (title)
			tab_data.set_long_title (long_title)
			tab_data.set_description (description)
			tab_data.set_detail (detail)
			tab_data.set_pixmap (icon)
			tab_data.set_tab_tooltip (long_title)
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

feature {NONE} -- Implementation

	short_title (s: STRING): STRING_32
		do
			Result := s.substring (1, s.count.min (14)) + ".."
		end

feature {NONE} -- Constants

	Icon_height: INTEGER
		once
			Result := (tab_book.title_bar_height * 0.7).rounded
		end

end
