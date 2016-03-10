note
	description: "Summary description for {EL_EV_SCROLLABLE_AREA_IMP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_SCROLLABLE_AREA_IMP

inherit
	EL_SCROLLABLE_AREA_I
		undefine
			propagate_foreground_color, propagate_background_color
		redefine
			interface
		end

	EV_SCROLLABLE_AREA_IMP
		redefine
			interface
		end

create
	make

feature {EV_ANY, EV_ANY_I} -- Implementation		

	interface: detachable EL_SCROLLABLE_AREA note option: stable attribute end;

end
