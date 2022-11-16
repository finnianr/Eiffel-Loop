note
	description: "Shared access to routines of class [$source EL_TIME_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "10"

deferred class
	EL_MODULE_TIME

inherit
	EL_MODULE

feature {NONE} -- Constants

	Time: EL_TIME_ROUTINES
			--
		once
			create Result.make
		end

end