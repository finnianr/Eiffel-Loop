note
	description: "Module icon"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 9:23:03 GMT (Monday 1st July 2019)"
	revision: "8"

deferred class
	EL_MODULE_ICON

inherit
	EL_MODULE

feature {NONE} -- Constants

	Icon: EL_APPLICATION_ICON
			--
		once
			create Result
		end

end
