note
	description: "Module uri"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-12 18:16:26 GMT (Monday 12th November 2018)"
	revision: "4"

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
