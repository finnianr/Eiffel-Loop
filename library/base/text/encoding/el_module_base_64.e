note
	description: "Module base 64"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 8:57:09 GMT (Monday 1st July 2019)"
	revision: "7"

deferred class
	EL_MODULE_BASE_64

inherit
	EL_MODULE

feature {NONE} -- Constants

	Base_64: EL_BASE_64_ROUTINES
			--
		once
			create Result
		end

end
