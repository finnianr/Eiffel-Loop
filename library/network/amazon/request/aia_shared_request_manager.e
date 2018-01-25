note
	description: "Summary description for {AIA_SHARED_REQUEST_MANAGER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-18 16:56:26 GMT (Monday 18th December 2017)"
	revision: "2"

class
	AIA_SHARED_REQUEST_MANAGER

feature -- Access

	Request_manager: AIA_REQUEST_MANAGER
		once
			create Result.make
		end

end
