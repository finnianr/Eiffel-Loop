note
	description: "Module naming"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:47 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_MODULE_NAMING

inherit
	EL_MODULE

feature {NONE} -- Constants

	Naming: EL_NAMING_ROUTINES
		once
			create Result.make
		end

end
