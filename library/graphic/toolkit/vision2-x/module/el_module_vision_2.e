note
	description: "Summary description for {EL_MODULE_VISION_2}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-24 7:26:30 GMT (Friday 24th June 2016)"
	revision: "6"

class
	EL_MODULE_VISION_2

inherit
	EL_MODULE

feature -- Access

	Vision_2: EL_VISION_2_FACTORY
			--
		once ("PROCESS")
			create Result
		end
end
