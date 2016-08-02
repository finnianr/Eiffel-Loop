note
	description: "Summary description for {EL_DOCKED_TAB_BOOK}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-08-30 12:25:12 GMT (Sunday 30th August 2015)"
	revision: "1"

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

	EL_TAB_SHORTCUTS
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

	init_singletons
		local
			l_factory: SD_WIDGET_FACTORY
			l_names: SD_INTERFACE_NAMES
		do
			l_factory := Tab_book_common.widget_factory
			l_names := Tab_book_common.interface_names
		end

	make (a_main_window: like main_window)
		do
			main_window := a_main_window
			init_singletons
			default_create
			init_keyboard_shortcuts (a_main_window)
			create manager.make (Current, a_main_window)
			set_title_bar_height
		end

feature -- Access

	count: INTEGER
		do
			across manager.contents as content loop
				if attached {EL_DOCKING_CONTENT} content.item then
					Result := Result + 1
				end
			end
		end

	selected: EL_DOCKED_TAB
		require
			not_empty: not is_empty
		do
			Result := tabs.item
		end

	selected_zone_circular_tabs: ARRAYED_CIRCULAR [like selected]
		local
			zone_tabs: like selected_zone_tabs
			selected_index: INTEGER
		do
			zone_tabs := selected_zone_tabs
			create Result.make (zone_tabs.count)
			selected_index := zone_tabs.index
			Result.append (zone_tabs)
			Result.go_i_th (selected_index)
		end

	selected_zone_tabs: ARRAYED_LIST [like selected]
		local
			l_contents: ARRAYED_LIST [SD_CONTENT]
		do
			if attached {SD_MULTI_CONTENT_ZONE} selected_zone as multi then
				l_contents := multi.contents
			elseif attached {SD_SINGLE_CONTENT_ZONE} selected_zone as single then
				create l_contents.make_from_array (<< single.content >>)
			else
				create Result.make (0)
			end
			create Result.make (l_contents.count)
			across l_contents as content loop
				if attached {EL_DOCKING_CONTENT} content.item as docking_content then
					if attached {like selected} docking_content.tab as zone_tab then
						Result.extend (zone_tab)
						if zone_tab.is_selected then
							Result.finish
						end
					end
				end
			end
		end

	tabs: ARRAYED_LIST [like selected]
			-- all open tabs
		do
			create Result.make (count)
			across manager.contents as content loop
				if attached {EL_DOCKING_CONTENT} content.item as tab_properties
					and then attached {like selected} tab_properties.tab as tab
				then
					Result.extend (tab)
					if tab.is_selected then
						Result.finish
					end
				end
			end
		end

	title_bar_height: INTEGER

feature {EL_DOCKED_TAB} -- Access

	selected_zone: SD_ZONE
		do
			Result := manager.zones.zone_by_content (manager.focused_content)
		end

	right_place_holder: EV_CELL
			--
		do
			Result := manager.zones.place_holder_widget
		end

feature -- Element change

	add_toolbar (a_toolbar: SD_TOOL_BAR_CONTENT)
		do
			manager.tool_bar_manager.contents.extend (a_toolbar)
			a_toolbar.set_top ({SD_ENUMERATION}.top)
		end

	extend (a_tab: like selected)
		local
			l_tabs: like tabs
		do
			a_tab.set_tab_book (Current)
			manager.contents.extend (a_tab.properties)
			if count = 1 then
				set_delivery_zone
			else
				l_tabs := tabs
				a_tab.properties.set_tab_with (l_tabs.i_th (l_tabs.count - 1).properties, False)
			end
			a_tab.properties.set_focus
		end

	select_left_tab
			-- select tab to left wrapping around to last if gone past the first tab
		do
			select_adjacent (-1)
		end

	select_right_tab
			-- select tab to right of current wrapping around to first if gone past the last tab
		do
			select_adjacent (1)
		end

	select_adjacent (direction: INTEGER)
		local
			zone_tabs: like selected_zone_circular_tabs
		do
			zone_tabs := selected_zone_circular_tabs
			if zone_tabs.count > 1 then
				if direction < 0 then
					zone_tabs.back
				else
					zone_tabs.forth
				end
				zone_tabs.item.set_selected
			end
		end

feature -- Status query

	has (a_tab: like selected): BOOLEAN
		do
			Result := manager.contents.has (a_tab.properties)
		end

	is_empty: BOOLEAN
		do
			Result := count = 0
		end

feature -- Basic operations

	close_all
		do
			across tabs as tab loop
				if tab.item.is_closeable then
					tab.item.close
				end
			end
		end

	close_all_except (a_tab: like selected)
		require
			has_tab: has (a_tab)
		do
			across tabs as tab loop
				if tab.item /= a_tab then
					tab.item.close
				end
			end
		ensure
			has_tab: has (a_tab)
		end

feature {NONE} -- Implementation

	inner_container_main: SD_MULTI_DOCK_AREA
		do
			Result := manager.query.inner_container_main
		end

	main_window: EV_WINDOW

	manager: SD_DOCKING_MANAGER

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

feature {EL_DOCKED_TAB} -- Constants

	Default_split_proportion: REAL
		do
			Result := 0.5
		end

	Tab_book_common: SD_SHARED
		once
			create Result
		end

end