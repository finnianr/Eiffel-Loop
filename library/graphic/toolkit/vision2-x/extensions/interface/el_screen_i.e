note
	description: "Screen i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "8"

deferred class
	EL_SCREEN_I

inherit
	EV_SCREEN_I
		redefine
			interface
		end

feature -- Access

	color_at_pixel (a_object: EV_POSITIONED; a_x, a_y: INTEGER): EV_COLOR
		deferred
		end

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

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EL_SCREEN note option: stable attribute end;

end