note
	description: "Summary description for {EL_MODULE_REG_KEY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-10-10 8:50:06 GMT (Monday 10th October 2016)"
	revision: "1"

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
