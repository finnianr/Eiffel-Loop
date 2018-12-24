note
	description: "Module vision 2"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-21 12:06:12 GMT (Friday 21st December 2018)"
	revision: "7"

class
	EL_MODULE_VISION_2

inherit
	EL_MODULE

feature {NONE} -- Constants

	Vision_2: EL_VISION_2_FACTORY
			--
		once ("PROCESS")
			create Result
		end
end
