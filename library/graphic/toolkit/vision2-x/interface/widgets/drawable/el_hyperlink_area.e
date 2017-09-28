note
	description: "Summary description for {EL_HYPERLINK_AREA}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-08-10 8:26:01 GMT (Thursday 10th August 2017)"
	revision: "2"

class
	EL_HYPERLINK_AREA

inherit
	EL_DRAWING_AREA_BASE

	EL_MIXED_FONT_STYLEABLE
		rename
			make as make_mixed_font
		undefine
			default_create, copy
		end

	EL_MODULE_SCREEN
		undefine
			default_create, copy
		end

create
	make, make_with_styles, make_default

feature {NONE} -- Initialization

	make_default
		do
			make ("", agent do_nothing, create {EV_FONT}, create {EV_COLOR})
		end

	make (a_text: READABLE_STRING_GENERAL; a_action: PROCEDURE; a_font: EV_FONT; a_background_color: EV_COLOR)
		do
			create styled_text.make (1)
			styled_text.extend (a_text)
			make_with_styles (styled_text, a_font, default_fixed_font (a_font) , a_action, a_background_color)
		end

	make_with_styles (
		a_styled_text: like styled_text; a_font, a_fixed_font: EV_FONT
		a_action: PROCEDURE; a_background_color: EV_COLOR
	)
			--
		do
			styled_text := a_styled_text; action := a_action
			make_mixed_font (a_font, a_fixed_font)
			default_create

			set_background_color (a_background_color)
			link_text_color := GUI.Blue; disabled_link_text_color := GUI.Black

			create text_rect.make (
				0, 0, mixed_style_width (styled_text), bold_font.line_height + bold_font.line_height // 8
			)
			update_size

			is_enabled := true

			set_expose_actions
			pointer_leave_actions.extend (agent on_pointer_leave)
			pointer_motion_actions.extend (agent on_pointer_motion)
			pointer_button_press_actions.extend (agent on_pointer_button_press)
		end

feature -- Status query

	is_enabled: BOOLEAN

	is_selected: BOOLEAN

	is_underlined: BOOLEAN

feature -- Access

	link_text_color: EV_COLOR

	disabled_link_text_color: EV_COLOR

	styled_text: EL_MIXED_STYLE_TEXT_LIST
		-- link text

feature -- Element change

	set_link_text_color (a_link_text_color: like link_text_color)
			--
		do
			link_text_color := a_link_text_color
		end

	set_disabled_link_text_color (a_disabled_link_text_color: like disabled_link_text_color)
			--
		do
			disabled_link_text_color := a_disabled_link_text_color
		end

	set_left_margin (a_width_cms: REAL)
		do
			text_rect.set_x (Screen.horizontal_pixels (a_width_cms))
			update_size
			if is_displayed then
				redraw
			end
		end

	update_size
		do
			set_minimum_size (text_rect.x + text_rect.width, text_rect.height)
		end

feature -- Status change

	set_underlined
			--
		do
			is_underlined := True
		end

	enable
			--
		do
			is_enabled := true
		end

	disable
			--
		do
			is_enabled := false
		end

feature {NONE} -- Event handling

	on_pointer_motion (a_x, a_y: INTEGER; a_x_tilt, a_y_tilt, a_pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
			--
		local
			old_is_selected: BOOLEAN
		do
			old_is_selected := is_selected
			is_selected := is_enabled and then has_pointer
			if old_is_selected /= is_selected then
				if is_selected then
					set_pointer_style (GUI.Hyperlink_cursor)

					-- Link exit not always detected by pointer motion event,
					-- so check a little later if pointer is still over this link
					GUI.do_later (agent check_pointer_still_here, 150)
				else
					set_pointer_style (GUI.Standard_cursor)
				end
				redraw
			end
		end

	on_redraw (a_x, a_y, a_width, a_height: INTEGER)
			--
		local
			l_leading_spaces_width: INTEGER
		do
			clear
			if is_enabled then
				set_foreground_color (link_text_color)
			else
				set_foreground_color (disabled_link_text_color)
			end
			draw_mixed_style_text_top_left (text_rect.x, 0, styled_text)

			if is_underlined or is_selected then
				l_leading_spaces_width := styled_text.first.leading_spaces_width (Current)
				-- We don't want to underline any leading spaces on a right justified fixed width text
				draw_segment (
					text_rect.x + l_leading_spaces_width,
					height - line_width,
					text_rect.x + text_rect.width, 			-- x2
					height - line_width							-- y2
				)
			end
		end

	on_pointer_leave
			--
		do
			set_pointer_style (GUI.Standard_cursor)
			is_selected := False
			redraw
		end

	on_pointer_button_press (
		x_pos, y_pos, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; ascreen_x, ascreen_y: INTEGER
	)
			--
		do
			if button = 1 and then is_selected then
				action.apply
			end
			on_pointer_leave
		end

feature {NONE} -- Implementation

	check_pointer_still_here
		do
			if not has_pointer then
				is_selected := False
				redraw
			end
		end

	has_pointer: BOOLEAN
		do
			Result := text_rect.has (pointer_position)
		end

	text_rect: EV_RECTANGLE

	action: PROCEDURE

end
