note
	description: "Scale slider i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-21 8:21:17 GMT (Friday 21st December 2018)"
	revision: "5"

deferred class
	EL_SCALE_SLIDER_I

inherit
	EV_VERTICAL_RANGE_I

feature -- Element change

	set_tick_mark (pos: INTEGER)
			-- 
		deferred
		end

	clear_tick_marks
			-- 
		deferred
		end

end