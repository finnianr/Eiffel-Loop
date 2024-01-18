note
	description: "Shared access to routines of class ${EL_INTERNAL} and ISE base class ${INTERNAL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-09 12:46:36 GMT (Friday 9th December 2022)"
	revision: "13"

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