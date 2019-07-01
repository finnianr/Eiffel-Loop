note
	description: "Module key"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-21 11:41:53 GMT (Friday 21st December 2018)"
	revision: "7"

deferred class
	EL_MODULE_KEY

inherit
	EL_MODULE

feature {NONE} -- Constants

	Key: EV_KEY_CONSTANTS
		once
			create Result
		end

end
