note
	description: "Module vision 2"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

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