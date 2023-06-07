note
	description: "Module uri"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-07 13:24:26 GMT (Wednesday 7th June 2023)"
	revision: "8"

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