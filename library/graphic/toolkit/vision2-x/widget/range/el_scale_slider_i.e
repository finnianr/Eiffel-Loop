note
	description: "Scale slider i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "4"

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