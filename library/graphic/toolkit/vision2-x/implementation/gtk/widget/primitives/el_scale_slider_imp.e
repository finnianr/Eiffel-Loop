note
	description: "[
		Warning: this implementation was originally written for Windows and may not work on GTK
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_SCALE_SLIDER_IMP

inherit
	EL_SCALE_SLIDER_I
		redefine
			interface
		end

	EV_VERTICAL_RANGE_IMP
		redefine
			interface
		end

create
	make

feature -- Element change

	set_tick_mark (pos: INTEGER)
			--
		do
			interface.set_tick_mark (pos)
		end

	clear_tick_marks
			--
		do
			interface.clear_tick_marks
		end

feature {EV_ANY_I} -- Implementation

	interface: EL_SCALE_SLIDER

end
