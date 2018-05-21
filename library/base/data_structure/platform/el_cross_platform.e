note
	description: "Cross platform"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "3"

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