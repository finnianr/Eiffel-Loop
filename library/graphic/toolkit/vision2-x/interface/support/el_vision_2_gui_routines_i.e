note
	description: "Summary description for {EL_VISION_2_GUI_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-01-28 15:55:42 GMT (Saturday 28th January 2017)"
	revision: "4"

deferred class
	EL_VISION_2_GUI_ROUTINES_I

inherit
	EV_STOCK_COLORS
		rename
			Implementation as Implementation_stock_colors
		end

	EV_STOCK_PIXMAPS
		rename
			Implementation as Implementation_pixmaps
		end

	EV_FRAME_CONSTANTS

	EV_FONT_CONSTANTS

	EL_MODULE_DISPLAY_SCREEN
		rename
			Display_screen as Screen
		export
			{ANY} Screen
		end

	EL_MODULE_LOG

	EL_MODULE_STRING_8

	EL_MODULE_SCREEN
		rename
			Screen as Screen_properties
		end

feature {NONE} -- Initialization

	make
			--
		do
			create environment
			text_field_font := (create {EV_TEXT_FIELD}).font
			create timer_list.make (3)
			busy_widget := Default_busy_widget
		end

feature -- Access

	text_field_background_color: EV_COLOR
		deferred
		end

	text_field_font: EV_FONT

	application: EV_APPLICATION
		do
			Result := environment.application
		end

	environment: EV_ENVIRONMENT

	widget_window (widget: EV_WIDGET): EV_WINDOW
		do
			if attached {EV_WINDOW} widget as window then
				Result := window
			else
				Result := widget_window (widget.parent)
			end
		end

	widget_container (widget: EV_WIDGET): EV_CONTAINER
		do
			if attached {EV_CONTAINER} widget as container then
				Result := container
			else
				Result := widget_container (widget.parent)
			end
		end

feature -- Constants

	General_font_families: ARRAYED_LIST [ZSTRING]
			-- monospace + proportional
		once
			if attached {ARRAYED_LIST [STRING_32]} environment.Font_families as families then
				create Result.make (families.count)
				Result.compare_objects
				from families.start until families.after loop
					Result.extend (families.item)
					families.forth
				end
			end
			sort (Result)
		end

	Monospace_font_families: ARRAYED_LIST [ZSTRING]
			--
		local
			l_font: EL_FONT
			i_str, w_str: STRING
		once
			create Result.make (10)
			Result.compare_objects
			i_str := "i"; w_str := "w"
			across General_font_families as family loop
				create l_font.make_regular (family.item, 0.5)
				if l_font.string_width (i_str) = l_font.string_width (w_str) then
					Result.extend (family.item)
				end
			end
			sort (Result)
		end

feature -- Basic operations

	enable_sensitive_if (item: EV_SENSITIVE; condition_true: BOOLEAN)
		do
			if condition_true then
				item.enable_sensitive
			else
				item.disable_sensitive
			end
		end

	apply_background_color (a_components: ARRAY [EV_COLORIZABLE]; color: EV_COLOR)
			--
		do
			a_components.do_all (agent {EV_COLORIZABLE}.set_background_color (color))
		end

	apply_foreground_color (a_components: ARRAY [EV_COLORIZABLE]; color: EV_COLOR)
			--
		do
			a_components.do_all (agent {EV_COLORIZABLE}.set_foreground_color (color))
		end

	apply_foreground_and_background_color (
		a_components: ARRAY [EV_COLORIZABLE]; foreground_color, background_color: EV_COLOR
	)
			--
		do
			apply_foreground_color (a_components, foreground_color)
			apply_background_color (a_components, background_color)
		end

	do_once_on_idle (an_action: PROCEDURE [ANY, TUPLE])
		do
			application.do_once_on_idle (an_action)
		end

	do_later (a_action: PROCEDURE [ANY, TUPLE]; millisecs_interval: INTEGER_32)
		local
			timer: EV_TIMEOUT
		do
			create timer.make_with_interval (millisecs_interval)
			timer_list.extend (timer)
			timer.actions.extend_kamikaze (a_action)
			timer.actions.extend_kamikaze (agent prune_timer (timer))
		end

	set_selection (widget: EV_SELECTABLE; is_selected: BOOLEAN)
		require
			has_select_actions: attached {EV_BUTTON_ACTION_SEQUENCES} widget or attached {EV_MENU_ITEM_ACTION_SEQUENCES} widget
		local
			select_actions: EV_NOTIFY_ACTION_SEQUENCE
		do
			if attached {EV_BUTTON_ACTION_SEQUENCES} widget as action_sequences then
				select_actions := action_sequences.select_actions

			elseif attached {EV_MENU_ITEM_ACTION_SEQUENCES} widget as action_sequences then
				select_actions := action_sequences.select_actions

			end
			select_actions.block
			if attached {EV_SELECTABLE} widget as selectable_button and then is_selected then
				selectable_button.enable_select

			elseif attached {EV_DESELECTABLE} widget as deselectable_button and then not is_selected then
				deselectable_button.disable_select
			end
			select_actions.resume
		end

	set_text_field_characteristics (field: EV_TEXT_FIELD; capacity: INTEGER; a_font: EV_FONT)
			--
		do
			field.set_font (a_font)
--			field.set_minimum_width (a_font.maximum_width * capacity + a_font.maximum_width // 3)
			field.set_minimum_width_in_characters (capacity)
		end

	propagate_background_color (container: EV_CONTAINER; background_color: EV_COLOR; exclusions: ARRAY [EV_WIDGET])
			-- Propagate background
		require
			 exclusions_comparable_by_reference: not exclusions.object_comparison
		local
			list: LINEAR [EV_WIDGET]
		do
			if not exclusions.has (container) then
				container.set_background_color (background_color)
			end
			list := container.linear_representation
			from list.start until list.after loop
				if attached {EV_CONTAINER} list.item as l_container
					and then not exclusions.has (l_container)
				then
					propagate_background_color (l_container, background_color, exclusions)

				elseif not exclusions.has (list.item) then
					list.item.set_background_color (background_color)
				end
				list.forth
			end
		end

	refresh (a_widget: EV_WIDGET)
		do
			a_widget.refresh_now
			application.process_graphical_events
		end

feature -- Mouse pointer setting

	restore_standard_pointer
		do
			if busy_widget /= Default_busy_widget then
				busy_widget.set_pointer_style (Standard_cursor)
				busy_widget := Default_busy_widget
			end
		end

	set_busy_pointer_for_action (action: PROCEDURE [ANY, TUPLE]; widget: EV_WIDGET; position: INTEGER)
		do
			set_busy_pointer (widget, position)
			do_once_on_idle (action)
			do_once_on_idle (agent restore_standard_pointer)
		end

	set_busy_pointer_for_action_at (action: PROCEDURE [ANY, TUPLE]; widget: EV_WIDGET; position_x_cms, position_y_cms: REAL)
		do
			set_busy_pointer_at (widget, position_x_cms, position_y_cms)
			do_once_on_idle (action)
			do_once_on_idle (agent restore_standard_pointer)
		end

	set_busy_pointer_for_duration (widget: EV_WIDGET; position, duration_seconds: INTEGER)
		do
			set_busy_pointer (widget, position)
			do_later (agent restore_standard_pointer, duration_seconds * 1000)
		end

	set_busy_pointer (widget: EV_WIDGET; position: INTEGER)
		require
			valid_position: valid_relative_position (position)
		do
			inspect position
				when To_left then
					set_busy_pointer_at_position (widget, 0, widget.height // 2)
				when To_right then
					set_busy_pointer_at_position (widget, widget.width, widget.height // 2)
				when To_top then
					set_busy_pointer_at_position (widget, widget.width // 2, 0)
				when To_bottom then
					set_busy_pointer_at_position (widget, widget.width // 2, widget.height)
				when To_center then
					set_busy_pointer_at_position (widget, widget.width // 2, widget.height // 2)
			else
				set_busy_pointer (widget, To_center)
			end
		end

	set_busy_pointer_at (widget: EV_WIDGET; position_x_cms, position_y_cms: REAL)
		do
			set_busy_pointer_at_position (
				widget, Screen_properties.horizontal_pixels (position_x_cms), Screen_properties.vertical_pixels (position_y_cms)
			)
		end

	set_busy_pointer_at_position (widget: EV_WIDGET; position_x, position_y: INTEGER)
		local
			x, y: INTEGER
		do
			x := position_x; y := position_y
			if x = 0 then
				x := Busy_cursor.x_hotspot - Busy_cursor.width
			else
				x := x + Busy_cursor.x_hotspot
			end
			if y = 0 then
				y := Busy_cursor.y_hotspot - Busy_cursor.height
			else
				y := y + Busy_cursor.y_hotspot
			end
			Screen.set_pointer_position (widget.screen_x + x, widget.screen_y  + y)
			busy_widget := widget_container (widget)
			busy_widget.set_pointer_style (Busy_cursor)
		end

feature -- Relative positions

	To_left: INTEGER = 1

	To_right: INTEGER = 2

	To_top: INTEGER = 3

	To_bottom: INTEGER = 4

	To_center: INTEGER = 5

	valid_relative_position (position: INTEGER): BOOLEAN
		do
			Result := position >= 1 and position <= 5
		end

feature -- Contract support

	is_word_wrappable (a_text: ZSTRING; a_font: EV_FONT; a_width: INTEGER): BOOLEAN
		do
			Result := across a_text.split (' ') as word all a_font.string_width (word.item) < a_width end
		end

feature -- Measurement

	widest_width (strings: INDEXABLE [READABLE_STRING_GENERAL, INTEGER]; font: EV_FONT): INTEGER
			-- widest string width for font
		local
			i, count, width: INTEGER
			l_str: READABLE_STRING_GENERAL
		do
			count := strings.upper
			from i := 1 until i > count loop
				l_str := strings [i]
				if attached {ZSTRING} l_str as l_astr then
					l_str := l_astr.to_unicode
				end
				width := font.string_width (l_str)
				if width > Result then
					Result := width
				end
				i := i + 1
			end
		end

	box_width_real (border_cms, padding_cms: REAL; widget_widths: ARRAY [REAL]): REAL
		do
			Result := border_cms * 2 + padding_cms * (widget_widths.count - 1)
			across widget_widths as width loop
				Result := Result + width.item
			end
		end

feature -- Conversion

	word_wrapped (a_text: ZSTRING; a_font: EV_FONT; a_width: INTEGER): ZSTRING
			--
		require
			is_wrappable: is_word_wrappable (a_text, a_font, a_width)
		local
			wrapped_lines, words: EL_ZSTRING_LIST
			line: ZSTRING
		do
			create wrapped_lines.make (10)
			create line.make (60)
			create words.make_with_words (a_text)
			from words.start until words.after loop
				if not line.is_empty then
					line.append_character (' ')
				end
				line.append (words.item)
				if a_font.string_width (line.to_unicode) > a_width then
					line.remove_tail (words.item.count)
					line.right_adjust
					wrapped_lines.extend (line.twin)
					line.wipe_out
				else
					words.forth
				end
			end
			if not line.is_empty then
				wrapped_lines.extend (line)
			end
			Result := wrapped_lines.joined_lines
		end

	rgb_code_to_html_code (rgb_code: INTEGER): STRING
			-- RGB color code as HTML color code
		do
			Result := rgb_code.to_hex_string
			Result.put ('#', 2)
			Result.remove_head (1)
		end

	html_code_to_rgb_code (html_code: STRING): INTEGER
		require
			starts_with_hash: html_code.item (1) = '#'
			has_six_digits: html_code.count = 7
		do
			Result := String_8.hexadecimal_to_integer (html_code.substring (2, 7))
		end

feature {NONE} -- Implementation

	sort (a_list: ARRAYED_LIST [ZSTRING])
		local
			l_array: SORTABLE_ARRAY [ZSTRING]
		do
			create l_array.make_from_array (a_list.to_array)
			l_array.compare_objects
			l_array.sort
		end

	prune_timer (timer: EV_TIMEOUT)
		do
			timer.set_interval (0)
			timer_list.prune (timer)
		end

	timer_list: ARRAYED_LIST [EV_TIMEOUT]

	busy_widget: EV_WIDGET

feature {NONE} -- Constants

	Default_busy_widget: EV_WIDGET
		once
			create {EV_CELL} Result
		end

end
