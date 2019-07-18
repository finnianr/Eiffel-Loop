note
	description: "Module time"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 8:53:01 GMT (Monday 1st July 2019)"
	revision: "7"

deferred class
	EL_MODULE_TIME

inherit
	EL_MODULE

feature {NONE} -- Constants

	Time: EL_TIME_ROUTINES
			--
		once
			create Result.make
		end

end
