note
	description: "Scale slider imp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "5"

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

feature {EV_ANY_I} -- Implementation

	interface: EL_SCALE_SLIDER
	
end