note
	description: "Aia shared request manager"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:21 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	AIA_SHARED_REQUEST_MANAGER

feature -- Access

	Request_manager: AIA_REQUEST_MANAGER
		once
			create Result.make
		end

end
