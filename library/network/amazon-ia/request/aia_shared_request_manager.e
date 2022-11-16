note
	description: "Aia shared request manager"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

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