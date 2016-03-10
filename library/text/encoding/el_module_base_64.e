note
	description: "Summary description for {EL_MODULE_BASE_64}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-14 15:47:12 GMT (Friday 14th June 2013)"
	revision: "2"

class
	EL_MODULE_BASE_64

inherit
	EL_MODULE

feature -- Access

	Base_64: EL_BASE_64_ROUTINES
			--
		once
			create Result
		end

end
