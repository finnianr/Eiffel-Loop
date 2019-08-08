note
	description: "Module geographic"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-05 14:09:19 GMT (Monday 5th August 2019)"
	revision: "1"

deferred class
	EL_MODULE_GEOGRAPHIC

inherit
	EL_MODULE

feature {NONE} -- Constants

	Geographic: EL_GEOGRAPHICAL_ROUTINES
		once
			create Result.make
		end
end
