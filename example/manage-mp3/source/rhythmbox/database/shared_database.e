note
	description: "Shared access to instance of class conforming to [$source RBOX_DATABASE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-17 9:28:57 GMT (Sunday 17th May 2020)"
	revision: "5"

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
