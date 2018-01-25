note
	description: "Summary description for {EL_MODULE_NAMING}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-20 11:10:14 GMT (Wednesday 20th December 2017)"
	revision: "2"

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
