note
	description: "Module eiffel"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-08 15:19:03 GMT (Friday 8th February 2019)"
	revision: "7"

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
