note
	description: "Scale slider imp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "4"

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