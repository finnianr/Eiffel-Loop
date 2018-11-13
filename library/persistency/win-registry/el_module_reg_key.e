note
	description: "Module reg key"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-12 18:08:55 GMT (Monday 12th November 2018)"
	revision: "5"

class
	EL_MODULE_REG_KEY

inherit
	EL_MODULE

feature {NONE} -- Constants

	Reg_key: EL_WEL_REGISTRY_KEYS
		once
			create Result
		end
end
