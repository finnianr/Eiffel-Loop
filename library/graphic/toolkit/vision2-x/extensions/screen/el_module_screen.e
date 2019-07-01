note
	description: "Module screen"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-12 18:16:36 GMT (Monday 12th November 2018)"
	revision: "7"

deferred class
	EL_MODULE_SCREEN

inherit
	EL_MODULE

feature {NONE} -- Constants

	Screen: EL_SCREEN
			--
		once ("PROCESS")
			create Result.make
		end

end
