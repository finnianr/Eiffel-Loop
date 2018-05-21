note
	description: "Scale slider i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:04 GMT (Saturday 19th May 2018)"
	revision: "3"

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