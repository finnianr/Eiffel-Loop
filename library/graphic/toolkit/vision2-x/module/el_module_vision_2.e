note
	description: "Module vision 2"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-12 18:16:46 GMT (Monday 12th November 2018)"
	revision: "6"

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
