note
	description: "Shared access to routines of class [$source EL_ITERABLE_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-26 15:54:32 GMT (Sunday 26th December 2021)"
	revision: "4"

deferred class
	EL_MODULE_ITERABLE

inherit
	EL_MODULE

feature {NONE} -- Implementation

	Iterable: EL_ITERABLE_ROUTINES
			--
		once
			create Result
		end
end