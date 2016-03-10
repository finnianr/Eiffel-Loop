note
	description: "Summary description for {EL_MODULE_IMAGES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-03-21 11:17:05 GMT (Thursday 21st March 2013)"
	revision: "2"

class
	EL_MODULE_IMAGE

inherit
	EL_MODULE

feature -- Access

	Image: EL_APPLICATION_IMAGE
			--
		once
			create Result
		end

end
