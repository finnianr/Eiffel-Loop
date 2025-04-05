note
	description: "Shared access to routines of class ${EL_INTERNAL} and ISE base class ${INTERNAL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-05 10:04:57 GMT (Saturday 5th April 2025)"
	revision: "16"

deferred class
	EL_MODULE_EIFFEL

inherit
	EL_MODULE

feature {NONE} -- Constants

	Eiffel: EL_EXTENDED_REFLECTOR
			--
		once
			create Result.make
		end

end