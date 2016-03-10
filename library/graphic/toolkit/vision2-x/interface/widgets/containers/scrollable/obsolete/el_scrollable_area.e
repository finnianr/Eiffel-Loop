note
	description: "Summary description for {EL_SCROLLABLE_AREA}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-05-28 9:19:20 GMT (Tuesday 28th May 2013)"
	revision: "2"

class
	EL_SCROLLABLE_AREA

inherit
	EV_SCROLLABLE_AREA
		redefine
			create_implementation, implementation
		end

create
	default_create

feature {NONE} -- Implementation

	implementation: EL_SCROLLABLE_AREA_I

	create_implementation
			--
		do
			create {EL_SCROLLABLE_AREA_IMP} implementation.make
		end
end
