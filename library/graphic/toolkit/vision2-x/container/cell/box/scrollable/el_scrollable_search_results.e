note
	description: "[
		List of scrollable search result hyperlinks for data list conforming to `DYNAMIC_CHAIN [G]'.
		The results are displayed in pages with `links_per_page' defining the number of result hyperlinks per page.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-24 11:40:33 GMT (Wednesday 24th February 2021)"
	revision: "13"

class
	EL_SCROLLABLE_SEARCH_RESULTS [G -> EL_HYPERLINKABLE]

inherit
	EL_SCROLLABLE_VERTICAL_BOX
		rename
			make as make_scrollable,
			is_empty as is_box_empty
		redefine
			on_key_end, on_key_home
		end

	PART_COMPARATOR [G]
		export
			{NONE} all
		undefine
			is_equal, copy, default_create
		end

	EL_MODULE_DEFERRED_LOCALE

	EL_MODULE_COLOR

	EL_MODULE_GUI

	EL_MODULE_LOG

	EL_MODULE_PIXMAP

	EL_MODULE_SCREEN

create
	make, default_create

feature {NONE} -- Initialization

	make (a_result_selected_action: like result_selected_action; a_links_per_page: INTEGER; a_font_table: EL_FONT_SET)
			--
		do
			make_scrollable (Default_border_cms, Default_border_cms)
			font_table := a_font_table

			result_selected_action := a_result_selected_action
			links_per_page := a_links_per_page
			link_text_color := Color.Blue

			comparator := Default_comparator
			disabled_page_link := Default_disabled_page_link

		end

feature -- Access

	default_comparator: like comparator
		do
			Result := Current
		end

	font_table: EL_FONT_SET

	link_text_color: EV_COLOR

	page: INTEGER
		-- current page of results

feature -- Measurement

	links_per_page: INTEGER

feature -- Element change

	set_comparator (a_comparator: like comparator)
			-- set sort order
		do
			comparator := a_comparator
		end


	set_font_table (a_font_table: EL_FONT_SET)
		do
			font_table := a_font_table
		end

	set_link_text_color (a_link_text_color: like link_text_color)
			--
		do
			link_text_color := a_link_text_color
		end

	set_links_per_page (a_links_per_page: INTEGER)
			--
		do
			links_per_page := a_links_per_page
		end

	set_result_set (a_result_set: like result_set)
			--
		local
			quick: QUICK_SORTER [G]
		do
			if comparator = default_comparator then
				if reverse_sorting_enabled then
					create {ARRAYED_LIST [G]} result_set.make (a_result_set.count)
					from a_result_set.finish until a_result_set.before loop
						result_set.extend (a_result_set.item)
						a_result_set.back
					end
				else
					result_set := a_result_set
				end
			else
				create {ARRAYED_LIST [G]} result_set.make (a_result_set.count)
				result_set.append (a_result_set)
				create quick.make (comparator)
				if reverse_sorting_enabled then
					quick.reverse_sort (result_set)
				else
					quick.sort (result_set)
				end
			end
			page_count := (result_set.count / links_per_page).ceiling
			page := 0
			goto_page (1)
		end

feature -- Basic operations

	goto_page (a_page: INTEGER)
			--
		local
			page_results: like new_page_results
		do
			page := a_page
			disable_automatic_scrollbar
			wipe_out
			page_results := new_page_results
			across page_results as result_link loop
				extend_unexpanded (result_link.item)
			end
			if has_page_links then
				extend_unexpanded (new_navigation_links_box (page_results.count))
			end
			update_scroll_bar
			scroll_bar.set_value (0)
			enable_automatic_scrollbar
			set_focus
		end

	position_pointer_near_disabled_link
		do
			Screen.set_pointer_position (
				disabled_page_link.screen_x + disabled_page_link.width, disabled_page_link.screen_y + disabled_page_link.height // 2
			)
		end

	position_pointer_on_first_line
		do
			Screen.set_pointer_position (
				screen_x + Screen.horizontal_pixels (3), screen_y + Screen.vertical_pixels (1)
			)
		end

feature -- Status query

	has_page_links: BOOLEAN
		do
			Result := result_set.count > links_per_page
		end

	is_empty: BOOLEAN
		do
			Result := result_set.is_empty
		end

	reverse_sorting_enabled: BOOLEAN

feature -- Status setting

	disable_reverse_sort
		do
			reverse_sorting_enabled := False
		end

	enable_reverse_sort
		do
			reverse_sorting_enabled := True
		end

	set_busy_pointer
		do
			set_pointer_style (Pixmap.Busy_cursor)
			position_pointer_on_first_line
		end

	set_standard_pointer
		do
			set_pointer_style (Pixmap.Standard_cursor)
		end

feature {NONE} -- Event handling

	on_key_end
		do
			Precursor
			if disabled_page_link /= Default_disabled_page_link then
				GUI.do_once_on_idle (agent position_pointer_near_disabled_link)
			end
		end

	on_key_home
		do
			Precursor
			GUI.do_once_on_idle (agent position_pointer_on_first_line)
		end

feature {NONE} -- Factory

	new_navigation_links_box (current_page_link_count: INTEGER): EL_HORIZONTAL_BOX
			--
		local
			l_lower, upper, i: INTEGER
			previous_page_link, next_page_link, page_link: EL_HYPERLINK_AREA
		do
			create Result.make (0, 0.3)
			Result.set_background_color (background_color)
			l_lower := ((page - 1) // 10) * 10 + 1
			upper := (l_lower + 9).min (page_count)

			if page > 1 then
				create previous_page_link.make_with_styles (
					styled (Link_text_previous), font_table, agent goto_previous_page, background_color
				)
				previous_page_link.set_link_text_color (link_text_color)
				Result.extend_unexpanded (previous_page_link)
			end

			if result_set.count > links_per_page then
				from i := l_lower until i > upper loop
					create page_link.make_with_styles (styled (i.out), font_table, agent goto_page (i), background_color)
					page_link.set_link_text_color (link_text_color)
					Result.extend_unexpanded (page_link)
					if i = page then
						page_link.disable
						disabled_page_link := page_link
					end
					i := i + 1
				end
			else
				disabled_page_link := Default_disabled_page_link
			end

			if page < page_count then
				create next_page_link.make_with_styles (
					styled (Link_text_next), font_table, agent goto_next_page, background_color
				)
				next_page_link.set_link_text_color (link_text_color)
				Result.extend_unexpanded (next_page_link)
			end
		end

	new_page_results: ARRAYED_LIST [EL_BOX]
		local
			i, l_lower, l_upper: INTEGER
		do
			l_lower := (page - 1) * links_per_page + 1
			l_upper := result_set.count.min (l_lower + links_per_page - 1)
			create Result.make (l_upper - l_lower + 1)
			from i := l_lower until i > l_upper loop
				Result.extend (new_result_link_box (result_set.i_th (i), i))
				i := i + 1
			end
		end

	new_result_link_box (result_item: G; i: INTEGER): EL_BOX
		do
			create {EL_VERTICAL_BOX} Result
			Result.set_background_color (background_color)
			add_navigable_heading (Result, result_item, i)
			add_supplementary (Result, result_item, i)
		end

feature {NONE} -- Implementation

	add_navigable_heading (result_link_box: EL_BOX; result_item: G; i: INTEGER)
		-- add hyperlink for `i' th `result_item' to `result_link_box'
		local
			result_link: EL_HYPERLINK_AREA
		do
			create result_link.make_with_styles (
				result_item.text, font_table, agent call_selected_action (result_set, i, result_item), background_color
			)
			result_link.set_link_text_color (link_text_color)
			result_link_box.extend_unexpanded (result_link)
		end

	add_supplementary (result_link_box: EL_BOX; result_item: G; i: INTEGER)
		-- add supplementary information for `i' th `result_item' to `result_link_box'
		do
		end

	less_than (u, v: G): BOOLEAN
			-- do nothing comparator
		do
		end

	styled (a_text: READABLE_STRING_GENERAL): EL_STYLED_TEXT_LIST [READABLE_STRING_GENERAL]
		do
			create Result.make_regular (a_text)
		end

feature {NONE} -- Hyperlink actions

	call_selected_action (a_result_set: DYNAMIC_CHAIN [G]; a_index: INTEGER; result_item: G)
			--
		do
			result_selected_action.call ([a_result_set, a_index, result_item])
		end

	goto_next_page
			--
		do
			goto_page (page + 1)
		end

	goto_previous_page
			--
		do
			goto_page (page - 1)
		end

feature {NONE} -- Implementation: attributes

	comparator: PART_COMPARATOR [G]

	disabled_page_link: EL_HYPERLINK_AREA

	page_count: INTEGER

	result_selected_action: PROCEDURE [CHAIN [G], INTEGER, G]

	result_set: DYNAMIC_CHAIN [G]

feature {NONE} -- Constants

	Default_border_cms: REAL
			--
		once
			Result := 0.5
		end

	Default_disabled_page_link: EL_HYPERLINK_AREA
		once
			create Result.make_default
		end

	Default_padding_cms: REAL
			--
		once
			Result := 0.5
		end

	Details_indent: INTEGER
		-- left margin for details
		once
		end

	Link_text_next: ZSTRING
		once
			Result := Locale * "Next"
		end

	Link_text_previous: ZSTRING
		once
			Result := Locale * "Previous"
		end

end
