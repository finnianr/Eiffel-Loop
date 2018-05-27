note
	description: "Screen i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "5"

deferred class
	EL_SCREEN_I

inherit
	EV_SCREEN_I
		redefine
			interface
		end

feature -- Access

	height_mm: INTEGER
		deferred
		end

	width_mm: INTEGER
		deferred
		end

	useable_area: EV_RECTANGLE
			-- useable area not obscured by taskbar
		deferred
		end

	widget_pixel_color (a_widget: EV_WIDGET_IMP; a_x, a_y: INTEGER): EV_COLOR
		require
			has_area: a_widget.height > 0 and a_widget.width > 0
			coords_in_area: a_x >= 0 and a_x < a_widget.width and a_y >=0 and a_y < a_widget.height
		deferred
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EL_SCREEN note option: stable attribute end;

end
