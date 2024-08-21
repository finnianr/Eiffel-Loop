note
	description: "Shared access to routines of class ${EL_ITERABLE_ROUTINES}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-21 8:37:27 GMT (Wednesday 21st August 2024)"
	revision: "9"

deferred class
	EL_MODULE_ITERABLE

inherit
	EL_MODULE

feature {NONE} -- Implementation

	Iterable: EL_ITERABLE_ROUTINES_IMP [ANY]
			--
		once
			create Result
		end
end