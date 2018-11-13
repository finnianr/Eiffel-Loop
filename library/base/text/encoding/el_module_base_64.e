note
	description: "Module base 64"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-12 18:11:24 GMT (Monday 12th November 2018)"
	revision: "6"

class
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
