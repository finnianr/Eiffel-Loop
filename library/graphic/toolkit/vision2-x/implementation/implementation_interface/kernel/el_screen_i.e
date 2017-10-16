note
	description: "Summary description for {EL_SCREEN_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

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