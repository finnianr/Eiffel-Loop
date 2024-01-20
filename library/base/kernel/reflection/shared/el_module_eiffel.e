note
	description: "Shared access to routines of class ${EL_INTERNAL} and ISE base class ${INTERNAL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "14"

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