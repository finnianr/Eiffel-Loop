note
	description: "Summary description for {EL_CROSS_PLATFORM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-06 9:09:22 GMT (Thursday 6th June 2013)"
	revision: "2"

class
	EL_CROSS_PLATFORM [I -> EL_PLATFORM_IMPL create default_create end]

inherit
	EL_CROSS_PLATFORM_ABS

feature {NONE} -- Initialization

	make_platform
			--
		do
			create implementation
		end

feature {NONE} -- Implementation

	implementation: I

end
