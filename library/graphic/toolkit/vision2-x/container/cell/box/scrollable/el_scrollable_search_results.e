note
	description: "[
		List of scrollable search result hyperlinks for data list conforming to `DYNAMIC_CHAIN [G]'.
		The results are displayed in pages with `links_per_page' defining the number of result hyperlinks per page.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-02 10:44:46 GMT (Wednesday 2nd September 2020)"
	revision: "10"

class
	EL_SCROLLABLE_SEARCH_RESULTS [G -> {EL_HYPERLINKABLE, EL_WORD_SEARCHABLE}]

inherit
	EL_SCROLLABLE_VERTICAL_BOX
		rename
			make as make_scrollable,
			is_empty as is_box_empty
		redefine
			on_key_end, on_key_home
		end

	EL_DATE_FORMATS
		rename
			short_canonical as date_short_canonical,
			canonical as date_canonical
		export
			{NONE} all
			{ANY} Date_formats
		undefine
			is_equal, copy, default_create
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

	make (a_result_selected_action: like result_selected_action; a_links_per_page: INTEGER; a_font, a_fixed_font: EV_FONT)
			--
		do
			make_scrollable (Default_border_cms, Default_border_cms)
			font := a_font
			fixed_font := a_fixed_font

			result_selected_action := a_result_selected_action
			links_per_page := a_links_per_page
			link_text_color := Color.Blue

			create search_words.make (0)
			comparator := Default_comparator
			details_indent := Default_details_indent
			disabled_page_link := Default_disabled_page_link
			set_default_date_format
		end

feature -- Access

	default_comparator: like comparator
		do
			Result := Current
		end

	fixed_font: EV_FONT

	font: EV_FONT

	link_text_color: EV_COLOR

	page: INTEGER
		-- current page of results

feature -- Measurement

	details_indent: INTEGER
		-- left margin for details

	links_per_page: INTEGER

feature -- Element change

	set_comparator (a_comparator: like comparator)
			-- set sort order
		do
			comparator := a_comparator
		end

	set_default_date_format
		do
			set_date_format (Dd_mmm_yyyy)
		end

	set_date_format (a_date_format: like date_format)
		require
			valid_format: not a_date_format.is_empty implies Date_formats.has (a_date_format)
		do
			date_format := a_date_format
		end

	set_details_indent (a_details_indent: like details_indent)
		do
			details_indent := a_details_indent
		end

	set_fixed_font (a_fixed_font: EV_FONT)
		do
			fixed_font := a_fixed_font
		end

	set_font (a_font: EV_FONT)
		do
			font := a_font
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

	set_search_words (a_search_words: like search_words)
		do
			search_words := a_search_words
		end

feature -- Basic operations

	goto_page (a_page: INTEGER)
			--
		local
			l_page_results: like page_results
		do
			page := a_page
			disable_automatic_scrollbar
			wipe_out
			l_page_results := page_results
			across l_page_results as result_link loop
				extend_unexpanded (result_link.item)
			end
			if has_page_links then
				extend_unexpanded (new_navigation_links_box (l_page_results.count))
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

	new_formatted_date (date: DATE): STRING
		do
			Result := Locale.date_text.formatted (date, date_format)
		end

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
					styled (Link_text_previous), font, fixed_font, agent goto_previous_page, background_color
				)
				previous_page_link.set_link_text_color (link_text_color)
				Result.extend_unexpanded (previous_page_link)
			end

			if result_set.count > links_per_page then
				from i := l_lower until i > upper loop
					create page_link.make_with_styles (styled (i.out), font, fixed_font, agent goto_page (i), background_color)
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
					styled (Link_text_next), font, fixed_font, agent goto_next_page, background_color
				)
				next_page_link.set_link_text_color (link_text_color)
				Result.extend_unexpanded (next_page_link)
			end
		end

	new_result_detail_labels (result_item: G): EL_MIXED_STYLE_FIXED_LABELS
			--
		local
			word_match_extracts: like result_set.item.word_match_extracts
			date_line: EL_STYLED_TEXT_LIST [READABLE_STRING_GENERAL]
		do
			word_match_extracts := result_item.word_match_extracts (search_words)
			if attached {EL_DATEABLE} result_item as l_item and then not date_format.is_empty then
				if word_match_extracts.is_empty then
					create date_line.make (1); date_line.extend ({EL_TEXT_STYLE}.Regular, new_formatted_date (l_item.date))
					word_match_extracts.extend (date_line)
				else
					word_match_extracts.first.put_front ({EL_TEXT_STYLE}.Regular, new_formatted_date (l_item.date))
				end
			end
			create Result.make_with_styles (word_match_extracts, details_indent, font, fixed_font, background_color)
		end

feature {NONE} -- Implementation: Routines

	less_than (u, v: G): BOOLEAN
			-- do nothing comparator
		do
		end

	page_results: ARRAY [EL_VERTICAL_BOX]
		local
			result_link: EL_HYPERLINK_AREA; result_link_box: EL_VERTICAL_BOX
			result_item: G; i, l_lower: INTEGER
		do
			l_lower := (page - 1) * links_per_page + 1
			create Result.make_filled (create {EL_VERTICAL_BOX}, l_lower, result_set.count.min (l_lower + links_per_page - 1))
			from i := l_lower until i > Result.upper loop
				result_item := result_set.i_th (i)
				create result_link.make_with_styles (
					result_item.text, font, fixed_font, agent call_selected_action (result_set, i, result_item), background_color
				)
				result_link.set_link_text_color (link_text_color)
				create result_link_box
				result_link_box.set_background_color (background_color)
				result_link_box.extend_unexpanded (result_link)
				result_link_box.extend_unexpanded (new_result_detail_labels (result_item))
				Result [i] := result_link_box
				i := i + 1
			end
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

	date_format: STRING

	disabled_page_link: EL_HYPERLINK_AREA

	page_count: INTEGER

	result_selected_action: PROCEDURE [CHAIN [G], INTEGER, G]

	result_set: DYNAMIC_CHAIN [G]

	search_words: ARRAYED_LIST [EL_WORD_TOKEN_LIST]

feature {NONE} -- Constants

	Default_border_cms: REAL
			--
		once
			Result := 0.5
		end

	Default_details_indent: INTEGER
		once
			Result := 0
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

	Link_text_next: ZSTRING
		once
			Result := Locale * "Next"
		end

	Link_text_previous: ZSTRING
		once
			Result := Locale * "Previous"
		end

end
