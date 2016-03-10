note
	description: "Summary description for {EL_RED_GREEN_STATUS_LIGHTS_DRAWING_AREA}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_RED_GREEN_STATUS_LIGHTS_DRAWING_AREA

inherit
	EV_DRAWING_AREA

create
	make

feature {NONE} -- Initialization

	make (a_green_light, a_red_light, a_unlit_light: EV_PIXMAP; a_border_width: INTEGER)
			--
		do
			default_create
			green_light := a_green_light
			red_light := a_red_light
			unlit_light := a_unlit_light
			border_width := a_border_width
			set_minimum_height (green_light.height + border_width * 2)
			set_minimum_width (green_light.width * 2 + border_width * 6)
			green_light_x := border_width
			red_light_x := border_width * 5 + green_light.width

			set_background_color (Stock_colors.Color_3d_face)

			expose_actions.force_extend (agent clear)
			expose_actions.force_extend (agent redraw_light (green_light, green_light_x))
			expose_actions.force_extend (agent redraw_light (red_light, red_light_x))

		end

feature -- Access

	border_width: INTEGER

feature -- Status query

	is_status_on: BOOLEAN

feature -- Element change

	set_on
			--
		do
			is_status_on := true
			redraw
		end

	set_off
			--
		do
			is_status_on := false
			redraw
		end

feature {NONE} -- Implementation

	redraw_light (light: EV_PIXMAP; pos_x: INTEGER)
			--
		do
			if (light = green_light and then is_status_on) or (light = red_light and then not is_status_on ) then
				draw_pixmap (pos_x, border_width, light)

			else
				draw_pixmap (pos_x, border_width, unlit_light)
			end
		end

	green_light: EV_PIXMAP

	red_light: EV_PIXMAP

	unlit_light: EV_PIXMAP

	green_light_x: INTEGER

	red_light_x: INTEGER

feature {NONE} -- Constants

	Stock_colors: EV_STOCK_COLORS
			--
		once
			create Result
		end

end
