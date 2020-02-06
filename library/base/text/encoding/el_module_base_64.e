note
	description: "Shared access to instance of [$source EL_BASE_64_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-06 14:01:24 GMT (Thursday 6th February 2020)"
	revision: "8"

deferred class
	EL_MODULE_BASE_64

inherit
	EL_MODULE

feature {NONE} -- Constants

	Base_64: EL_BASE_64_ROUTINES
			--
		once
			create Result
		end

end
