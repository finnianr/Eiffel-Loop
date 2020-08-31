note
	description: "Shared instance of class [$source EL_VISION_2_FACTORY]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-31 13:53:39 GMT (Monday 31st August 2020)"
	revision: "9"

deferred class
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
