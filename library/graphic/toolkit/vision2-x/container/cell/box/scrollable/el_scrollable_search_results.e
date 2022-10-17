note
	description: "[
		List of scrollable search result hyperlinks for data list conforming to [$source DYNAMIC_CHAIN [G]]
	]"
	descendants: "[
			EL_SCROLLABLE_SEARCH_RESULTS
				[$source EL_SCROLLABLE_WORD_SEARCHABLE_RESULTS]
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-17 18:58:20 GMT (Monday 17th October 2022)"
	revision: "25"

class
	EL_SCROLLABLE_SEARCH_RESULTS [G]

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

	EL_MODULE_DEFERRED_LOCALE; EL_MODULE_ACTION; EL_MODULE_LOG; EL_MODULE_SCREEN

	EL_SHARED_DEFAULT_PIXMAPS; EL_SHARED_WORD

create
	make, default_create

feature {NONE} -- Initialization

	make (a_select_result: like select_result; a_style: like style)
		-- make with style and action `a_select_result' when user clicks on hyperlink
		do
			make_scrollable (a_style.border_cms, a_style.border_cms)
			style := a_style
			if attached style.background_color as color then
				set_background_color (color)
			end
			make_default
			select_result := a_select_result
		end

	make_default
		do
			comparator := Default_comparator
			disabled_page_link := Default_disabled_page_link
			create {LINKED_LIST [G]} result_set.make
		end

feature -- Access

	default_comparator: like comparator
		do
			Result := Current
		end

	page: INTEGER
		-- current page of results

	style: EL_SEARCH_RESULTS_STYLE

feature -- Element change

	set_comparator (a_comparator: like comparator)
			-- set sort order
		do
			comparator := a_comparator
		end

	set_result_set (a_result_set: like result_set)
			--
		local
			quick: QUICK_SORTER [G]
		do
			if comparator.same_type (default_comparator) then
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
			page_count := (result_set.count / style.links_per_page).ceiling
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
				disabled_page_link.screen_x + disabled_page_link.width,
				disabled_page_link.screen_y + disabled_page_link.height // 2
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
			Result := result_set.count > style.links_per_page
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
			set_pointer_style (Pixmaps.Busy_cursor)
			position_pointer_on_first_line
		end

	set_standard_pointer
		do
			set_pointer_style (Pixmaps.Standard_cursor)
		end

feature {NONE} -- Event handling

	on_key_end
		do
			Precursor
			if disabled_page_link /= Default_disabled_page_link then
				Action.do_once_on_idle (agent position_pointer_near_disabled_link)
			end
		end

	on_key_home
		do
			Precursor
			Action.do_once_on_idle (agent position_pointer_on_first_line)
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
					new_styled (Word.previous), style.font_table, agent goto_previous_page, background_color
				)
				previous_page_link.set_link_text_color (style.link_text_color)
				Result.extend_unexpanded (previous_page_link)
			end

			if result_set.count > style.links_per_page then
				from i := l_lower until i > upper loop
					create page_link.make_with_styles (new_styled (i.out), style.font_table, agent goto_page (i), background_color)
					page_link.set_link_text_color (style.link_text_color)
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
					new_styled (Word.next), style.font_table, agent goto_next_page, background_color
				)
				next_page_link.set_link_text_color (style.link_text_color)
				Result.extend_unexpanded (next_page_link)
			end
		end

	new_detail_lines (result_item: G): ARRAYED_LIST [EL_STYLED_TEXT_LIST [STRING_GENERAL]]
		local
			date_line: EL_STYLED_ZSTRING_LIST
		do
			create Result.make (1)
			if attached {EL_DATEABLE} result_item as l_item and then style.is_date_shown then
				create date_line.make (1)
				date_line.extend ({EL_TEXT_STYLE}.Regular, new_formatted_date (l_item.date))
				Result.extend (date_line)
			end
		end

	new_formatted_date (date: DATE): STRING
		do
			Result := Locale.date_text.formatted (date, style.date_format)
		end

	new_page_results: ARRAYED_LIST [EL_BOX]
		local
			i, l_lower, l_upper: INTEGER
		do
			l_lower := (page - 1) * style.links_per_page + 1
			l_upper := result_set.count.min (l_lower + style.links_per_page - 1)
			create Result.make (l_upper - l_lower + 1)
			from i := l_lower until i > l_upper loop
				Result.extend (new_result_link_box (i))
				i := i + 1
			end
		end

	new_result_link_box (i: INTEGER): EL_BOX
		do
			create {EL_VERTICAL_BOX} Result
			Result.set_background_color (background_color)
			add_navigable_heading (Result, i)
			add_details (Result, i)
			add_supplementary (Result, i)
		end

	new_styled (a_text: READABLE_STRING_GENERAL): EL_STYLED_ZSTRING_LIST
		do
			create Result.make_regular (a_text)
		end

	new_styled_description (result_item: G): EL_STYLED_TEXT_LIST [STRING_GENERAL]
		-- hyperlink description of result item
		do
			if attached {EL_DESCRIBEABLE} result_item as l_item then
				Result := l_item.text

			elseif attached {EL_STYLED_TEXT_LIST [STRING_GENERAL]} result_item as styled then
				Result := styled

			elseif attached {EL_NAMEABLE [READABLE_STRING_GENERAL]} result_item as l_item then
				create {EL_STYLED_ZSTRING_LIST} Result.make_regular (l_item.name)

			elseif attached {READABLE_STRING_GENERAL} result_item as string then
				Result := new_styled (string)

			elseif attached {DEBUG_OUTPUT} result_item as l_item then
				create {EL_STYLED_STRING_32_LIST} Result.make_regular (l_item.debug_output)

			else
				create {EL_STYLED_STRING_8_LIST} Result.make_regular (result_item.out)
			end
		end

feature {NONE} -- Implementation

	add_details (result_link_box: EL_BOX; i: INTEGER)
		-- add details for `i' th `result_item' to `result_link_box'
		local
			style_labels: EL_MIXED_STYLE_FIXED_LABELS; detail_lines: like new_detail_lines
		do
			detail_lines := new_detail_lines (result_set [i])
			if detail_lines.count > 0 then
				create style_labels.make_with_styles (detail_lines, style.details_indent, style.font_table, background_color)
				result_link_box.extend_unexpanded (style_labels)
			end
		end

	add_navigable_heading (result_link_box: EL_BOX; i: INTEGER)
		-- add hyperlink for `i' th `result_item' to `result_link_box'
		local
			result_link: EL_HYPERLINK_AREA
		do
			create result_link.make_with_styles (
				new_styled_description (result_set [i]), style.font_table,
				agent call_select_result (result_set, i), background_color
			)
			result_link.set_link_text_color (style.link_text_color)
			result_link_box.extend_unexpanded (result_link)
		end

	add_supplementary (result_link_box: EL_BOX; i: INTEGER)
		-- add supplementary details for `i' th `result_item' to `result_link_box'
		do
		end

	less_than (u, v: G): BOOLEAN
		-- do nothing comparator
		do
		end

feature {NONE} -- Hyperlink actions

	call_select_result (a_result_set: DYNAMIC_CHAIN [G]; a_index: INTEGER)
			--
		do
			select_result (a_result_set, a_index)
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

	select_result: PROCEDURE [CHAIN [G], INTEGER]

	result_set: DYNAMIC_CHAIN [G]

feature {NONE} -- Constants

	Default_disabled_page_link: EL_HYPERLINK_AREA
		once
			create Result.make_default
		end

note
	notes: "[
		The function `new_styled_description' creates a hyperlink description for navigating to the `i_th'
		element of the `result_set' by attempting to make the following casts of type `G' in the order given:

		1. Cast to type [$source EL_DESCRIBEABLE]
		2. Cast to type [$source EL_STYLED_TEXT_LIST]
		3. Cast to type [$source EL_NAMEABLE [READABLE_STRING_GENERAL]]
		3. Cast to type [$source READABLE_STRING_GENERAL]
		4. Cast to type [$source DEBUG_OUTPUT]
		4. Default to using `{ANY}.out' as description

		If `G' conforms to [$source EL_DATEABLE] then a date is displayed below the navigable heading in a "result details"
		section. See routine `new_detail_lines'.

		The `style' attribute [$source EL_SEARCH_RESULTS_STYLE] defines the following properties:

		1. Visual appearance for fonts and colors
		2. The number of links per page
		3. Whether the date is displayed
	]"

end