note
	description: "Module reg key"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "7"

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