note
	description: "Summary description for {EL_EV_SCROLLABLE_AREA_IMP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-02-27 18:11:35 GMT (Wednesday 27th February 2013)"
	revision: "2"

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
