note
	description: "Summary description for {EL_SCROLLABLE_AREA}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "5"

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
