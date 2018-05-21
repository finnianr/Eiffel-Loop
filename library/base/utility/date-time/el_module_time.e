note
	description: "Module time"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:21 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_MODULE_TIME

inherit
	EL_MODULE

feature -- Access

	Time: EL_TIME_ROUTINES
			--
		once
			create Result.make
		end

end