note
	description: "Scale slider i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

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