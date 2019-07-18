note
	description: "Module reg key"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 14:17:48 GMT (Monday 1st July 2019)"
	revision: "6"

deferred class
	EL_MODULE_REG_KEY

inherit
	EL_MODULE

feature {NONE} -- Constants

	Reg_key: EL_WEL_REGISTRY_KEYS
		once
			create Result
		end
end
