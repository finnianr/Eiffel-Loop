note
	description: "Module pattern"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 8:59:00 GMT (Monday 1st July 2019)"
	revision: "7"

deferred class
	EL_MODULE_PATTERN

inherit
	EL_MODULE

feature {NONE} -- Constants

	Pattern: EL_TEXTUAL_PATTERN_MATCH_ROUTINES
			--
		once
			create Result.make
		end

end
