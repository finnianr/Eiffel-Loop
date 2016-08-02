note
	description: "Summary description for {EL_CROSS_PLATFORM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-24 6:50:09 GMT (Friday 24th June 2016)"
	revision: "1"

class
	EL_CROSS_PLATFORM [I -> EL_PLATFORM_IMPLEMENTATION create default_create end]

feature {NONE} -- Initialization

	make_default
			--
		do
			create implementation
			implementation.set_interface (Current)
			implementation.make
		end

feature {NONE} -- Implementation

	implementation: I

end