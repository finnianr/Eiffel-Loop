note
	description: "Vision 2 gui routines i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-04 10:16:23 GMT (Friday 4th September 2020)"
	revision: "27"

deferred class
	EL_VISION_2_GUI_ROUTINES_I

inherit
	EV_FRAME_CONSTANTS

	EV_FONT_CONSTANTS

	EL_MODULE_COLOR EL_MODULE_HEXADECIMAL EL_MODULE_PIXMAP

	EL_ZSTRING_CONSTANTS

	EL_SHARED_ONCE_STRING_8
	EL_SHARED_ONCE_STRING_32
	EL_SHARED_ONCE_ZSTRING

feature {NONE} -- Initialization

	make
			--
		do
			create environment
			text_field_font := (create {EV_TEXT_FIELD}).font
			create timer_list.make (3)
		end

feature -- Access

	application: EV_APPLICATION
		do
			Result := environment.application
		end

	environment: EV_ENVIRONMENT

	text_field_background_color: EV_COLOR
		deferred
		end

	text_field_font: EV_FONT

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
			l_font: EL_FONT; i_str, w_str: STRING
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

feature -- Apply styling

	apply_background_color (a_components: ARRAY [EV_COLORIZABLE]; a_color: EV_COLOR)
			--
		do
			a_components.do_all (agent {EV_COLORIZABLE}.set_background_color (a_color))
		end

	apply_bold (font: EV_FONT)
		do
			font.set_weight (Weight_bold)
		end

	apply_foreground_and_background_color (
		a_components: ARRAY [EV_COLORIZABLE]; foreground_color, background_color: EV_COLOR
	)
			--
		do
			apply_foreground_color (a_components, foreground_color)
			apply_background_color (a_components, background_color)
		end

	apply_foreground_color (a_components: ARRAY [EV_COLORIZABLE]; a_color: EV_COLOR)
			--
		do
			a_components.do_all (agent {EV_COLORIZABLE}.set_foreground_color (a_color))
		end

feature -- Basic operations

	block_all (actions: ARRAY [ACTION_SEQUENCE])
		do
			across actions as a loop
				a.item.flush
				a.item.block
			end
		end

	do_later (a_action: PROCEDURE; millisecs_interval: INTEGER_32)
		local
			timer: EV_TIMEOUT
		do
			create timer.make_with_interval (millisecs_interval)
			timer_list.extend (timer)
			timer.actions.extend_kamikaze (a_action)
			timer.actions.extend_kamikaze (agent prune_timer (timer))
		end

	do_once_on_idle (an_action: PROCEDURE)
		do
			application.do_once_on_idle (an_action)
		end

	enable_all_sensitive_if (item_list: ARRAY [EV_SENSITIVE]; condition_true: BOOLEAN)
		do
			item_list.do_all (agent enable_sensitive_if (?, condition_true))
		end

	enable_sensitive_if (widget: EV_SENSITIVE; condition_true: BOOLEAN)
		do
			if condition_true then
				widget.enable_sensitive
			else
				widget.disable_sensitive
			end
		end

	resume_all (actions: ARRAY [ACTION_SEQUENCE])
		do
			actions.do_all (agent {ACTION_SEQUENCE}.resume)
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
			field.set_minimum_width_in_characters (capacity)
		end

feature -- Contract support

	is_word_wrappable (a_text: READABLE_STRING_GENERAL; a_font: EV_FONT; a_width: INTEGER): BOOLEAN
		local
			text: like Once_string
		do
			text := once_copy_general (a_text)
			Result := text.for_all_split (character_string ('%N'),  agent all_words_fit_width (?, a_font, a_width))
		end

	same_fonts (a, b: EV_FONT): BOOLEAN
		do
			Result := a ~ b and then a.name ~ b.name
		end

feature -- Measurement

	box_width_real (border_cms, padding_cms: REAL; widget_widths: ARRAY [REAL]): REAL
		do
			Result := border_cms * 2 + padding_cms * (widget_widths.count - 1)
			across widget_widths as width loop
				Result := Result + width.item
			end
		end

	string_width (string: READABLE_STRING_GENERAL; a_font: EV_FONT): INTEGER
		do
			Result := a_font.string_width (once_copy_general_32 (string))
		end

	widest_width (strings: ITERABLE [READABLE_STRING_GENERAL]; font: EV_FONT): INTEGER
			-- widest string width for font
		local
			width: INTEGER
		do
			across strings as list loop
				width := string_width (list.item, font)
				if width > Result then
					Result := width
				end
			end
		end

feature -- Conversion

	html_code_to_rgb_code (html_code: STRING): INTEGER
		require
			starts_with_hash: html_code.item (1) = '#'
			has_six_digits: html_code.count = 7
		do
			Result := Hexadecimal.to_integer (html_code.substring (2, 7))
		end

	rgb_code_to_html_code (rgb_code: INTEGER): STRING
			-- RGB color code as HTML color code
		do
			Result := rgb_code.to_hex_string
			Result.put ('#', 2)
			Result.remove_head (1)
		end

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
				if string_width (line, a_font) > a_width then
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

feature {NONE} -- Implementation

	all_words_fit_width (line: ZSTRING; a_font: EV_FONT; a_width: INTEGER): BOOLEAN
		do
			Result := line.for_all_split (character_string (' '), agent word_fits_width (?, a_font, a_width))
		end

	prune_timer (timer: EV_TIMEOUT)
		do
			timer.set_interval (0)
			timer_list.prune (timer)
		end

	sort (a_list: ARRAYED_LIST [ZSTRING])
		local
			l_array: SORTABLE_ARRAY [ZSTRING]
		do
			create l_array.make_from_array (a_list.to_array)
			l_array.compare_objects
			l_array.sort
		end

	word_fits_width (word: ZSTRING; a_font: EV_FONT; a_width: INTEGER): BOOLEAN
		do
			Result := string_width (word, a_font) < a_width
		end

feature {NONE} -- Internal attributes

	timer_list: ARRAYED_LIST [EV_TIMEOUT]

end
