note
	description: "Summary description for {EL_VISION_2_FACTORY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-24 8:36:07 GMT (Friday 24th June 2016)"
	revision: "1"

class
	EL_VISION_2_FACTORY

inherit
	EV_FRAME_CONSTANTS
		export
			{NONE} all
		end

	EV_FONT_CONSTANTS
		export
			{NONE} all
		end

	EL_MODULE_GUI
		export
			{NONE} all
		end

feature -- Factory

	new_color (a_rgb_24_bit: INTEGER): EL_COLOR
		do
			create Result.make_with_rgb_24_bit (a_rgb_24_bit)
		end

	new_font_regular (a_families_list: STRING; a_height_cms: REAL): EL_FONT
			-- families separated by ';'
		do
			create Result.make_regular ("", a_height_cms) -- Adds to preferred_families
			across a_families_list.split (';') as family loop
				Result.preferred_families.extend (family.item)
			end
		end

	new_font_bold (a_families_list: STRING; a_height_cms: REAL): EL_FONT
			-- families separated by ';'
		do
			Result := new_font_regular (a_families_list, a_height_cms)
			Result.set_weight (Weight_bold)
		end

	new_label (a_text: READABLE_STRING_GENERAL): EV_LABEL
			--
		local
			l_text: READABLE_STRING_GENERAL
		do
			if attached {ZSTRING} a_text as astring then
				l_text := astring.to_unicode
			else
				l_text := a_text
			end
			create Result.make_with_text (l_text)
			Result.align_text_left
		end

	new_label_with_font (a_text: READABLE_STRING_GENERAL; a_font: EV_FONT): EV_LABEL
			--
		do
			Result := new_label (a_text)
			Result.set_font (a_font)
		end

	new_label_with_font_and_color (a_text: READABLE_STRING_GENERAL; a_font: EV_FONT; a_text_color: EV_COLOR): EV_LABEL
			--
		do
			Result := new_label_with_font (a_text, a_font)
			Result.set_foreground_color (a_text_color)
		end

	new_horizontal_framed_box (
		inner_border_cms, a_padding_cms: REAL; a_text: STRING; a_widgets: ARRAY [EV_WIDGET]
	): EL_FRAME [EL_HORIZONTAL_BOX]
			--
		do
 			create Result.make_with_text (inner_border_cms, a_padding_cms, a_text)
 			Result.box.append_unexpanded (a_widgets)
		end

	new_horizontal_box (a_border_cms, a_padding_cms: REAL; a_widgets: ARRAY [EV_WIDGET]): EL_HORIZONTAL_BOX
			--
		do
 			create Result.make (a_border_cms, a_padding_cms)
 			Result.append_unexpanded (a_widgets)
		end

	new_menu_entry (a_text: ZSTRING; an_action: PROCEDURE [ANY, TUPLE]): EV_MENU_ITEM
		local
			l_text: ZSTRING
		do
			l_text := a_text
			create Result.make_with_text_and_action (l_text, an_action)
		end

	new_password_field (capacity: INTEGER): EV_PASSWORD_FIELD
			--
		do
			Result := new_password_field_with_font (capacity, GUI.text_field_font)
		end

	new_password_field_with_font (capacity: INTEGER; a_font: EV_FONT): EV_PASSWORD_FIELD
			--
		do
			create Result
			GUI.set_text_field_characteristics (Result, capacity, a_font)
		end

	new_text_field (capacity: INTEGER): EV_TEXT_FIELD
			--
		do
			Result := new_text_field_with_font (capacity, GUI.text_field_font)
		end

	new_text_field_with_font (capacity: INTEGER; a_font: EV_FONT): EV_TEXT_FIELD
			--
		do
			create Result
			GUI.set_text_field_characteristics (Result, capacity, a_font)
		end

	new_text_rectangle (a_x, a_y, a_width, a_height: INTEGER): EL_TEXT_RECTANGLE_I
		do
			create {EL_TEXT_RECTANGLE_IMP} Result.make (a_x, a_y, a_width, a_height)
		end

	new_text_rectangle_from_rectangle (rectangle: EL_RECTANGLE): EL_TEXT_RECTANGLE_I
		do
			create {EL_TEXT_RECTANGLE_IMP} Result.make_from_rectangle (rectangle)
		end

	new_vertical_box (a_border_cms, a_padding_cms: REAL; a_widgets: ARRAY [EV_WIDGET]): EL_VERTICAL_BOX
			--
		do
 			create Result.make (a_border_cms, a_padding_cms)
 			Result.append_unexpanded (a_widgets)
		end

	new_vertical_centered_box (a_border_cms, a_padding_cms: REAL; a_widgets: ARRAY [EV_WIDGET]): EL_VERTICAL_BOX
			--
		do
 			create Result.make (a_border_cms, a_padding_cms)
 			Result.extend (create {EV_CELL})
 			Result.append_unexpanded (a_widgets)
 			Result.extend (create {EV_CELL})
		end

	new_vertical_framed_box (
		inner_border_cms, a_padding_cms: REAL; a_text: STRING; a_widgets: ARRAY [EV_WIDGET]
	): EL_FRAME [EL_VERTICAL_BOX]
			--
		do
 			create Result.make_with_text (inner_border_cms, a_padding_cms, a_text)
 			Result.box.append_unexpanded (a_widgets)
		end

end