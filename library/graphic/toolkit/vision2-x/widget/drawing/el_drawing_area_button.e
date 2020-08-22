note
	description: "Drawing area button"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-21 11:06:45 GMT (Friday 21st August 2020)"
	revision: "11"

class
	EL_DRAWING_AREA_BUTTON

inherit
	EL_RECTANGLE
		rename
			make as make_rectangle
		end

	EL_SHARED_BUTTON_STATE

	SD_COLOR_HELPER
		export
			{NONE} all
		undefine
			out
		end

	EL_MODULE_COLOR

	EL_MODULE_PIXMAP

	EL_MODULE_VISION_2

	EL_MODULE_GUI

create
	make

feature {NONE} -- Initialization

	make (a_drawing_area: like drawing_area; a_image_set: like image_set; a_button_press_action: like button_press_action)
		do
			drawing_area := a_drawing_area; image_set := a_image_set; button_press_action := a_button_press_action

			state := Button_state.normal

			make_from_other (a_image_set.drawing_area (state).dimensions)

			drawing_area.pointer_button_press_actions.extend (agent on_pointer_button_press)
			drawing_area.pointer_button_release_actions.extend (agent on_pointer_button_release)
			drawing_area.pointer_motion_actions.extend (agent on_pointer_motion)

			create {STRING} tool_tip.make_empty
			create timer
		end

feature -- Status report

	is_cursor_over: BOOLEAN
		do
			Result := state = Button_state.highlighted or else state = Button_state.depressed
		end

	is_depressed: BOOLEAN
		do
			Result := state = Button_state.depressed
		end

	is_displayed: BOOLEAN

feature -- Status change

	hide
		do
			is_displayed := False
		end

	show
		do
			is_displayed := True
		end

feature -- Element change

	set_tool_tip (a_tool_tip: like tool_tip)
		do
			tool_tip := a_tool_tip
		end

feature -- Basic operations

	draw (drawing: CAIRO_DRAWING_AREA)
		do
			if is_displayed then
				drawing.draw_drawing_area (x, y, image_set.drawing_area (state))
				if is_tooltip_displayed and then not tool_tip.is_empty then
					draw_tooltip (drawing)
				end
			end
		end

feature {NONE} -- Event handlers

	on_pointer_button_press (a_x, a_y, a_button: INTEGER; a_x_tilt, a_y_tilt, a_pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
			--
		do
			if a_button = 1 and is_cursor_over then
				set_state_image (Button_state.depressed)
			end
		end

	on_pointer_button_release (a_x, a_y, a_button: INTEGER a_x_tilt, a_y_tilt, a_pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
			--
		do
			if a_button = 1 and is_depressed then
				set_state_image (Button_state.normal)
				button_press_action.apply
			end
		end

	on_pointer_motion (a_x, a_y: INTEGER; a_x_tilt, a_y_tilt, a_pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
			--
		do
			if is_cursor_over then
				if not has_x_y (a_x, a_y) then
					set_state_image (Button_state.normal)
				end
			else
				if has_x_y (a_x, a_y) then
					set_state_image (Button_state.highlighted)
				end
			end
		end

feature {NONE} -- Implementation

	draw_tooltip (drawing: CAIRO_DRAWING_AREA)
		local
			text_rect: EL_RECTANGLE; l_font: EL_FONT; coord: EV_COORDINATE
		do
			l_font := Vision_2.new_font_regular ("", 0.35)
			coord := drawing_area.pointer_position

			create text_rect.make_for_text (tool_tip, l_font)
			text_rect.grow_left (l_font.descent); text_rect.grow_right (l_font.descent)

			coord.set_x ((coord.x + l_font.descent * 2).min (drawing_area.width - text_rect.width - l_font.descent * 2))
			coord.set_y (coord.y + l_font.descent * 3)
			text_rect.move (coord.x, coord.y)
			drawing.set_color (Tool_tip_color)
			drawing.fill_rectangle (text_rect.x, text_rect.y, text_rect.width, text_rect.height)
			drawing.set_color (color_with_lightness (Tool_tip_color, -0.2).twin)
			drawing.set_line_width (2)
			drawing.draw_rectangle (text_rect.x, text_rect.y, text_rect.width, text_rect.height)

			drawing.set_font (l_font)
			drawing.set_color (Color.Black)
			drawing.draw_text_top_left (text_rect.x + l_font.descent, text_rect.y, tool_tip)
		end

	set_state_image (a_state: NATURAL_8)
		do
			state := a_state
			if state = Button_state.highlighted then
				timer.actions.extend_kamikaze (
					agent
						do
							is_tooltip_displayed := True
							drawing_area.redraw
						end
				)
				timer.set_interval (1200)
				drawing_area.set_pointer_style (Pixmap.Hyperlink_cursor)
			else
				is_tooltip_displayed := False
				timer.set_interval (0)
				drawing_area.set_pointer_style (Pixmap.Standard_cursor)
			end
			drawing_area.redraw
		end

feature {NONE} -- Internal attributes

	button_press_action: PROCEDURE

	drawing_area: EL_DRAWING_AREA_BASE

	image_set: EL_BUTTON_DRAWING_AREA_SET

	is_tooltip_displayed: BOOLEAN

	state: NATURAL_8

	timer: EV_TIMEOUT

	tool_tip: READABLE_STRING_GENERAL

feature {NONE} -- Constants

	Tool_tip_color: EL_COLOR
		once
			Result := 0xF4EFCB
		end

end
