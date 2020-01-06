note
	description: "Aia shared request manager"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:58:29 GMT (Monday 1st July 2019)"
	revision: "4"

deferred class
	AIA_SHARED_REQUEST_MANAGER

inherit
	EL_ANY_SHARED
	
feature -- Access

	Request_manager: AIA_REQUEST_MANAGER
		once
			create Result.make
		end

end
