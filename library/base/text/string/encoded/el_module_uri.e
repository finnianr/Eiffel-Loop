note
	description: "Module uri"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:21 GMT (Saturday 19th May 2018)"
	revision: "2"

class
	EL_MODULE_URI

inherit
	EL_MODULE

feature -- Access

	URI: EL_URI_ROUTINES
		once
			create Result
		end

end
