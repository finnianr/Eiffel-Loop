note
	description: "Module eiffel"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-12 18:11:17 GMT (Monday 12th November 2018)"
	revision: "6"

class
	EL_MODULE_EIFFEL

inherit
	EL_MODULE

feature {NONE} -- Constants

	Eiffel: INTERNAL
			--
		once
			create Result
		end

end