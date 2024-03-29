note
	description: "Not so silly window"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	EL_TITLED_WINDOW_IMP

inherit
	EL_TITLED_WINDOW_I
		undefine
			propagate_foreground_color, propagate_background_color
		redefine
			interface
		end

	EV_TITLED_WINDOW_IMP
		redefine
			interface
		end

create
	make

feature -- Status query

	has_wide_theme_border: BOOLEAN
		do
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EL_TITLED_WINDOW note option: stable attribute end;

end