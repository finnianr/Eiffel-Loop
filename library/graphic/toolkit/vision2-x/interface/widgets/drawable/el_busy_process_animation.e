note
	description: "Summary description for {EL_BUSY_PROCESS_ANIMATION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_BUSY_PROCESS_ANIMATION

inherit
	EV_DRAWING_AREA

create
	make

feature {NONE} -- Initialization

	make (a_static_image: like static_image; a_image_frames: like image_frames; a_border_width: INTEGER)
			--
		do
			default_create
			static_image := a_static_image
			image_frames := a_image_frames
			border_width := a_border_width
			set_minimum_height (static_image.height + border_width * 2)
			set_minimum_width (static_image.width + border_width * 2)

			set_background_color (Stock_colors.Color_3d_face)

			expose_actions.force_extend (agent update_animation)

		end

feature -- Access

	border_width: INTEGER

feature -- Status query

	is_active: BOOLEAN

feature -- Basic operations

	set_active
			--
		do
			is_active := true
			count := 0
			redraw
		end

	set_inactive
			--
		do
			is_active := false
			redraw
		end

	update
			--
		do
			count := count + 1
			redraw
		end

feature {NONE} -- Implementation

	update_animation
			--
		local
			i: INTEGER
		do
			clear
			if is_active then
				i := count \\ image_frames.count + 1
				draw_pixmap (border_width, border_width, image_frames [i])
			else
				draw_pixmap (border_width, border_width, static_image)
			end
		end

	static_image: EV_PIXMAP
		-- inactive process

	image_frames: ARRAY [EV_PIXMAP]

	count: INTEGER
		-- frame count

feature {NONE} -- Constants

	Stock_colors: EV_STOCK_COLORS
			--
		once
			create Result
		end

end
