note
	description: "Summary description for {EL_SCREEN_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_SCREEN_I

inherit
	EV_SCREEN_I
		redefine
			interface
		end

feature -- Access

	widget_pixel_color (a_widget: EV_WIDGET_IMP; a_x, a_y: INTEGER): EV_COLOR
		require
			has_area: a_widget.height > 0 and a_widget.width > 0
			coords_in_area: a_x >= 0 and a_x < a_widget.width and a_y >=0 and a_y < a_widget.height
		deferred
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EL_SCREEN note option: stable attribute end;

end
