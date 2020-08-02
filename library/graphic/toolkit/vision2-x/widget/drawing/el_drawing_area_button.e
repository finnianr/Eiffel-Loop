note
	description: "Drawing area button"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-02 10:01:50 GMT (Sunday 2nd August 2020)"
	revision: "9"

class
	EL_DRAWING_AREA_BUTTON

inherit
	EL_RECTANGLE
		rename
			make as make_rectangle
		end

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

			state_image := image_set.normal

			make_rectangle (0, 0, state_image.width, state_image.height)

			drawing_area.pointer_button_press_actions.extend (agent on_pointer_button_press)
			drawing_area.pointer_button_release_actions.extend (agent on_pointer_button_release)
			drawing_area.pointer_motion_actions.extend (agent on_pointer_motion)

			create {STRING} tool_tip.make_empty
			create timer
		end

feature -- Status report

	is_cursor_over: BOOLEAN
		do
			Result := state_image = image_set.highlighted or else state_image = image_set.depressed
		end

	is_depressed: BOOLEAN
		do
			Result := state_image = image_set.depressed
		end

	is_displayed: BOOLEAN

feature -- Status change

	show
		do
			is_displayed := True
		end

	hide
		do
			is_displayed := False
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
				drawing.draw_drawing_area (x, y, state_image)
				if is_tooltip_displayed and then not tool_tip.is_empty then
					draw_tooltip (drawing)
				end
			end
		end

feature {NONE} -- Event handlers

	on_pointer_motion (a_x, a_y: INTEGER; a_x_tilt, a_y_tilt, a_pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
			--
		do
			if is_cursor_over then
				if not has_x_y (a_x, a_y) then
					set_state_image (image_set.normal)
				end
			else
				if has_x_y (a_x, a_y) then
					set_state_image (image_set.highlighted)
				end
			end
		end

	on_pointer_button_press (a_x, a_y, a_button: INTEGER; a_x_tilt, a_y_tilt, a_pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
			--
		do
			if a_button = 1 and is_cursor_over then
				set_state_image (image_set.depressed)
			end
		end

	on_pointer_button_release (a_x, a_y, a_button: INTEGER a_x_tilt, a_y_tilt, a_pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
			--
		do
			if a_button = 1 and is_depressed then
				set_state_image (image_set.normal)
				button_press_action.apply
			end
		end

feature {NONE} -- Implementation

	set_state_image (a_state_image: like state_image)
		do
			state_image := a_state_image
			if state_image = image_set.highlighted then
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

	draw_tooltip (drawing: CAIRO_DRAWING_AREA)
		local
			text_rect: EL_RECTANGLE; l_font: EL_FONT; position: EV_COORDINATE
		do
			l_font := Vision_2.new_font_regular ("", 0.35)
			position := drawing_area.pointer_position

			create text_rect.make_for_text (tool_tip, l_font)
			text_rect.grow_left (l_font.descent); text_rect.grow_right (l_font.descent)

			position.set_x ((position.x + l_font.descent * 2).min (drawing_area.width - text_rect.width - l_font.descent * 2))
			position.set_y (position.y + l_font.descent * 3)
			text_rect.move (position.x, position.y)
			drawing.set_color (Tool_tip_color)
			drawing.fill_rectangle (text_rect.x, text_rect.y, text_rect.width, text_rect.height)
			drawing.set_color (color_with_lightness (Tool_tip_color, -0.2).twin)
			drawing.set_line_width (2)
			drawing.draw_rectangle (text_rect.x, text_rect.y, text_rect.width, text_rect.height)

			drawing.set_font (l_font)
			drawing.set_color (Color.Black)
			drawing.draw_text_top_left (text_rect.x + l_font.descent, text_rect.y, tool_tip)
		end

	drawing_area: EL_DRAWING_AREA_BASE

	button_press_action: PROCEDURE

	state_image: CAIRO_DRAWING_AREA

	image_set: EL_PIXEL_BUFFER_SET

	tool_tip: READABLE_STRING_GENERAL

	timer: EV_TIMEOUT

	is_tooltip_displayed: BOOLEAN

feature {NONE} -- Constants

	Tool_tip_color: EL_COLOR
		once
			Result := 0xF4EFCB
		end

end
