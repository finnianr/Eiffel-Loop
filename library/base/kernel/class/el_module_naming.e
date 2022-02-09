note
	description: "Shared access to routines of class [$source EL_NAMING_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-08 16:43:45 GMT (Tuesday 8th February 2022)"
	revision: "7"

deferred class
	EL_MODULE_NAMING

inherit
	EL_MODULE

feature {NONE} -- Constants

	Naming: EL_NAMING_ROUTINES
		once
			create Result.make
		end

end