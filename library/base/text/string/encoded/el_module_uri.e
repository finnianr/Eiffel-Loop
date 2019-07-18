note
	description: "Module uri"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 12:09:22 GMT (Monday 1st July 2019)"
	revision: "5"

deferred class
	EL_MODULE_URI

inherit
	EL_MODULE

feature {NONE} -- Constants

	URI: EL_URI_ROUTINES_IMP
		once
			create Result
		end

end
