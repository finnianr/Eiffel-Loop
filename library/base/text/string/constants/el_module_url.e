note
	description: "Module url"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "5"

class
	EL_MODULE_URL

inherit
	EL_MODULE

feature -- Access

	Url: EL_URL_ROUTINES
			-- Url routines using utf-8 encoded file paths
		once
			create Result
		end

end