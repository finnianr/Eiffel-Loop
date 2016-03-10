note
	description: "Summary description for {EL_CROSS_PLATFORM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-06 9:09:22 GMT (Thursday 6th June 2013)"
	revision: "2"

class
	EL_CROSS_PLATFORM [I -> EL_PLATFORM_IMPL create make end]

inherit
	EL_CROSS_PLATFORM_ABS

feature {NONE} -- Initialization

	make_default
			--
		do
			create implementation.make
			implementation.set_interface (Current)
		end

feature {NONE} -- Implementation

	implementation: I

end
