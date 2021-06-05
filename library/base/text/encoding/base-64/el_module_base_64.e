note
	description: "Shared access to instance of [$source EL_BASE_64_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-04 7:28:15 GMT (Friday 4th June 2021)"
	revision: "10"

deferred class
	EL_MODULE_BASE_64

inherit
	EL_MODULE

feature {NONE} -- Constants

	Base_64: EL_BASE_64_CODEC
			--
		once
			create Result.make
		end

end