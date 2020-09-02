note
	description: "Hyperlink area"
	notes: "[
		An indent can be achieved by including leading spaces in text.
		The active-link underline will not underline leading spaces.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-02 11:20:07 GMT (Wednesday 2nd September 2020)"
	revision: "11"

class
	EL_HYPERLINK_AREA

inherit
	EL_DRAWING_AREA_BASE
		redefine
			on_redraw
		end

	EL_MIXED_FONT_STYLEABLE
		rename
			make as make_mixed_font
		undefine
			default_create, copy
		end

	EL_MODULE_COLOR

	EL_MODULE_PIXMAP

	EL_MODULE_SCREEN

create
	make, make_with_styles, make_default

feature {NONE} -- Initialization

	make (a_text: READABLE_STRING_GENERAL; a_action: PROCEDURE; a_font: EV_FONT; a_background_color: EV_COLOR)
		do
			create styled_text.make (1)
			styled_text.extend (Regular, a_text)
			make_with_styles (styled_text, a_font, default_fixed_font (a_font), a_action, a_background_color)
		end

	make_default
		do
			make ("", agent do_nothing, create {EV_FONT}, create {EV_COLOR})
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
			link_text_color := Color.Blue; disabled_link_text_color := Color.Black

			create text_rect.make (0, 0, mixed_style_width (styled_text), (line_height * 1.2).rounded)
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

	disabled_link_text_color: EV_COLOR

	link_text_color: EV_COLOR

	styled_text: EL_STYLED_TEXT_LIST [READABLE_STRING_GENERAL]

feature -- Element change

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

	set_link_text_color (a_link_text_color: like link_text_color)
			--
		do
			link_text_color := a_link_text_color
		end

	update_size
		do
			set_minimum_size (text_rect.x + text_rect.width, text_rect.height)
		end

feature -- Status change

	disable
			--
		do
			is_enabled := false
		end

	enable
			--
		do
			is_enabled := true
		end

	set_action (a_action: like action)
		do
			action := a_action
		end

	set_underlined
			--
		do
			is_underlined := True
		end

feature {NONE} -- Event handling

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

	on_pointer_leave
			--
		do
			set_pointer_style (Pixmap.Standard_cursor)
			is_selected := False
			redraw
		end

	on_pointer_motion (a_x, a_y: INTEGER; a_x_tilt, a_y_tilt, a_pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
			--
		local
			old_is_selected: BOOLEAN
		do
			old_is_selected := is_selected
			is_selected := is_enabled and then has_pointer
			if old_is_selected /= is_selected then
				if is_selected then
					set_pointer_style (Pixmap.Hyperlink_cursor)

					-- Link exit not always detected by pointer motion event,
					-- so check a little later if pointer is still over this link
					GUI.do_later (agent check_pointer_still_here, 150)
				else
					set_pointer_style (Pixmap.Standard_cursor)
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
				l_leading_spaces_width := leading_spaces_width (styled_text.first_style, styled_text.first_text)
				-- We don't want to underline any leading spaces on a right justified fixed width text
				draw_segment (
					text_rect.x + l_leading_spaces_width,
					height - line_width,
					text_rect.x + text_rect.width, 			-- x2
					height - line_width							-- y2
				)
			end
		end

feature {NONE} -- Implementation

	action: PROCEDURE

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

end
