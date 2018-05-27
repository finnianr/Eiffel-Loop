note
	description: "Fixed tab book"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "5"

deferred class
	EL_FIXED_TAB_BOOK [W -> {EV_WINDOW}]

inherit
	EV_NOTEBOOK
		rename
			extend as extend_item,
			remove as remove_item,
			search as search_item
		export
			{NONE} remove_item, item
			{EL_NOTEBOOK_TAB} first, extend_item
		redefine
			initialize
		end

	EL_TAB_SHORTCUTS
		undefine
			copy , default_create, is_equal
		end

	EL_MODULE_LOG
		undefine
			copy , default_create, is_equal
		end

	EL_MODULE_EIFFEL
		undefine
			copy , default_create, is_equal
		end

feature {NONE} -- Initialization

	initialize
		do
			Precursor
			content_list := new_content_list
			create tabs.make (content_list.count)
		end

	make (a_window: like window)
			--
		do
			window := a_window
			default_create
			init_keyboard_shortcuts (a_window)
			set_background_color (GUI.color_3d_face)
			selection_actions.extend (agent
				do
					-- Postponing until Ctrl page up/down actions are handled
					GUI.do_once_on_idle (agent set_selected_index (selected_item_index))
				end
			)
			across content_list as content loop
				tabs.extend (create {like selected_tab}.make (Current, content.item))
			end
		end

feature -- Access

	content_list: like new_content_list

	content_of_type (type: like content_types.item): like content_list.item
		local
			i: INTEGER
		do
			from i := 1 until attached Result or i > content_types.count loop
				if type ~ content_types [i] then
					Result := content_list [i]
				else
					i := i + 1
				end
			end
		ensure
			not_void: attached Result
		end

	last_tab: like selected_tab
		do
			Result := tabs.last
		end

	selected_index: INTEGER

	selected_tab: EL_NOTEBOOK_TAB [W]
			--
		do
			Result := tabs.i_th (selected_item_index)
		end

	tabs: ARRAYED_LIST [like selected_tab]

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

	select_neighbouring_tab (index_delta: INTEGER)
			-- select tab to left or right,
			-- wrapping around if gone past the first or last tab
		do
			set_selected_index ((count + index_delta + selected_index - 1) \\ count + 1)
		end

	select_right_tab
			-- select tab to right of current wrapping around to first if gone past the last tab
		do
			select_neighbouring_tab (1)
		end

feature {NONE} -- Implementation

	content_types: ARRAY [TYPE [EL_TAB_CONTENT [W]]]
			-- define as once object
		deferred
		ensure
			Result.object_comparison
		end

	new_content_list: ARRAYED_LIST [EL_TAB_CONTENT [W]]
		do
			create Result.make (content_types.count)
			across content_types as type loop
				if attached {like new_content_list.item} Eiffel.new_instance_of (type.item.type_id) as content then
					content.make (Current)
					Result.extend (content)
				end
			end
		end

feature {EL_TAB_CONTENT} -- Internal attributes

	window: W

end
