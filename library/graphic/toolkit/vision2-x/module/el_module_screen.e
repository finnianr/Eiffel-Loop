note
	description: "Module screen"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "6"

class
	EL_MODULE_SCREEN

inherit
	EL_MODULE

feature -- Access

	Screen: EL_SCREEN
			--
		once ("PROCESS")
			create Result.make
		end

end
