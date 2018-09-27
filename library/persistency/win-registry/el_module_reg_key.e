note
	description: "Module reg key"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EL_MODULE_REG_KEY

inherit
	EL_MODULE

feature -- Access

	Reg_key: EL_WEL_REGISTRY_KEYS
		once
			create Result
		end
end
