note
	description: "Shared access for instance of [$source EL_ITERABLE_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-25 12:43:41 GMT (Saturday 25th January 2020)"
	revision: "1"

deferred class
	EL_MODULE_ITERABLE

inherit
	EL_MODULE

feature {NONE} -- Constants

	Iterable: EL_ITERABLE_ROUTINES
			--
		once
			create Result
		end
end
