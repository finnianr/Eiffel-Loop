note
	description: "Module uri"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-28 10:41:56 GMT (Thursday 28th May 2020)"
	revision: "6"

deferred class
	EL_MODULE_URI

inherit
	EL_MODULE

feature {NONE} -- Constants

	URI: EL_URI_ROUTINES
		once
			create Result
		end

end
