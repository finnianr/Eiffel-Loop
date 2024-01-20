note
	description: "Shared access to instance of class conforming to ${RBOX_DATABASE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "7"

deferred class
	SHARED_DATABASE

inherit
	EL_ANY_SHARED

	EL_MODULE_EXCEPTION

feature {NONE} -- Constants

	Database: RBOX_DATABASE
		once
			Result := create {EL_CONFORMING_SINGLETON [RBOX_DATABASE]}
		end
end