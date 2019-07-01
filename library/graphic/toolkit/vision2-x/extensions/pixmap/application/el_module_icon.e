note
	description: "Module icon"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-21 11:36:29 GMT (Friday 21st December 2018)"
	revision: "7"

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
