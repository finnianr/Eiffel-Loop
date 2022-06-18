note
	description: "Shared access to routines of class [$source EL_NAMING_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-16 18:36:57 GMT (Thursday 16th June 2022)"
	revision: "8"

deferred class
	EL_MODULE_NAMING

inherit
	EL_MODULE

feature {NONE} -- Constants

	Naming: EL_NAMING_ROUTINES
		once
			create Result
		end

end