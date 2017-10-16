note
	description: "Summary description for {EL_SCROLLABLE_AREA}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
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