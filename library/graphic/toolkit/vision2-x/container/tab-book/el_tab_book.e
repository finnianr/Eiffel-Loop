note
	description: "[
		Extension to EV_NOTEBOOK
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "3"

class
	EL_TAB_BOOK [B -> {EL_BOX} create make end]

inherit
	EV_NOTEBOOK
		rename
			extend as extend_item,
			remove as remove_item,
			search as search_item
		export
			{NONE} remove_item, item
			{EL_TAB} first, extend_item
--			{EL_STOCK_COLORS_IMP} implementation
		redefine
			wipe_out, initialize
		end

	EL_TAB_SHORTCUTS
		undefine
			copy , default_create, is_equal
		end

	EL_MODULE_LOG
		undefine
			copy , default_create, is_equal
		end

create
	make, default_create

feature {NONE} -- Initialization

	initialize
		do
			Precursor
			create tabs.make (5)
		end

	make (a_window: EV_WINDOW; a_border_cms, a_padding_cms: REAL)
			--
		do
			border_cms := a_border_cms
			padding_cms := a_padding_cms
			default_create
			init_keyboard_shortcuts (a_window)
			set_background_color (GUI.color_3d_face)
			selection_actions.extend (agent
				do
					-- Postponing until Ctrl page up/down actions are handled
					GUI.do_once_on_idle (agent set_selected_index (selected_item_index))
				end
			)
		end

feature -- Access

	selected_tab: EL_TAB [B]
			--
		do
			Result := tabs.i_th (selected_item_index)
		end

	tabs: ARRAYED_LIST [like selected_tab]

	selected_index: INTEGER

	last_tab: like selected_tab
		do
			Result := tabs.last
		end

feature -- Measurement

	border_cms: REAL

	padding_cms: REAL

feature -- Element change

	set_selected_index (a_selected_index: INTEGER)
		require
			valid_index: valid_index (a_selected_index)
		do
			if a_selected_index /= selected_item_index then
				select_tab (tabs [a_selected_index])
			end
			if tabs.valid_index (selected_index) then
				tabs.i_th (selected_index).on_deselected
			end
			selected_index := a_selected_index
			selected_tab.on_selected
		end

	extend_new (a_text: READABLE_STRING_GENERAL)
		do
			tabs.extend (create {like selected_tab}.make (Current, a_text))
		end

feature -- Status setting

	select_tab (tab: like selected_tab)
			--
		do
			select_item (tab.widget)
		end

feature -- Basic operations

	select_left_tab
			-- select tab to left wrapping around to last if gone past the first tab
		do
			select_neighbouring_tab (-1)
		end

	select_right_tab
			-- select tab to right of current wrapping around to first if gone past the last tab
		do
			select_neighbouring_tab (1)
		end

	select_neighbouring_tab (index_delta: INTEGER)
			-- select tab to left or right,
			-- wrapping around if gone past the first or last tab
		do
			set_selected_index ((count + index_delta + selected_index - 1) \\ count + 1)
		end

feature -- Removal

	remove (tab: like selected_tab)
			--
		do
			start
			search_item (tab.widget)
			if not exhausted then
				tabs.go_i_th (index)
				tabs.remove
				remove_item
			end
		end

	wipe_out
		do
			Precursor
			tabs.wipe_out
			selected_index := 0
		end

end
