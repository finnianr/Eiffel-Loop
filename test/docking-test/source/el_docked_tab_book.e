note
	description: "Summary description for {EL_DOCKED_TAB_BOOK}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-12-07 17:37:45 GMT (Saturday 7th December 2013)"
	revision: "3"

class
	EL_DOCKED_TAB_BOOK

inherit
	EV_VERTICAL_BOX
		rename
			extend as box_extend,
			prune as box_prune,
			valid_index as valid_box_index,
			is_empty as is_box_empty,
			has as has_widget,
			count as widget_count
		export
			{NONE} all
		end

	EL_TAB_BOOK_BASE
		undefine
			default_create, copy, is_equal
		end

	SD_ACCESS
		undefine
			default_create, copy, is_equal
		end

create
	make

feature -- Initialization

	make (a_main_window: like main_window)
		do
			main_window := a_main_window
			init_singletons
			default_create
			init_keyboard_shortcuts (a_main_window)
			create tabs.make (10)
			create manager.make (Current, a_main_window)
			set_title_bar_height
		end

	init_singletons
		local
			l_factory: SD_WIDGET_FACTORY
			l_names: SD_INTERFACE_NAMES
		do
			l_factory := Tab_book_common.widget_factory
			l_names := Tab_book_common.interface_names
		end

feature -- Access

	selected_tab: EL_VERTICAL_TAB_BOX
		require
			not_empty: not is_empty
		do
			Result := tabs.item
		end

	selected_index: INTEGER
		do
			Result := tabs.index
		end

	count: INTEGER
		do
			Result := tabs.count
		end

	title_bar_height: INTEGER

feature {EL_VERTICAL_TAB_BOX} -- Access

	docking_zone: SD_ZONE
		do
			Result := manager.zones.zone_by_content (selected_tab.tab_data)
		end

	right_place_holder: EV_CELL
			--
		do
			Result := manager.zones.place_holder_widget
		end

feature -- Element change

	set_selected (a_tab: like selected_tab)
		require
			has_tab: has (a_tab)
		do
			select_tab (a_tab)
			selected_tab.tab_data.set_focus
		end

	set_selected_index (a_selected_index: INTEGER)
		do
			tabs.go_i_th (a_selected_index)
			selected_tab.tab_data.set_focus
		end

	add_toolbar (a_toolbar: SD_TOOL_BAR_CONTENT)
		do
			manager.tool_bar_manager.contents.extend (a_toolbar)
			a_toolbar.set_top ({SD_ENUMERATION}.top)
		end

	extend (a_tab: like selected_tab)
		do
			a_tab.set_tab_book (Current)
			tabs.extend (a_tab)
			if tabs.count = 1 then
				tabs.go_i_th (1)
			end
			manager.contents.extend (a_tab.tab_data)
			if tabs.count = 1 then
				set_delivery_zone
			else
				a_tab.tab_data.set_tab_with (tabs.i_th (tabs.count - 1).tab_data, False)
			end
		end

	prune (a_tab: like selected_tab)
		require
			has_tab: has (a_tab)
		local
			l_selected: like selected_tab
		do
			set_previous_index
			l_selected := selected_tab
			if l_selected = a_tab then
				tabs.remove
				if tabs.after then
					tabs.back
				end
			else
				tabs.start; tabs.prune (a_tab)
				tabs.start; tabs.search (l_selected)
			end
			notify_selection_change
		ensure
			still_selected: a_tab /= old selected_tab implies selected_tab = old selected_tab
		end

feature {EL_VERTICAL_TAB_BOX} -- Element change

	select_tab (a_tab: like selected_tab)
		do
			set_previous_index
			tabs.start; tabs.search (a_tab)
			notify_selection_change
		end

feature -- Status query

	is_empty: BOOLEAN
		do
			Result := tabs.is_empty
		end

	is_tab_selected (a_tab: like selected_tab): BOOLEAN
		do
			if tabs.has (a_tab) then
				Result := tabs.item = a_tab
			end
		end

	has (a_tab: like selected_tab): BOOLEAN
		do
			Result := tabs.has (a_tab)
		end

feature -- Basic operations

	close_all
		do
			across tabs.twin as tab loop
				tab.item.close
			end
		end

	close_all_except (a_tab: like selected_tab)
		require
			has_tab: has (a_tab)
		do
			across tabs.twin as tab loop
				if tab.item /= a_tab then
					tab.item.close
				end
			end
		ensure
			has_tab: has (a_tab)
		end

feature -- Contract Support

	valid_index (a_index: INTEGER): BOOLEAN
		do
			Result := tabs.valid_index (a_index)
		end

feature {NONE} -- Implementation

	set_previous_index
		do
			previous_index := selected_index
		end

	set_delivery_zone
			-- set zone to receive new tab components
		do
			manager.contents.last.set_default_editor_position
		end

	set_title_bar_height
		local
			content: SD_CONTENT
		do
			create content.make_with_widget (create {EV_CELL}, "None")
			manager.contents.extend (content)
			content.set_type ({SD_ENUMERATION}.editor)
			content.set_default_editor_position

			if attached {SD_DOCKING_ZONE_UPPER} manager.zones.zone_by_content (content) as zone then
				title_bar_height := zone.title_area.height
			end
			content.close
		end

	notify_selection_change
		do
			if previous_index /= selected_index then
				selected_tab.on_selected
			end
		end

	inner_container_main: SD_MULTI_DOCK_AREA
		do
			Result := manager.query.inner_container_main
		end

	tabs: ARRAYED_LIST [like selected_tab]

	manager: SD_DOCKING_MANAGER

	main_window: EV_WINDOW

	previous_index: INTEGER

feature {EL_VERTICAL_TAB_BOX} -- Constants

	Tab_book_common: SD_SHARED
		once
			create Result
		end

	Default_split_proportion: REAL
		do
			Result := 0.5
		end
end
