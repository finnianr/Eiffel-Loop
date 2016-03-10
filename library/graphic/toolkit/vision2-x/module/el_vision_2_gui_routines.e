note
	description: "Summary description for {EL_VISION_2_GUI_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-03-23 16:04:48 GMT (Sunday 23rd March 2014)"
	revision: "5"

class
	EL_VISION_2_GUI_ROUTINES

inherit
	EL_CROSS_PLATFORM [EL_VISION_2_GUI_ROUTINES_IMPL]
		export
			{NONE} all
		end

	EL_MODULE_STRING
		export
			{NONE} all
		end

	EL_MODULE_LOG
		export
			{NONE} all
		end

	EV_STOCK_COLORS
		rename
			Implementation as Stock_colors_implementation
		end

	EV_STOCK_PIXMAPS
		rename
			Implementation as Implementation_pixmaps
		end

	EV_FRAME_CONSTANTS

	EV_FONT_CONSTANTS

	EL_MODULE_SCREEN
		rename
			Screen as Screen_properties
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_platform
			create environment
			text_field_background_color := Implementation.text_field_background_color
			text_field_font := (create {EV_TEXT_FIELD}).font
			create keys
			create screen
		end

feature -- Access

	text_field_background_color: EV_COLOR

	text_field_font: EV_FONT

	keys: EV_KEY_CONSTANTS

	screen: EL_SCREEN
		-- Inherits EV_SCREEN

	application: EV_APPLICATION
		do
			Result := environment.application
		end

	environment: EV_ENVIRONMENT

feature -- Constants

	General_font_families: ARRAYED_LIST [EL_ASTRING]
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

	Monospace_font_families: ARRAYED_LIST [EL_ASTRING]
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

feature -- Component factory

	color_from_rgb_code (a_rgb_24_bit: INTEGER): EL_COLOR
		do
			create Result.make_with_rgb_24_bit (a_rgb_24_bit)
		end

	label (a_text: READABLE_STRING_GENERAL): EV_LABEL
			--
		local
			l_text: READABLE_STRING_GENERAL
		do
			if attached {EL_ASTRING} a_text as astring then
				l_text := astring.to_unicode
			else
				l_text := a_text
			end
			create Result.make_with_text (l_text)
			Result.align_text_left
		end

	label_with_font (a_text: READABLE_STRING_GENERAL; a_font: EV_FONT): EV_LABEL
			--
		do
			Result := label (a_text)
			Result.set_font (a_font)
		end

	label_with_font_and_color (a_text: READABLE_STRING_GENERAL; a_font: EV_FONT; a_text_color: EV_COLOR): EV_LABEL
			--
		do
			Result := label_with_font (a_text, a_font)
			Result.set_foreground_color (a_text_color)
		end

	horizontal_framed_box (
		inner_border_cms, a_padding_cms: REAL; a_text: STRING; a_widgets: ARRAY [EV_WIDGET]
	): EL_FRAME [EL_HORIZONTAL_BOX]
			--
		do
 			create Result.make_with_text (inner_border_cms, a_padding_cms, a_text)
 			Result.box.append_unexpanded (a_widgets)
		end

	horizontal_box (a_border_cms, a_padding_cms: REAL; a_widgets: ARRAY [EV_WIDGET]): EL_HORIZONTAL_BOX
			--
		do
 			create Result.make (a_border_cms, a_padding_cms)
 			Result.append_unexpanded (a_widgets)
		end

	menu_entry (a_text: EL_ASTRING; an_action: PROCEDURE [ANY, TUPLE]): EV_MENU_ITEM
		local
			l_text: EL_ASTRING
		do
			l_text := a_text
			if Screen_properties.is_windows_aero_theme_active then
--				Work around for bug in Windows 7 where last letter is partially obscured
				l_text := a_text + " "
			end
			create Result.make_with_text_and_action (l_text, an_action)
		end

	password_field (capacity: INTEGER): EV_PASSWORD_FIELD
			--
		do
			Result := password_field_with_font (capacity, text_field_font)
		end

	password_field_with_font (capacity: INTEGER; a_font: EV_FONT): EV_PASSWORD_FIELD
			--
		do
			create Result
			set_text_field_characteristics (Result, capacity, a_font)
		end

	text_field (capacity: INTEGER): EV_TEXT_FIELD
			--
		do
			Result := text_field_with_font (capacity, text_field_font)
		end

	text_field_with_font (capacity: INTEGER; a_font: EV_FONT): EV_TEXT_FIELD
			--
		do
			create Result
			set_text_field_characteristics (Result, capacity, a_font)
		end

	vertical_box (a_border_cms, a_padding_cms: REAL; a_widgets: ARRAY [EV_WIDGET]): EL_VERTICAL_BOX
			--
		do
 			create Result.make (a_border_cms, a_padding_cms)
 			Result.append_unexpanded (a_widgets)
		end

	vertical_framed_box (
		inner_border_cms, a_padding_cms: REAL; a_text: STRING; a_widgets: ARRAY [EV_WIDGET]
	): EL_FRAME [EL_VERTICAL_BOX]
			--
		do
 			create Result.make_with_text (inner_border_cms, a_padding_cms, a_text)
 			Result.box.append_unexpanded (a_widgets)
		end

feature -- Font factory

	font_regular (a_families_list: STRING; a_height_cms: REAL): EL_FONT
			-- families separated by ';'
		do
			across a_families_list.split (';') as family loop
				if family.cursor_index = 1 then
					create Result.make_regular (family.item, a_height_cms) -- Adds to preferred_families
				else
					Result.preferred_families.extend (family.item)
				end
			end
		end

	font_bold (a_families_list: STRING; a_height_cms: REAL): EL_FONT
			-- families separated by ';'
		do
			Result := font_regular (a_families_list, a_height_cms)
			Result.set_weight (Weight_bold)
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

	do_later (a_action: PROCEDURE [ANY, TUPLE]; an_interval: INTEGER_32)
		local
			timer: EV_TIMEOUT
		do
			create timer
			timer.actions.extend_kamikaze (a_action)
			timer.set_interval (an_interval)
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

feature -- Contract support

	is_word_wrappable (a_text: EL_ASTRING; a_font: EV_FONT; a_width: INTEGER): BOOLEAN
		do
			Result := across a_text.split (' ') as word all a_font.string_width (word.item) < a_width end
		end

feature -- Measurement

	widest_width (strings: INDEXABLE [READABLE_STRING_GENERAL, INTEGER]; font: EV_FONT): INTEGER
			-- widest string width for font
		local
			i, count: INTEGER
			l_str: READABLE_STRING_GENERAL
		do
			count := strings.index_set.upper
			from i := 1 until i > count loop
				l_str := strings [i]
				if attached {EL_ASTRING} l_str as l_astr then
					l_str := l_astr.to_unicode
				end
				if font.string_width (l_str) > Result then
					Result := font.string_width (l_str)
				end
				i := i + 1
			end
		end

feature -- Conversion

	word_wrapped (a_text: EL_ASTRING; a_font: EV_FONT; a_width: INTEGER): EL_ASTRING
			--
		require
			is_wrappable: is_word_wrappable (a_text, a_font, a_width)
		local
			wrapped_lines, words: EL_STRING_LIST [EL_ASTRING]
			line: EL_ASTRING
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
			Result.remove_head (1)
			Result.put ('#', 1)
		end

	html_code_to_rgb_code (html_code: STRING): INTEGER
		require
			starts_with_hash: html_code.item (1) = '#'
			has_six_digits: html_code.count = 7
		do
			Result := String.hexadecimal_to_integer (html_code.substring (2, 7))
		end

feature {NONE} -- Implementation

	sort (a_list: ARRAYED_LIST [EL_ASTRING])
		local
			l_array: SORTABLE_ARRAY [EL_ASTRING]
		do
			create l_array.make_from_array (a_list.to_array)
			l_array.compare_objects
			l_array.sort
		end

end
