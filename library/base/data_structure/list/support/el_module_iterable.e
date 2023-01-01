note
	description: "Shared access to routines of class [$source EL_ITERABLE_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-01 13:57:12 GMT (Sunday 1st January 2023)"
	revision: "6"

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