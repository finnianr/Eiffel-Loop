note
	description: "Summary description for {EL_COLOR_BUTTON}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-05-13 9:26:13 GMT (Monday 13th May 2013)"
	revision: "2"

class
	EL_COLOR_BUTTON

inherit
	EV_BUTTON

	EL_MODULE_GUI
		undefine
			default_create, copy
		end

	EL_MODULE_SCREEN
		undefine
			default_create, copy
		end

create
	make

feature {NONE} -- Initialization

	make (
		a_window: EV_WINDOW; a_title_text: like title_text; a_height, rgb_code: INTEGER; a_set_color_action: like set_color_action
	)
		do
			default_create
			window := a_window; title_text := a_title_text
			create color.make_with_rgb_24_bit (0)

			set_minimum_size (a_height * 2, a_height)
			create color_pixmap.make_with_size (
				(width * Border_proportions.horizontal).rounded, (height * Border_proportions.vertical).rounded
			)
			set_color (rgb_code)

			set_color_action := a_set_color_action
			set_actions
		end

feature -- Element change

	set_color (rgb_code: INTEGER)
		do
			color.set_rgb_with_24_bit (rgb_code)
			color_pixmap.set_background_color (color)
			color_pixmap.clear
			color_pixmap.set_foreground_color (GUI.Dark_gray)
			color_pixmap.draw_straight_line (1, color_pixmap.height - 1, color_pixmap.width, color_pixmap.height - 1)
			color_pixmap.draw_straight_line (color_pixmap.width - 1, 1, color_pixmap.width - 1, color_pixmap.height)
			set_pixmap (color_pixmap)
		end

	set_actions
		do
			select_actions.extend (agent
				local
					dialog: EV_COLOR_DIALOG
				do
					create dialog.make_with_title (title_text.to_unicode)
					dialog.set_color (color)
					dialog.show_modal_to_window (window)
					if dialog.color.rgb_24_bit /= color.rgb_24_bit then
						set_color (dialog.color.rgb_24_bit)
						set_color_action.call ([dialog.color.rgb_24_bit])
					end
				end
			)
--			resize_actions.extend (agent (a_x, a_y, a_width, a_height: INTEGER_32)
--				do
--					if not is_color_initialized and a_height > 10 then
--						set_color (initial_rgb_code)
--						is_color_initialized := True
--					end
--				end
--			)
		end


feature -- Access

	color: EL_COLOR

feature {NONE} -- Implementation

	color_pixmap: EV_PIXMAP

	window: EV_WINDOW

	title_text: EL_ASTRING

	set_color_action: PROCEDURE [ANY, TUPLE [INTEGER]]

	is_color_initialized: BOOLEAN

	Border_proportions: TUPLE [horizontal, vertical: REAL]
		once
			create Result
			if {PLATFORM}.is_windows then
				Result.horizontal := 0.85
				Result.vertical := 0.7
			else
				Result.horizontal := 0.8
				Result.vertical := 0.6
			end
		end

end
