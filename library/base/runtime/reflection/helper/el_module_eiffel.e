note
	description: "Module eiffel"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-03 11:12:08 GMT (Thursday 3rd October 2019)"
	revision: "9"

deferred class
	EL_MODULE_EIFFEL

inherit
	EL_MODULE

feature {NONE} -- Constants

	Eiffel: EL_INTERNAL
			--
		once
			create Result
		end

end
