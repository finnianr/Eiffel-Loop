note
	description: "Summary description for {EL_MODULE_BASE_64}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "3"

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
