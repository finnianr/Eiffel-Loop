note
	description: "Module url"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-12 18:16:23 GMT (Monday 12th November 2018)"
	revision: "6"

class
	EL_MODULE_URL

inherit
	EL_MODULE

feature {NONE} -- Constants

	Url: EL_URL_ROUTINES
			-- Url routines using utf-8 encoded file paths
		once
			create Result
		end

end
