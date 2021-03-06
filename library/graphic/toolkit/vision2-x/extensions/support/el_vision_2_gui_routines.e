note
	description: "[
		Vision 2 giving access to various shared objects and routines related to
		
		* Fonts and font string measurement
		* Word wrapping
		* Color code conversion
		* Action management
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-08 18:19:02 GMT (Friday 8th January 2021)"
	revision: "31"

class
	EL_VISION_2_GUI_ROUTINES

inherit
	EV_SHARED_APPLICATION
		export
			{NONE} process_events_and_idle
		end

	EV_FONT_CONSTANTS

	EV_FRAME_CONSTANTS

	EL_MODULE_COLOR EL_MODULE_HEXADECIMAL EL_MODULE_PIXMAP

	EL_MODULE_BUFFER_8
	EL_MODULE_BUFFER_32

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			text_field_font := (create {EV_TEXT_FIELD}).font
			application := ev_application
			create timer_list.make (3)
		end

feature -- Access

	application: EV_APPLICATION

feature -- Font

	text_field_font: EV_FONT

	word_wrapped (a_text: ZSTRING; a_font: EV_FONT; a_width: INTEGER): EL_ZSTRING_LIST
		-- string word wrapped with `a_font' across `a_width'
		require
			is_wrappable: is_word_wrappable (a_text, a_font, a_width)
		local
			words: EL_SPLIT_ZSTRING_LIST; line: ZSTRING; s: EL_ZSTRING_ROUTINES
		do
			create Result.make (10)
			create line.make (60)
			create words.make (a_text, s.character_string (' '))
			from words.start until words.after loop
				if not line.is_empty then
					line.append_character (' ')
				end
				line.append (words.item (False))
				if string_width (line, a_font) > a_width then
					line.remove_tail (words.item_count)
					line.right_adjust
					Result.extend (line.twin)
					line.wipe_out
				else
					words.forth
				end
			end
			if not line.is_empty then
				Result.extend (line)
			end
		end

	General_font_families: ARRAYED_LIST [ZSTRING]
		-- monospace + proportional
		once
			if attached {LIST [STRING_32]} shared_environment.Font_families as families then
				create Result.make (families.count)
				Result.compare_objects
				across families as family loop
					Result.extend (family.item)
				end
			end
			sort (Result)
		end

	Monospace_font_families: ARRAYED_LIST [ZSTRING]
		--
		local
			l_font: EV_FONT; i_str, w_str: STRING
		once
			create l_font
			i_str := "i"; w_str := "w"
			if attached {LIST [STRING_32]} shared_environment.Font_families as families then
				create Result.make (families.count // 10)
				Result.compare_objects
				across families as family loop
					l_font.preferred_families.wipe_out
					l_font.preferred_families.extend (family.item)
					if l_font.string_width (i_str) = l_font.string_width (w_str) then
						Result.extend (family.item)
					end
				end
			end
			sort (Result)
		end

feature -- Action management

	block_all (actions: ARRAY [ACTION_SEQUENCE])
		do
			across actions as a loop
				a.item.flush
				a.item.block
			end
		end

	do_later (millisecs_interval: INTEGER_32; a_action: PROCEDURE)
		local
			timer: EV_TIMEOUT
		do
			create timer.make_with_interval (millisecs_interval)
			timer_list.extend (timer)
			timer.actions.extend (agent do_once_action (timer, a_action))
		end

	do_once_on_idle (an_action: PROCEDURE)
		do
			application.do_once_on_idle (an_action)
		end

	resume_all (actions: ARRAY [ACTION_SEQUENCE])
		do
			actions.do_all (agent {ACTION_SEQUENCE}.resume)
		end

feature -- Contract support

	is_word_wrappable (a_text: READABLE_STRING_GENERAL; a_font: EV_FONT; a_width: INTEGER): BOOLEAN
		local
			text: ZSTRING; buffer: EL_ZSTRING_BUFFER_ROUTINES; s: EL_ZSTRING_ROUTINES
		do
			text := buffer.copied_general (a_text)
			Result := text.for_all_split (s.character_string ('%N'),  agent all_words_fit_width (?, a_font, a_width))
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
			Result := a_font.string_width (buffer_32.copied_general (string))
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

feature -- Color code

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

feature {NONE} -- Implementation

	all_words_fit_width (line: ZSTRING; a_font: EV_FONT; a_width: INTEGER): BOOLEAN
		local
			s: EL_ZSTRING_ROUTINES
		do
			Result := line.for_all_split (s.character_string (' '), agent word_fits_width (?, a_font, a_width))
		end

	do_once_action (timer: EV_TIMEOUT; action: PROCEDURE)
		do
			timer.actions.block
			timer_list.prune (timer)
			action.apply
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