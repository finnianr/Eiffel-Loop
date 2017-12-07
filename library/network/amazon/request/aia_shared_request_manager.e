note
	description: "Summary description for {AIA_SHARED_REQUEST_MANAGER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-05 12:57:14 GMT (Tuesday 5th December 2017)"
	revision: "1"

class
	AIA_SHARED_REQUEST_MANAGER

feature -- Access

	Request_manager: AIA_REQUEST_MANAGER
		once
			create Result.make
		end
end
